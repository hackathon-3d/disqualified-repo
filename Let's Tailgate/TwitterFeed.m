//
//  TwitterFeed.m
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/24/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import "TwitterFeed.h"

@implementation TwitterFeed

NSString *apiURL = @"https://api.twitter.com/1.1/search/tweets.json";
NSString const *tweetCount = @"25";

- (TwitterFeed *) init
{
    self.accountStore = [[ACAccountStore alloc] init];
    self.twitterAccount = [[ACAccount alloc] init];
    self.lastMessageID = @"1";
    return [super init];
}

- (BOOL) hasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (NSString *) getTwitterMessagesAsJSON:(NSString *) filter
{
    NSString *jsonData = nil;
    
    [self searchForHashTag:filter];
    
    return jsonData;
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


@end
