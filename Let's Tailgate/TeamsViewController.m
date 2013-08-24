//
//  TeamsViewController.m
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/23/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import "TeamsViewController.h"

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
    
    self.schools = [[NSMutableArray alloc] init];
    
    [self loadSchools];
    
}

- (void) loadSchools
{

    [self.schools addObject:@"Alabama"];
    [self.schools addObject:@"Clemson University"];
    [self.schools addObject:@"Georgia"];
    [self.schools addObject:@"University of South Carolina"];
    
    [self.tableView reloadData];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.schools count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"SchoolCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *school = [self.schools objectAtIndex: indexPath.row];
    
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
