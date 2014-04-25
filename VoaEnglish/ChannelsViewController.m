//
//  ChannelsViewController.m
//  VoaEnglish
//
//  Created by Wufei on 14-4-18.
//  Copyright (c) 2014年 Lion. All rights reserved.
//

#import "ChannelsViewController.h"
#import "DataManager.h"
#import "ChannelDetailViewController.h"
#import "PlayerViewController.h"
#import "FavoritesViewController.h"

@interface ChannelsViewController ()

@end

@implementation ChannelsViewController
{
    NSArray *channels;
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *playingItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(showPlayerView)];
    [self.navigationItem setRightBarButtonItems:@[playingItem]];
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    [self.view addSubview:self.tableView];
    channels = @[@"VOA Special English", @"VOA Learning English", @"VOA Standard English"];
}

- (void)showPlayerView
{
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:[[FavoritesViewController alloc] initWithStyle:UITableViewStylePlain]];
//    [self.navigationController transitionFromViewController:self
//                                           toViewController:nvc
//                                                   duration:0.5
//                                                    options:UIViewAnimationOptionTransitionFlipFromLeft
//                                                 animations:nil
//                                                 completion:nil];
//    [self.navigationController pushViewController:[PlayerViewController shared] animated:YES];
    [self presentViewController:[[PlayerViewController alloc] init] animated:YES completion:nil];
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
    return [channels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.textLabel.text = channels[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *channel = channels[indexPath.row];
    NSMutableArray *detailListArr = [DATA getDetailListOfChannel:channel];
    ChannelDetailViewController *detailViewController = [[ChannelDetailViewController alloc] initWithStyle:UITableViewStylePlain];
    detailViewController.currentChannel = channel;
    detailViewController.channelsArr = detailListArr;
    [self.navigationController pushViewController:detailViewController animated:YES];
}

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
