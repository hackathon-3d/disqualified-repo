//
//  DBManager.h
//  Let's Tailgate
//
//  Created by Mike Walsh on 8/24/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>

@interface DBManager : NSObject
{
    NSString *databasePath;
}

+(DBManager*)getSharedInstance;
-(void)copyDatabaseIfNeeded;
-(NSArray*)getSchoolList;

@end