//
//  PlayerViewController.m
//  VoaEnglish
//
//  Created by Wufei on 14-4-18.
//  Copyright (c) 2014年 Lion. All rights reserved.
//

#import "PlayerViewController.h"

@interface PlayerViewController ()

@end

@implementation PlayerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:NO];
    UIButton *btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnPlay setFrame:CGRectMake(0, 0, 40, 40)];
//    [btnPlay setTitle:@"Play" forState:UIControlStateNormal];
    [btnPlay setBackgroundImage:[UIImage imageNamed:@"btnPlay.png"] forState:UIControlStateNormal];
    [self.navigationItem setTitleView:btnPlay];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
