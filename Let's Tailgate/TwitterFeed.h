//
//  TwitterFeed.h
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/24/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface TwitterFeed : NSObject
{
    @private
    ACAccount *twitterAccount;
    NSString *lastMessageID;
}

@property NSMutableArray *twitterMessages;

- (NSString *) getTwitterMessagesAsJSON:(NSString *) filter;

@end
