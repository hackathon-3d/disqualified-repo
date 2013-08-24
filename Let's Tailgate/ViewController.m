//
//  ViewController.m
//  Let's Tailgate
//
//  Created by Nick Shepherd on 8/23/13.
//  Copyright (c) 2013 Grey Bull Studios. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
    // Initialize Controls
    [self.webView setDelegate:self];
    
    [self.navBarTitle setTitle: [self getSchoolName]];
    
    // Populate Data
    [self setGameInformation];
    [self getWeatherData];
}

- (void) setSchoolInformation
{
    
}

- (void) setGameInformation
{
    self.gameInfo = @{@"month": @"8", @"day": @"26", @"hour": @"16"};
    
}

#pragma mark StoryBoard Events

- (void) viewDidAppear:(BOOL)animated
{
    [self buildSchoolView];
}

#pragma mark Data Wrappers

- (void) getWeatherData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *dataURL = [NSURL URLWithString:@"http://api.wunderground.com/api/fca034c5c94b1ad7/hourly10day/q/CA/San_Francisco.json"];
        NSData *data = [NSData dataWithContentsOfURL: dataURL];
        [self performSelectorOnMainThread:@selector(fetchedWeatherData:) withObject:data waitUntilDone:YES];
    });
}

- (void) fetchedWeatherData:(NSData *)responseData
{
    NSError *error;
    NSDictionary *forecastData = [NSJSONSerialization JSONObjectWithData:responseData
                                                                 options:NSJSONReadingAllowFragments
                                                                   error: &error];
    for (NSDictionary *hourlyData in [forecastData objectForKey: @"hourly_forecast"])
    {
        
        NSDictionary *timeInfo = [hourlyData objectForKey:@"FCTTIME"];
        NSString *hour = [timeInfo objectForKey: @"hour"];
        NSString *month = [timeInfo objectForKey: @"mon"];
        NSString *day = [timeInfo objectForKey: @"mday"];
        
        if ([month isEqualToString: [self.gameInfo objectForKey:@"month"]] &&
            [day isEqualToString: [self.gameInfo objectForKey: @"day"]] &&
            [hour isEqualToString: [self.gameInfo objectForKey: @"hour"]])
        {
            NSString *temp = [[hourlyData objectForKey:@"temp"] objectForKey: @"english"];
            NSString *condition_label = [hourlyData objectForKey: @"condition"];
            NSString *icon_url = [hourlyData objectForKey: @"icon_url"];
            
            NSLog(@"Hour: %@", hour);
            NSLog(@"Month: %@", month);
            NSLog(@"Day: %@", day);
            NSLog(@"Temperature: %@", temp);
            NSLog(@"Condition: %@", condition_label);
            NSLog(@"ICON Url: %@", icon_url);
        }
    }
    
}

- (void) buildSchoolView
{
    [self.navBarTitle setTitle: [self getSchoolName]];
}

- (NSString *) getSchoolName
{
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    NSString *schoolName = [userPreferences objectForKey:@"userSchool"];
    NSLog(@"School Name: %@", schoolName);
    
    if (schoolName == nil)
    {
        [self performSegueWithIdentifier:@"segueChangeTeam" sender:self];
    }
    
    return schoolName;
}

#pragma mark UIWebViewDelegate Methods

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSURL *URL = [request URL];
    
    if([[URL scheme] isEqualToString:@"tailgate"]) {
        NSString *urlString = [[request URL] absoluteString];
        NSArray *urlParts = [urlString componentsSeparatedByString:@":"];
        
        if([urlParts count] > 1) {
            NSArray *parameters = [[urlParts objectAtIndex: 1] componentsSeparatedByString:@"&"];
            NSString *methodName = [parameters objectAtIndex: 0];
            NSString *variableName = [parameters objectAtIndex:1];
            
            NSString *message = [NSString stringWithFormat:@"Call to the Backend with methodname=%@ and variablename=%@", methodName, variableName];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Test" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK",nil , nil];
            [alert show];
        }
        
        return NO;
    }
    
    return YES;
}

#pragma mark UI Actions


- (IBAction)btnChangeTeam:(id)sender {
    // This is a segue to a modal
}


- (IBAction)btnTweet:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *message = [[NSString alloc] initWithFormat: @"Anyone going to see the game this week? #%@", [self getSchoolName]];
        [mySLComposerSheet setInitialText:message];
        
        //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
        //[mySLComposerSheet addURL:[NSURL URLWithString:@"http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            // Not Necessary yet
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    break;
                case SLComposeViewControllerResultDone:
                    break;
                    
                default:
                    break;
            }
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}

#pragma mark House Keeping

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
