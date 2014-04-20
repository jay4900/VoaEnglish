//
//  DataManager.m
//  VoaEnglish
//
//  Created by Wufei on 14-4-18.
//  Copyright (c) 2014年 Lion. All rights reserved.
//

#import "DataManager.h"
#import <CommonCrypto/CommonDigest.h>
#import "TFHpple.h"

static DataManager *obj;
@implementation DataManager

@synthesize channelsDic;
@synthesize voaPath;
+ (id)shared
{
    if (obj == nil) {
        obj = [[DataManager alloc] init];
    }
    return obj;
}

- (id)init
{
    if (self = [super init]) {
//        channelsDic = @{@"VOA Special English": @[@"Technology Report", @"This is America", @"Agriculture Report", @"Science in the News", @"Health Report", @"Explorations", @"Education Report", @"The Making of a Nation", @"Economics Report", @"American Mosaic", @"In the News", @"American Stories", @"Words And Their Stories", @"People in America", @"AS IT IS"],
//        @"VOA Standard English": @[@"Audio News", @"Video News"],
//        @"VOA Learning English": @[@"Bilingual News", @"English in a Minute", @"Learn A Word", @"How to Say it", @"Business Etiquette", @"Words And Idioms", @"American English Mosaic", @"Popular American", @"Sports English", @"Go English", @"Wordmaster", @"American Cafe", @"Intermediate American Enlish"]};
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Channels" ofType:@"plist"];
        channelsDic = [[NSDictionary alloc] initWithContentsOfFile:path];
        [self createFolders];
        NSLog(@"%@",NSHomeDirectory());
        
    }
    return self;
}

- (void)createFolders
{
    BOOL isDir = YES;
    voaPath = [DOCUMENTS stringByAppendingPathComponent:@"VOA"];
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:voaPath isDirectory:&isDir]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:voaPath withIntermediateDirectories:NO attributes:nil error:nil];
        NSURL *url = [NSURL fileURLWithPath:voaPath isDirectory:YES];
        [url setResourceValue: [NSNumber numberWithBool: YES]
                       forKey: NSURLIsExcludedFromBackupKey error:nil];
    }
}

- (NSMutableArray *)getDetailListOfChannel:(NSString *)channel
{
    NSMutableArray *detailLists = nil;
    NSString *path = [voaPath stringByAppendingPathComponent:[channel stringByAppendingPathExtension:@"plist"]];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        detailLists = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }else{
        NSDictionary *dic = [channelsDic objectForKey:channel];
        detailLists = [[NSMutableArray alloc] initWithArray:[dic allKeys]];
        [detailLists writeToFile:path atomically:YES];
    }
    
    return detailLists;
}

- (NSMutableArray *)getArticleListOfDetailChannel:(NSString *)detailChannel InChannel:(NSString *)channel
{
    NSString *path = [voaPath stringByAppendingPathComponent:[detailChannel stringByAppendingPathExtension:@"plist"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSMutableArray *articleList = [[NSMutableArray alloc] initWithContentsOfFile:path];
        return articleList;
    }else{
        NSMutableArray *articleList = [[NSMutableArray alloc] init];
        NSDictionary *dic = channelsDic[channel];
        NSString *surl = [NSString stringWithFormat:@"http://m.easyvoa.com/wap.php?action=list&id=%@&pageno=1",dic[detailChannel]];
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:surl]];
        NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data encoding:@"utf-8"];
        NSArray *items = [hpple searchWithXPathQuery:@"/html/body/div[3]/ul/li/a"];
        for (TFHppleElement *item in items) {
            NSString *title = [[item firstChild] content];
            NSString *href = [[item attributes] objectForKey:@"href"];
            NSString *state = @"NoFile";
            NSArray *arr = @[title, href, state];
            [articleList addObject:arr];
        }
        [articleList writeToFile:path atomically:YES];
        return articleList;
    }
}

- (NSString *)getMp3UrlOfArticle:(NSMutableArray *)articleArr
{
    NSString *title = articleArr[0];
    NSString *href = articleArr[1];
    NSString *surl = [NSString stringWithFormat:@"http://m.easyvoa.com/%@",href];
    NSURL *url = [NSURL URLWithString:surl];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLResponse *respone = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&respone error:nil];
    
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data encoding:@"utf-8"];
    NSArray *textItems = [hpple searchWithXPathQuery:@"//*[@id='ShowEN']/p/text()"];
    NSString *text = @"";
    for (TFHppleElement *item in textItems) {
        text = [text stringByAppendingString:[[item content] stringByAppendingString:@"\n"]];
    }
    NSString *name = [self createMD5:title];
    NSString *path = [voaPath stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"txt"]];
//    [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    NSArray *hrefItems = [hpple searchWithXPathQuery:@"/html/body/div[5]/ul/li/div/a/attribute::href"];
    NSString *hrefStr = [[[hrefItems firstObject] firstChild] content];
    return hrefStr;
}

- (NSString *)createMD5:(NSString *)aString
{
    const char *utf8string =[aString UTF8String];
    unsigned char array[16];
    CC_MD5(utf8string, strlen(utf8string), array);
    
    NSString *md5str = [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",array[0],array[1],array[2],array[3],array[4],array[5],array[6], array[7],array[8],array[9],array[10],array[11],array[12],array[13],array[14],array[15]];
//    NSLog(@"------------------------%@",md5str);
    return md5str;
}

- (void)parseVoaList
{
    NSURL *url=[NSURL URLWithString:@"http://m.easyvoa.com/wap.php?action=list&id=2&pageno=1"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLResponse *respone = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&respone error:nil];
    NSLog(@"%u",[data length]);
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data encoding:@"utf-8"];
    NSArray *items = [hpple searchWithXPathQuery:@"/html/body/div[3]/ul/li/a"];
    //    NSString *title = [[[items firstObject] firstChild] content];
    //    NSDictionary *dic = (NSDictionary *)[[items firstObject] attributes];
    //
    //    NSLog(@"%@",[dic objectForKey:@"href"]);
    
    for (TFHppleElement *item in items) {
        NSString *title = [[item firstChild] content];
        NSString *href = [[item attributes] objectForKey:@"href"];
        NSLog(@"%@,%@",title,href);
    }
}

@end
