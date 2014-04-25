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
        detailLists =  [channelsDic objectForKey:channel];
        [detailLists writeToFile:path atomically:YES];
    }
    
    return detailLists;
}

- (NSMutableArray *)getLocalArticleListOfDetailChannel:(NSString *)detailChannel
{
    NSString *path = [voaPath stringByAppendingPathComponent:[detailChannel stringByAppendingPathExtension:@"plist"]];
    
    if ( ![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSMutableArray *serverList = [self getServerArticleListOfDetailChannel:detailChannel WithPage:1];
        [serverList writeToFile:path atomically:YES];
        
    }
    NSMutableArray *articleList = [[NSMutableArray alloc] initWithContentsOfFile:path];
    return articleList;
}

- (NSMutableArray *)getServerArticleListOfDetailChannel:(NSString *)detailChannel WithPage:(NSInteger)page
{
    /*
    NSMutableArray *articleList = [[NSMutableArray alloc] init];
    NSDictionary *dic = channelsDic[channel];
    NSString *surl = [NSString stringWithFormat:@"http://m.easyvoa.com/wap.php?action=list&id=%@&totalresult=%d&pageno=%d",dic[detailChannel],20*page,page];
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
    return articleList;
     */
    
    NSMutableArray *articleList = [[NSMutableArray alloc] init];
    NSString *newStr = [detailChannel stringByReplacingOccurrencesOfString:@" " withString:@"_"];
    NSString *surl = [NSString stringWithFormat:@"http://www.51voa.com/%@_%d.html",newStr,page];
//    NSLog(@"%@",surl);
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:surl]];
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
//    NSLog(@"%u",[data length]);
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data encoding:@"utf-8"];
    NSArray *items = [hpple searchWithXPathQuery:@"//*[@id='list']/ul/li"];
    
    for (TFHppleElement *item in items) {
        NSArray *arr = [item children];
        TFHppleElement *item = arr[arr.count-2];
        NSDictionary *dic = (id)[item attributes];
        NSString *title = [[[item firstChild] content] stringByAppendingString:[[arr lastObject] content]];
        NSString *href = [dic objectForKey:@"href"];
        NSString *state = @"NoFile";
        NSArray *articleArr = @[title, href, state];
        [articleList addObject:articleArr];
    }
    return articleList;
}

- (BOOL)article:(NSString *)title exsitInLocalList:(NSArray *)arr
{
    for (NSArray *item in arr) {
        NSString *localTitle = item[0];
        if ([title isEqualToString:localTitle]) {
            return YES;
        }
    }
    return NO;
}

- (NSString *)getMp3UrlOfArticle:(NSMutableArray *)articleArr
{
//    //easyvoa
//    NSString *title = articleArr[0];
//    NSString *href = articleArr[1];
//    NSString *surl = [NSString stringWithFormat:@"http://m.easyvoa.com/%@",href];
//    NSURL *url = [NSURL URLWithString:surl];
//    NSURLRequest *request=[NSURLRequest requestWithURL:url];
//    NSURLResponse *respone = nil;
//    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&respone error:nil];
//    
//    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data encoding:@"utf-8"];
//    NSArray *textItems = [hpple searchWithXPathQuery:@"//*[@id='ShowEN']/p/text()"];
//    NSString *text = @"";
//    for (TFHppleElement *item in textItems) {
//        text = [text stringByAppendingString:[[item content] stringByAppendingString:@"\n"]];
//    }
//    NSString *name = [self createMD5:title];
//    NSString *path = [voaPath stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"txt"]];
//    [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
//    
//    NSArray *hrefItems = [hpple searchWithXPathQuery:@"/html/body/div[5]/ul/li/div/a/attribute::href"];
//    NSString *hrefStr = [[[hrefItems firstObject] firstChild] content];
//    return hrefStr;
    
    // 51Voa
    NSString *title = articleArr[0];
    NSString *href = articleArr[1];
    NSString *surl = [NSString stringWithFormat:@"http://www.51voa.com%@",href];
    NSURL *url=[NSURL URLWithString:surl];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLResponse *respone = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&respone error:nil];
    
