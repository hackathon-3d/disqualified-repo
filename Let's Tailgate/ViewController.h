//
//  ViewController.h
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/23/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <Social/Social.h>
#import "TwitterFeedTableViewViewController.h"
#import "DBManager.h"

@interface ViewController : UIViewController

@property NSString *schoolName;
@property NSDictionary *schoolInfo;
@property NSDictionary *gameInfo;

@property TwitterFeedTableViewViewController *twitterFeedController;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UINavigationItem *navBarTitle;
@property (weak, nonatomic) IBOutlet UILabel *recordLabel;
@property (weak, nonatomic) IBOutlet UILabel *nextGameLabel;
@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;
@property (weak, nonatomic) IBOutlet UIImageView *weatherImage;
@property (weak, nonatomic) IBOutlet UIView *weatherView;
@property (weak, nonatomic) IBOutlet UITableView *twitterTableView;

- (IBAction)btnChangeTeam:(id)sender;
- (IBAction)btnTweet:(id)sender;

@end
