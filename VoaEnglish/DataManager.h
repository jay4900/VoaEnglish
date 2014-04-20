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

@interface DataManager : NSObject
@property NSDictionary *channelsDic;
@property NSString *voaPath;

+ (id)shared;
- (NSMutableArray *)getDetailListOfChannel:(NSString *)channel;
- (NSMutableArray *)getArticleListOfDetailChannel:(NSString *)detailChannel InChannel:(NSString *)channel;
- (NSString *)getMp3UrlOfArticle:(NSMutableArray *)articleArr;
- (NSString *)createMD5:(NSString *)aString;
- (void)parseVoaList;
@end
