//
//  TwitterFeedTableViewViewController.m
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/24/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import "TwitterFeedTableViewViewController.h"

@interface TwitterFeedTableViewViewController ()

@end

@implementation TwitterFeedTableViewViewController

NSString *apiURL = @"https://api.twitter.com/1.1/search/tweets.json";
NSString const *tweetCount = @"25";


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.accountStore = [[ACAccountStore alloc] init];
        self.twitterAccount = [[ACAccount alloc] init];
        self.lastMessageID = @"1";
    }
    return self;
}

#pragma mark Twitter Shit


- (BOOL) hasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (void) authorizeTwitterAccount:(void(^)(void))blk
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier: ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        
        if (granted)
        {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            self.twitterAccount = [accounts lastObject];
            blk();
        }
    }];
    
}

- (void) requestTwitterData:(SLRequest *) request
{
    [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        
        if (responseData && urlResponse.statusCode >= 200 && urlResponse.statusCode < 300)
        {
            
            NSError *jsonError = nil;
            NSDictionary *twData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                   options:NSJSONReadingAllowFragments
                                                                     error:&jsonError];
            if(twData)
            {
                dispatch_async(dispatch_get_main_queue(), ^{ [self appendTwitterMessages:[twData objectForKey:@"statuses"]]; });
            }
        }
    }];
}

- (void) appendTwitterMessages:(NSArray *) data
{
    self.twitterMessages = [[NSMutableArray alloc] initWithArray: data];
    [self.tableView reloadData];
}

- (void) searchForHashTag: (NSString *)hashTag
{
    [self authorizeTwitterAccount:^{
        NSURL *url = [NSURL URLWithString: apiURL];
        
        NSDictionary *params = @{@"q" : hashTag,
                                 @"count" : tweetCount,
                                 @"since_id": self.lastMessageID};
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:url
                                                   parameters:params];
        
        [request setAccount:self.twitterAccount];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ [self requestTwitterData:request]; });
        
    }];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.twitterMessages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (44.0 + 2 * 19.0);
}





- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *cellID = @"TweetCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellID];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellID];
    }
    
    NSDictionary *tweet = [self.twitterMessages objectAtIndex: indexPath.row];
    
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@",
                           [tweet objectForKey:@"text"]];
    cell.textLabel.numberOfLines = 3;
    cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
    [[cell textLabel] setFont:[UIFont systemFontOfSize:12.0]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"by %@ - %@",
                                 [[tweet objectForKey: @"user"] objectForKey: @"name"],
                                 [tweet objectForKey: @"id"]];
    
    return cell;
    
}

@end;