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

    // REMOVE IN FINAL!!!
    if (success)
    {
        [[NSFileManager defaultManager] removeItemAtPath:dbPath error:&error];
        success = NO;
    }
    
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
    NSString *querySQL = [NSString stringWithFormat:@"select mascot,city,state,conference,color1,color2,aprank,tweet,colorfont,statecode,cityweather from school where name like '%@%%'",name];
    const char *query_stmt = [querySQL UTF8String];
      
      
    int status = sqlite3_prepare_v2(database,
                                    query_stmt, -1, &statement, NULL);

    if (status  == SQLITE_OK)
    {
        if (sqlite3_step(statement) == SQLITE_ROW)
        {
            NSMutableDictionary *data = [NSMutableDictionary dictionaryWithObjectsAndKeys:name, @"name", nil];
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
            NSString *statecode = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 9)];
            [data setObject:statecode forKey:@"statecode"];
            NSString *cityweather = [[NSString alloc] initWithUTF8String:
                                   (const char *) sqlite3_column_text(statement, 10)];
            [data setObject:cityweather forKey:@"cityweather"];
            return data;
        }
        sqlite3_reset(statement);
    }
    else
    {
        NSAssert1(0,@"Error %s", sqlite3_errmsg(database));
    }
  }
  return nil;
}


-(NSString*)getSchoolValue:
(NSString*) school
                andKeyName:(NSString*) keyname {
    NSString *dbPath = [self getDBPath];
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {

      NSString *querySQL = [NSString stringWithFormat:@"select keyvalue from school_data where school='%@' and keyname='%@'",school,keyname];
      const char *query_stmt = [querySQL UTF8String];
      if (sqlite3_prepare_v2(database,
                           query_stmt, -1, &statement, NULL) == SQLITE_OK)
      {
          if (sqlite3_step(statement) == SQLITE_ROW)
          {
              NSString *keyvalue = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
              return keyvalue;
          }
          else
          {
              querySQL = [NSString stringWithFormat:@"select keyvalue from school_data where school='' and keyname='%@'",keyname];
              query_stmt = [querySQL UTF8String];
              if (sqlite3_prepare_v2(database,
                                     query_stmt, -1, &statement, NULL) == SQLITE_OK)
              {
                  if (sqlite3_step(statement) == SQLITE_ROW)
                  {
                      NSString *defkeyvalue = [[NSString alloc] initWithUTF8String:
                                            (const char *) sqlite3_column_text(statement, 0)];
                      return defkeyvalue;
                  }
              }
          }
      }
    }
    
    return nil;
}

-(BOOL)setSchoolValue:
(NSString*) school
                andKeyName:(NSString*) keyname
               andKeyValue:(NSString*) keyvalue {
    NSString *dbPath = [self getDBPath];
    if (sqlite3_open([dbPath UTF8String], &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:@"insert or replace into school_data(school,keyname,keyvalue) values ('%@','%@','%@')",school,keyname,keyvalue];
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (SQLITE_DONE != sqlite3_step(statement))
            {
                return NO;
            }
            sqlite3_reset(statement);
            sqlite3_finalize(statement);
            return YES;
        }
    }
    
    return NO;
}



@end
