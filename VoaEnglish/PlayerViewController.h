//
//  PlayerViewController.h
//  VoaEnglish
//
//  Created by Wufei on 14-4-18.
//  Copyright (c) 2014年 Lion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayerViewController : UIViewController
+ (PlayerViewController *)shared;
- (void)play;
@property NSString *fileName;

@end
