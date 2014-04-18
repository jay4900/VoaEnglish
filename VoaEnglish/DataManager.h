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

+ (id)shared;
- (NSMutableArray *)getDetailListOfChannel:(NSString *)channel;
@end