//    NSLog(@"%u",[data length]);
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data encoding:@"utf-8"];
    NSArray *items = [hpple searchWithXPathQuery:@"//*[@id='content']"];
    NSString *text = @"";
    NSArray *childrenArr = [[items firstObject] children];
    for (TFHppleElement *item in childrenArr) {
        if ([item hasChildren]) {
            for (TFHppleElement *child in [item children]) {
                if ([[child attributes] objectForKey:@"class"]) {
                    continue;
                }
                
                if ([child hasChildren]) {
                    for (TFHppleElement *child2 in [child children]) {
                        NSString *txt = [child2 content];
                        if (txt) {
                            if ([[child attributes] objectForKey:@"href"]) {
                                text = [text stringByReplacingCharactersInRange:NSMakeRange(text.length-2, 2) withString:@" "];
                            }else{
                                txt = [txt stringByAppendingString:@"\n"];
                            }
                            text = [text stringByAppendingString:txt];
                        }
                    }
                }else {
                    NSString *txt = [child content];
                    
                    if (txt) {
                        if ([[item attributes] objectForKey:@"href"]) {
                            text = [text stringByReplacingCharactersInRange:NSMakeRange(text.length-2, 2) withString:@" "];
                        }else if ([@"sup" isEqualToString:item.tagName]) {
                            text = [text stringByReplacingCharactersInRange:NSMakeRange(text.length-1, 1) withString:@""];
                        }else if ([@"em" isEqualToString:item.tagName]) {
                            if ([txt rangeOfString:@" "].length == 0) {
                                text = [text stringByReplacingCharactersInRange:NSMakeRange(text.length-2, 2) withString:@" "];
                            }else{
                                txt = [txt stringByAppendingString:@"\n"];
                            }
                        }
                        else{
                            txt = [txt stringByAppendingString:@"\n"];
                        }
                        text = [text stringByAppendingString:txt];
                    }
                }
            }
        }else{
            NSString *txt = [item content];
            if (txt) {
                if ([txt hasSuffix:@"\r\n"]) {
                    continue;
                }else{
                    txt = [txt stringByAppendingString:@"\n"];
                    text = [text stringByAppendingString:txt];
                }
            }
        }
    }
    NSRange range = [text rangeOfString:@"51voa.com"];
    if (range.length) {
        text = [text stringByReplacingCharactersInRange:range withString:@"learningenglish.voanews.com"];
    }
//    NSLog(@"\n%@",text);
    NSString *name = [self createMD5:title];
    NSString *path = [voaPath stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"txt"]];
    [text writeToFile:path atomically:YES encoding:NSUTF8StringEncoding error:nil];
    
    items = [hpple searchWithXPathQuery:@"//*[@id='mp3']/attribute::href"];
    NSString *hrefStr = nil;
    if (items.count > 0) {
        hrefStr = [[items[0] firstChild] content];
//        NSLog(@"%@",hrefStr);
    }
    return nil;
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
    /*
    NSURL *url=[NSURL URLWithString:@"http://m.easyvoa.com/wap.php?action=list&id=2&pageno=1"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    NSURLResponse *respone = nil;
    NSData *data=[NSURLConnection sendSynchronousRequest:request returningResponse:&respone error:nil];
    NSLog(@"%u",[data length]);
    TFHpple *hpple = [[TFHpple alloc] initWithHTMLData:data encoding:@"utf-8"];
    NSArray *items = [hpple searchWithXPathQuery:@"/html/body/div[3]/ul/li/a"];
    
    for (TFHppleElement *item in items) {
        NSString *title = [[item firstChild] content];
        NSString *href = [[item attributes] objectForKey:@"href"];
        NSLog(@"%@,%@",title,href);
    }
     */
}

@end
