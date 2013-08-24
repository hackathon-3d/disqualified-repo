//
//  ViewController.h
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/23/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Social/Social.h>
#import "TwitterFeed.h"

@interface ViewController : UIViewController <UIWebViewDelegate>

@property NSString *schoolName;
@property NSDictionary *gameInfo;
@property TwitterFeed *twitterFeed;

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBarTitle;

- (IBAction)btnChangeTeam:(id)sender;
- (IBAction)btnTweet:(id)sender;

@end
