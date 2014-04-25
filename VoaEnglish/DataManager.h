//
//  DataManager.h
//  VoaEnglish
//
//  Created by Wufei on 14-4-18.
//  Copyright (c) 2014年 Lion. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DATA [DataManager shared]
#define DOCUMENTS [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]
#define WIDTH [[UIScreen mainScreen] bounds].size.width

@interface DataManager : NSObject
@property NSDictionary *channelsDic;
@property NSString *voaPath;

+ (id)shared;
- (NSMutableArray *)getDetailListOfChannel:(NSString *)channel;
- (NSMutableArray *)getLocalArticleListOfDetailChannel:(NSString *)detailChannel;
- (NSMutableArray *)getServerArticleListOfDetailChannel:(NSString *)detailChannel WithPage:(NSInteger)page;
- (NSString *)getMp3UrlOfArticle:(NSMutableArray *)articleArr;
- (BOOL)article:(NSString *)title exsitInLocalList:(NSArray *)arr;
- (NSString *)createMD5:(NSString *)aString;
- (void)parseVoaList;
@end
