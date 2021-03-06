//
//  ChannelDetailViewController.m
//  VoaEnglish
//
//  Created by Wufei on 14-4-18.
//  Copyright (c) 2014年 Lion. All rights reserved.
//

#import "ChannelDetailViewController.h"
#import "DataManager.h"
#import "ArticleListViewController.h"

@interface ChannelDetailViewController ()

@end

@implementation ChannelDetailViewController
@synthesize channelsArr;

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
    UIBarButtonItem *playingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:nil action:nil];
    [self.navigationItem setRightBarButtonItems:@[playingItem]];
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
    return [channelsArr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = channelsArr[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    [channelsArr exchangeObjectAtIndex:fromIndexPath.row withObjectAtIndex:toIndexPath.row];
    NSString *path = [[DATA voaPath] stringByAppendingPathComponent:[_currentChannel stringByAppendingPathExtension:@"plist"]];
    [channelsArr writeToFile:path atomically:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *detailChannel = channelsArr[indexPath.row];
    NSMutableArray *articleListArr = [DATA getLocalArticleListOfDetailChannel:detailChannel];
    ArticleListViewController *articleListController = [[ArticleListViewController alloc] init];
    articleListController.channel = _currentChannel;
    articleListController.detailChannel = detailChannel;
    articleListController.articleListArr = articleListArr;
    [self.navigationController pushViewController:articleListController animated:YES];
    
}
// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}


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
