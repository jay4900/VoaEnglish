//
//  ArticleListViewController.h
//  VoaEnglish
//
//  Created by Wufei on 14-4-18.
//  Copyright (c) 2014年 Lion. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArticleListViewController : UITableViewController
@property NSString *channel;
@property NSString *detailChannel;
@property (strong) NSMutableArray *articleListArr;
@end
