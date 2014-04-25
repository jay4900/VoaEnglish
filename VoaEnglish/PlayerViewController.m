//
//  PlayerViewController.m
//  VoaEnglish
//
//  Created by Wufei on 14-4-18.
//  Copyright (c) 2014年 Lion. All rights reserved.
//

#import "PlayerViewController.h"
#import "DataManager.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "DicViewController.h"

@interface PlayerViewController ()<AVAudioPlayerDelegate, UITextViewDelegate>
{
    AVAudioPlayer *player;
    UITextView *articleTextView;
    UIButton *btnPlay;
    NSString *word;
}

@end

static PlayerViewController *obj;
@implementation PlayerViewController

+ (id)shared
{
    if (obj == nil) {
        obj = [[PlayerViewController alloc] init];
    }
    return obj;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        UIMenuItem *menuItem = [[UIMenuItem alloc]initWithTitle:@"海词" action:@selector(goToDicView)];
        UIMenuController *menu = [UIMenuController sharedMenuController];
        [menu setMenuItems:[NSArray arrayWithObject:menuItem]];
        
        btnPlay = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnPlay setFrame:CGRectMake(0, 0, 40, 40)];
        //    [btnPlay setTitle:@"Play" forState:UIControlStateNormal];
        [btnPlay setBackgroundImage:[UIImage imageNamed:@"btnPause.png"] forState:UIControlStateNormal];
        [btnPlay addTarget:self action:@selector(playAndPause:) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationItem setTitleView:btnPlay];
        
        articleTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
        [articleTextView setFont:[UIFont systemFontOfSize:16]];
        [articleTextView setEditable:NO];
        [articleTextView setDelegate:self];
        articleTextView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:articleTextView];
        
        AVAudioSession *session = [AVAudioSession sharedInstance];
        [session setActive:YES error:nil];
        [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)play
{
    [articleTextView setContentOffset:CGPointZero animated:YES];
    NSString *name = [DATA createMD5:_fileName];
    NSString *path = [[DATA voaPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"txt"]];
    [articleTextView setText:[NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil]];
    path = [[DATA voaPath] stringByAppendingPathComponent:[name stringByAppendingPathExtension:@"mp3"]];
    NSURL *url = [NSURL URLWithString:path];
    player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    if ([player prepareToPlay]) {
        [player play];
        [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    }
    
}

- (void)playAndPause:(UIButton *)sender
{
    if ([player isPlaying]) {
        [player pause];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnPlay.png"] forState:UIControlStateNormal];
    }else{
        [player play];
        [sender setBackgroundImage:[UIImage imageNamed:@"btnPause.png"] forState:UIControlStateNormal];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
//    [self.navigationController setNavigationBarHidden:YES];
    
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    if (event.type == UIEventTypeRemoteControl) {
        switch (event.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self playAndPause:btnPlay];
                break;
                
            case UIEventSubtypeRemoteControlPreviousTrack:
                NSLog(@"上一曲");
                break;
                
            case UIEventSubtypeRemoteControlNextTrack:
                NSLog(@"下一曲");
                break;
                
            default:
                break;
        }
    }
}

- (void)goToDicView
{
    DicViewController *dicView = [[DicViewController alloc] init];
    dicView.word = word;
    [self.navigationController pushViewController:dicView animated:YES];
}

- (void)textViewDidChangeSelection:(UITextView *)textView
{
    NSLog(@"%d,%d",textView.selectedRange.location,textView.selectedRange.length);
//    if (textView.selectedRange.length) {
//        word = [textView.text substringWithRange:textView.selectedRange];
//        NSLog(@"%@",word);
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
