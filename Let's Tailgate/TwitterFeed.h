//
//  TwitterFeed.h
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/24/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface TwitterFeed : NSObject

@property NSMutableArray *twitterMessages;
@property ACAccountStore *accountStore;
@property ACAccount *twitterAccount;
@property NSString *lastMessageID;

- (NSString *) getTwitterMessagesAsJSON:(NSString *) filter;

@end
