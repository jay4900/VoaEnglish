//
//  ArticleListViewController.m
//  VoaEnglish
//
//  Created by Wufei on 14-4-18.
//  Copyright (c) 2014年 Lion. All rights reserved.
//

#import "ArticleListViewController.h"
#import "DataManager.h"
#import "CellForArticle.h"
#import "ProgressViewForCell.h"
#import "ASIHTTPRequest.h"
#import "PlayerViewController.h"
#import "ChannelsViewController.h"

@interface ArticleListViewController ()<ASIHTTPRequestDelegate, ASIProgressDelegate, UITabBarControllerDelegate>
{
    NSInteger downloadingCount;
}

@end

@implementation ArticleListViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    [self.tableView registerClass:[CellForArticle class] forCellReuseIdentifier:@"Cell"];
    downloadingCount = 0;
    UIBarButtonItem *playingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:nil action:nil];
    [self.navigationItem setRightBarButtonItems:@[playingItem]];
    self.title = _detailChannel;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.tabBarController.delegate = self;
}

- (void)refreshArticleListFromTop
{
    NSMutableArray *serverArticleList = [DATA getServerArticleListOfDetailChannel:_detailChannel WithPage:1];
    for (NSArray *item in serverArticleList) {
        NSString *title = item[0];
        if (![DATA article:title exsitInLocalList:_articleListArr]) {
            NSLog(@"get One");
            [_articleListArr insertObject:item atIndex:0];
        }
    }
    [self saveArticleList];
    [self.tableView reloadData];
}

- (void)refreshArticleListFromBottom
{
    NSInteger page = _articleListArr.count/50+1;
    NSLog(@"page:%d",page);
    NSMutableArray *serverArticleList = [DATA getServerArticleListOfDetailChannel:_detailChannel WithPage:page];
    for (NSArray *item in serverArticleList) {
        NSString *title = item[0];
        if (![DATA article:title exsitInLocalList:_articleListArr]) {
            [_articleListArr addObject:item];
        }
    }
    [self saveArticleList];
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_articleListArr count]+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [@"Cell" stringByAppendingFormat:@"%d",indexPath.row];
    CellForArticle *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [CellForArticle cellWithIdentifier:CellIdentifier];
    }
    // Configure the cell...
    if (indexPath.row < [_articleListArr count]) {
        NSMutableArray *articleArr = _articleListArr[indexPath.row];
        NSString *state = articleArr[2];
        cell.textLabel.text = articleArr[0];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.row = indexPath.row;
        if ([@"DownLoaded" isEqualToString:state] || [@"Readed" isEqualToString:state]) {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if ([@"Readed" isEqualToString:state]) {
                [cell.textLabel setTextColor:[UIColor grayColor]];
            }
        }
    }else{
        cell.textLabel.text = @"点击加载更多……";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellForArticle *cell = (id)[tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row < [_articleListArr count]) {
        NSMutableArray *articleArr = _articleListArr[indexPath.row];
        NSString *title = articleArr[0];
        NSString *state = articleArr[2];
        if ([@"NoFile" isEqualToString:state]) {
            NSString *surl = [DATA getMp3UrlOfArticle:articleArr];
            NSString *name = [DATA createMD5:title];
            NSString *path = [[DATA voaPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"mp3"]];
            
            if (surl == nil) {
                [articleArr replaceObjectAtIndex:2 withObject:@"DownLoaded"];
                [self saveArticleList];
                [self.tableView reloadData];
            }else{
                ProgressViewForCell *progressIndicator = [ProgressViewForCell createProgressViewWithParent:cell];
                progressIndicator.frame= CGRectMake(0, 0, cell.frame.size.width, 0);
                progressIndicator.autoresizingMask = UIViewAutoresizingFlexibleWidth;
                [cell addSubview:progressIndicator];
                ASIHTTPRequest *request;
                request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:surl]];
                [request setDownloadDestinationPath:path];
                [request setDownloadProgressDelegate:progressIndicator];
                [request setShowAccurateProgress:YES];
                [request setAllowResumeForFileDownloads:YES];
                [request setDelegate:self];
                [request startAsynchronous];
                [articleArr replaceObjectAtIndex:2 withObject:@"DownLoading"];
                downloadingCount ++;
                [self.navigationItem setHidesBackButton:YES animated:YES];
            }
            
            
        }else if ([@"DownLoading" isEqualToString:state]) {
            NSLog(@"DownLoading");
            
        }else if ([@"DownLoaded" isEqualToString:state]) {
            NSLog(@"DownLoaded");
            NSMutableArray *articleArr = _articleListArr[indexPath.row];
            NSString *title = articleArr[0];
            PlayerViewController *playerView = [PlayerViewController shared];
            playerView.fileName = title;
            [playerView play];
//            NSLog(@"title:%@",title);
            
//            CATransition* animation = [CATransition animation];
//            [animation setDuration:0.4f];
//            [animation setType:@"cube"];
//            [animation setSubtype:kCATransitionFromRight];
//            [self.tabBarController.view.layer addAnimation:animation forKey:nil];
            
            
            [self.tabBarController setSelectedIndex:2];
            [articleArr replaceObjectAtIndex:2 withObject:@"Readed"];
            [cell.textLabel setTextColor:[UIColor grayColor]];
            [self saveArticleList];
            
        }else if ([@"Readed" isEqualToString:state]) {
//            CATransition* animation = [CATransition animation];
//            [animation setDuration:0.4f];
//            [animation setType:@"cube"];
//            [animation setSubtype:kCATransitionFromRight];
//            [self.tabBarController.view.layer addAnimation:animation forKey:nil];
            NSMutableArray *articleArr = _articleListArr[indexPath.row];
            NSString *title = articleArr[0];
            PlayerViewController *playerView = [PlayerViewController shared];
            playerView.fileName = title;
            [playerView play];
            [self.tabBarController setSelectedIndex:2];
        }
    }else{
        [self refreshArticleListFromBottom];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)downLoadArticle
{
    
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    downloadingCount --;
    if (downloadingCount == 0) {
        [self.navigationItem setHidesBackButton:NO animated:YES];
    }
    ProgressViewForCell *progressIndicator1 = (id)request.downloadProgressDelegate;
    CellForArticle *cell = (id)progressIndicator1.parentView;
    cell.detailTextLabel.text = @"";
    [progressIndicator1 removeFromSuperview];
    NSMutableArray *articleArr = _articleListArr[cell.row];
    [articleArr replaceObjectAtIndex:2 withObject:@"DownLoaded"];
    [self saveArticleList];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

- (void)saveArticleList
{
    NSString *path = [[DATA voaPath] stringByAppendingPathComponent:[_detailChannel stringByAppendingPathExtension:@"plist"]];
    [_articleListArr writeToFile:path atomically:YES];
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    if (viewController.tabBarItem.tag == 1) {
        return NO;
    }else{
        return YES;
    }
//    if ([viewController isKindOfClass:[ChannelsViewController class]]) {
//        return NO;
//    }else{
//        return YES;
//    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.tabBarController.delegate  = nil;
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
//{
//    CGFloat delta = scrollView.contentSize.height - scrollView.frame.size.height;
//    if (scrollView.contentOffset.y > delta) {
////        NSLog(@"load more page");
//        [self refreshArticleListFromBottom];
//    }
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
