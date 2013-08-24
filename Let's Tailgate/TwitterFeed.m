//
//  TwitterFeed.m
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/24/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import "TwitterFeed.h"

@implementation TwitterFeed

// Constants
NSString *apiURL = @"https://api.twitter.com/1.1/search/tweets.json";
NSString const *tweetCount = @"25";

- (TwitterFeed *) init
{
    self.accountStore = [[ACAccountStore alloc] init];
    self.twitterAccount = [[ACAccount alloc] init];
    return [super init];
}

- (BOOL) hasAccessToTwitter
{
    return [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter];
}

- (NSString *) getTwitterMessagesAsJSON:(NSString *) filter
{
    if ([self hasAccessToTwitter])
    {
        ACAccountType *twitterAccountType = [self.accountStore
                                             accountTypeWithAccountTypeIdentifier:
                                             SLServiceTypeTwitter];
        
        [self.accountStore
         requestAccessToAccountsWithType:twitterAccountType
         options:NULL
         completion:^(BOOL granted, NSError *error) {
             if (granted) {
                 //  Step 2:  Create a request
                 NSArray *twitterAccounts =
                 [self.accountStore accountsWithAccountType:twitterAccountType];
                 NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                               @"/1.1/search/tweets.json"];
                 
                 NSDictionary *params = @{@"q" : @"USC",
                                          @"count" : tweetCount,
                                          @"since_id": self.lastMessageID};
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodGET
                                              URL:url
                                       parameters:params];
                 
                 //  Attach an account to the request
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 //  Step 3:  Execute the request
                 [request performRequestWithHandler:^(NSData *responseData,
                                                      NSHTTPURLResponse *urlResponse,
                                                      NSError *error) {
                     if (responseData) {
                         if (urlResponse.statusCode >= 200 && urlResponse.statusCode < 300) {
                             NSError *jsonError;
                             NSDictionary *timelineData =
                             [NSJSONSerialization
                              JSONObjectWithData:responseData
                              options:NSJSONReadingAllowFragments error:&jsonError];
                             
                             if (timelineData) {
                                 NSLog(@"Timeline Response: %@\n", timelineData);
                             }
                             else {
                                 // Our JSON deserialization went awry
                                 NSLog(@"JSON Error: %@", [jsonError localizedDescription]);
                             }
                         }
                         else {
                             // The server did not respond successfully... were we rate-limited?
                             NSLog(@"The response status code is %d", urlResponse.statusCode);
                         }
                     }
                 }];
             }
             else {
                 // Access was not granted, or an error occurred
                 NSLog(@"%@", [error localizedDescription]);
             }
         }];
    }
    
    return @"";
}



/**
- (void) authorizeTwitterAccount:(void(^)(void))blk
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier: SLServiceTypeTwitter];
    
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if (granted)
        {
            NSArray *accounts = [accountStore accountsWithAccountType:accountType];
            self->twitterAccount = [accounts lastObject];
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

- (void) appendTwitterMessages:(NSDictionary *) data
{
    
}

- (void) searchForHashTag
{
    [self authorizeTwitterAccount:^{
        NSURL *url = [NSURL URLWithString: apiURL];
        
        NSDictionary *params = @{@"q" : @"USC",
                                 @"count" : tweetCount,
                                 @"since_id": self->lastMessageID};
        
        NSLog(@"Getting messages since ID: %@", self->lastMessageID);
        
        SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                requestMethod:SLRequestMethodGET
                                                          URL:url
                                                   parameters:params];
        
        [request setAccount:self->twitterAccount];
        
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{ [self requestTwitterData:request]; });
        
    }];
    
}
**/


@end
