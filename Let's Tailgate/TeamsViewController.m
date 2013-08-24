//
//  TeamsViewController.m
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/23/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import "TeamsViewController.h"
#import "DBManager.h"

@implementation TeamsViewController


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Settings
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Initialize Data
    
    self.schools = [[NSMutableDictionary alloc] init];
    self.conferences = [[NSMutableArray alloc] init];
    
    [self loadSchools];
    [self loadConferences];
    
    [self.tableView reloadData];
    
}

- (void) loadSchools
{
    NSArray *conferenceList = [[DBManager getSharedInstance]getConferenceList];
    
    for (NSString *confName in conferenceList)
    {
        if (confName != NULL)
        {
            [self.schools setObject:[[DBManager getSharedInstance]getSchoolByConference:confName] forKey:confName];
        }
    }
    
}

- (void) loadConferences
{
    NSArray *qdata = [[DBManager getSharedInstance]getConferenceList];
    
    for (NSString *name in qdata) {
        [self.conferences addObject:name];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.conferences count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.conferences objectAtIndex:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.schools objectForKey:[self.conferences objectAtIndex: section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SchoolCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *school = [[self.schools objectForKey: [self.conferences objectAtIndex:indexPath.section]] objectAtIndex: indexPath.row];
        
    cell.textLabel.text = [NSString stringWithFormat:@"%@", school];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *cellText = cell.textLabel.text;
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    
    [userPreferences setObject:cellText forKey:@"userSchool"];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
