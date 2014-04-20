//
//  ProgressViewForCell.h
//  VoaEnglish
//
//  Created by Wuffy on 4/19/14.
//  Copyright (c) 2014 Lion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressViewForCell : UIProgressView
@property (strong) UIView *parentView;
+ (id)createProgressViewWithParent:(UIView *)view;
@end
