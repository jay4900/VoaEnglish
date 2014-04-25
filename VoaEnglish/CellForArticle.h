//
//  CellForArticle.h
//  VoaEnglish
//
//  Created by Wuffy on 4/19/14.
//  Copyright (c) 2014 Lion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellForArticle : UITableViewCell
//@property (strong) UIProgressView *progressIndicator;
@property NSInteger row;
+ (id)cellWithIdentifier:(NSString *)cellIdentifier;
@end
