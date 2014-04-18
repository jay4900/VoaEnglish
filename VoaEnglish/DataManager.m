//
//  DataManager.m
//  VoaEnglish
//
//  Created by Wufei on 14-4-18.
//  Copyright (c) 2014年 Lion. All rights reserved.
//

#import "DataManager.h"

static DataManager *obj;
@implementation DataManager
@synthesize channelsDic;
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
    NSArray *keys1 = [channelsDic allKeys];
    BOOL isDir = YES;
    for (NSString *key1 in keys1) {
        NSDictionary *dic = channelsDic[key1];
        NSString *path = [DOCUMENTS stringByAppendingPathComponent:key1];
        if ( ![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
            [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
            NSURL *url = [NSURL fileURLWithPath:path isDirectory:YES];
            [url setResourceValue: [NSNumber numberWithBool: YES]
                           forKey: NSURLIsExcludedFromBackupKey error:nil];
        }
        
        NSArray *keys2 = [dic allKeys];
        for (NSString *key2 in keys2) {
            path = [[DOCUMENTS stringByAppendingPathComponent:key1] stringByAppendingPathComponent:key2];
            if ( ![[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir]) {
                [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:NO attributes:nil error:nil];
            }
        }
        
    }
}

- (NSMutableArray *)getDetailListOfChannel:(NSString *)channel
{
    NSMutableArray *detailLists = nil;
    NSString *path = [[DOCUMENTS stringByAppendingPathComponent:channel] stringByAppendingPathComponent:@"list.plist"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        detailLists = [[NSMutableArray alloc] initWithContentsOfFile:path];
    }else{
        NSDictionary *dic = [channelsDic objectForKey:channel];
        detailLists = [[NSMutableArray alloc] initWithArray:[dic allKeys]];
        [detailLists writeToFile:path atomically:YES];
    }
    
    return detailLists;
}

@end
