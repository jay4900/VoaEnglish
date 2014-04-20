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

@interface ArticleListViewController ()<ASIHTTPRequestDelegate, ASIProgressDelegate>

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
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [_articleListArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    UITableViewCell *cell = [CellForArticle cell];
    
    // Configure the cell...
    NSMutableArray *articleArr = _articleListArr[indexPath.row];
    cell.textLabel.text = articleArr[0];
    cell.textLabel.numberOfLines = 2;
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *articleArr = _articleListArr[indexPath.row];
    NSString *title = articleArr[0];
    NSString *state = articleArr[2];
    if ([@"NoFile" isEqualToString:state]) {
        NSString *surl = [DATA getMp3UrlOfArticle:articleArr];
        NSString *name = [DATA createMD5:title];
        NSString *path = [[DATA voaPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"mp3"]];
        NSLog(@"%@",path);
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        ProgressViewForCell *progressIndicator = [ProgressViewForCell createProgressViewWithParent:cell];
//        progressIndicator.frame= CGRectMake(0, -10, 320, 10);
        progressIndicator.hidden = YES;
        [cell addSubview:progressIndicator];
        ASIHTTPRequest *request;
        request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:surl]];
        [request setDownloadDestinationPath:path];
        [request setDownloadProgressDelegate:progressIndicator];
        [request setShowAccurateProgress:YES];
        [request setDelegate:self];
        [request startAsynchronous];
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }else if ([@"DownLoading" isEqualToString:state]) {
        
    }else if ([@"DownLoaded" isEqualToString:state]) {
        
    }else if ([@"Readed" isEqualToString:state]) {
        
    }
}

- (void)downLoadArticle
{
    
}

- (void)request:(ASIHTTPRequest *)request didReceiveData:(NSData *)data
{
    ProgressViewForCell *progressIndicator1 = (id)request.downloadProgressDelegate;
    UITableViewCell *cell = (id)progressIndicator1.parentView;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.f%%",progressIndicator1.progress*100];
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    ProgressViewForCell *progressIndicator1 = (id)request.downloadProgressDelegate;
    UITableViewCell *cell = (id)progressIndicator1.parentView;
    cell.detailTextLabel.text = @"";
    [progressIndicator1 removeFromSuperview];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

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
