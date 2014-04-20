//
//  ProgressViewForCell.m
//  VoaEnglish
//
//  Created by Wuffy on 4/19/14.
//  Copyright (c) 2014 Lion. All rights reserved.
//

#import "ProgressViewForCell.h"

@implementation ProgressViewForCell

+ (id)createProgressViewWithParent:(UIView *)view
{
    ProgressViewForCell *progressView = [[ProgressViewForCell alloc] initWithProgressViewStyle:UIProgressViewStyleBar];
    [progressView setParentView:view];
    return progressView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
