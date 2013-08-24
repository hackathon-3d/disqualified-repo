//
//  TeamsViewController.h
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/23/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TeamsViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *conferences;
@property NSMutableDictionary *schools;


@end
