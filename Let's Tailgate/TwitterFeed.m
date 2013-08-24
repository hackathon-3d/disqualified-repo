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
    return [super init];
}

- (NSString *) getTwitterMessagesAsJSON:(NSString *) filter
{
    NSString *jsonData = nil;
    
    return jsonData;
}

/**
- (void) authorizeTwitterAccount:(void(^)(void))blk
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
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
