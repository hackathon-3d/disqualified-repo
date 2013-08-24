//
//  DBManager.m
//  Web View
//
//  Created by Mike Walsh on 8/19/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import "DBManager.h"

static DBManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation DBManager

+(DBManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance copyDatabaseIfNeeded];
    }
    return sharedInstance;
}

- (void) copyDatabaseIfNeeded {
    
    //Using NSFileManager we can perform many file system operations.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSString *dbPath = [self getDBPath];
    BOOL success = [fileManager fileExistsAtPath:dbPath];
    
    if(!success) {
        
        NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"master.db"];
        success = [fileManager copyItemAtPath:defaultDBPath toPath:dbPath error:&error];
        
        if (!success)
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}

- (NSString *) getDBPath
{
    //Search for standard documents using NSSearchPathForDirectoriesInDomains
    //First Param = Searching the documents directory
    //Second Param = Searching the Users directory and not the System
    //Expand any tildes and identify home directories.
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
    NSString *documentsDir = [paths objectAtIndex:0];
    //NSLog(@"dbpath : %@",documentsDir);
    return [documentsDir stringByAppendingPathComponent:@"master.db"];
}


-(NSArray*) getSchoolList{
    NSString *dbPath = [self getDBPath];
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *querySQL = @"select name from school order by name";
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
            }
            return resultArray;
            sqlite3_reset(statement);
        }
    }
    return nil;
}

-(NSArray*) getConferenceList{
    NSString *dbPath = [self getDBPath];
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *querySQL = @"select distinct conference from school order by conference";
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *conference = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:conference];
            }
            return resultArray;
            sqlite3_reset(statement);
        }
    }
    return nil;
}

-(NSArray*)getSchoolByConference:(NSString *) conference {
    NSString *dbPath = [self getDBPath];
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"select name from school where conference='%@' order by name",conference];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                        (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
            }
            return resultArray;
            sqlite3_reset(statement);
        }
    }
    return nil;
}

-(NSMutableDictionary*)getSchoolByName:(NSString *)name {
  NSString *dbPath = [self getDBPath];
  if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
  {
    NSString *querySQL = [NSString stringWithFormat:@"select mascot,city,state,conference,color1,color2,aprank,tweet,colorfont from school where name='%@'",name];
    const char *query_stmt = [querySQL UTF8String];
    if (sqlite3_prepare_v2(database,
                           query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary *data = [NSDictionary dictionaryWithObjectsAndKeys:name, @"name", nil];
            NSString *mascot = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 0)];
            [data setObject:mascot forKey:@"mascot"];
            NSString *city = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 1)];
            [data setObject:city forKey:@"city"];
            NSString *state = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 2)];
            [data setObject:state forKey:@"state"];
            NSString *conference = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 3)];
            [data setObject:conference forKey:@"conference"];
            NSString *color1 = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 4)];
            [data setObject:color1 forKey:@"color1"];
            NSString *color2 = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 5)];
            [data setObject:color2 forKey:@"color2"];
            NSString *aprank = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 6)];
            [data setObject:aprank forKey:@"aprank"];
            NSString *tweet = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 7)];
            [data setObject:tweet forKey:@"tweet"];
            NSString *colorfont = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 8)];
            [data setObject:colorfont forKey:@"colorfont"];
            return data;
        }
        sqlite3_reset(statement);
    }
  }
  return nil;
}



@end
