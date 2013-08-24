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
    
    self.twitterFeed = [[TwitterFeed alloc] init];
    
    // Initialize Controls
    [self.webView setDelegate:self];
    [[self.webView scrollView] setBounces: NO];
    self.webView.scrollView.showsVerticalScrollIndicator = NO;
    
}

- (void) verifySchoolIsSelected
{
    NSUserDefaults *userPreferences = [NSUserDefaults standardUserDefaults];
    NSString *schoolName = [userPreferences objectForKey:@"userSchool"];
    
    if ([schoolName length] == 0)
    {
        [self performSegueWithIdentifier:@"segueChangeTeam" sender:self];
    }
    
    self.schoolName = schoolName;
    //self.schoolInfo = [[[DBManager getSharedInstance]getSchoolByName:schoolName] objectForKey:schoolName];
    
    //NSLog(@"School Info: %@", [[DBManager getSharedInstance] getSchoolByName:schoolName]);

}

- (void) loadWebViewInterface
{
    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html" inDirectory:@"www"];
    NSURL *url = [[NSURL alloc] initFileURLWithPath:htmlFile];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    [self.webView loadRequest:request];
}

- (void) getTwitterFeed
{
    [self.twitterFeed getTwitterMessagesAsJSON:@"USC"];
}

- (void) setGameInformation
{
    self.gameInfo = @{@"month": @"8", @"day": @"26", @"hour": @"16"};
    
}

- (void) setTheme
{
    NSString *javascriptCall = [NSString stringWithFormat:@"setTeamColors(\"#%@\", \"#%@\")", @"ffffff", @"green"];
    [self.webView stringByEvaluatingJavaScriptFromString:javascriptCall];
    NSLog(@"Attempting to change colors!");
    //[self.navBar setTintColor: [self colorWithHexString:[self.schoolInfo objectForKey:@"color1"]]];
}

#pragma mark StoryBoard Events

- (void) viewDidAppear:(BOOL)animated
{
    [self verifySchoolIsSelected];
    
    // Set Title Bar Info
    [self setNavigationBarStylesAndTitle];
    [self loadWebViewInterface];
    
    // Populate Data
    [self buildSchoolView];
    
}

- (void) setNavigationBarStylesAndTitle
{
    [self.navBarTitle setTitle: self.schoolName];
    
    
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
            
            NSDictionary *weatherObj = @{@"temp": temp, @"condition_label": condition_label, @"icon_url": icon_url};
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:weatherObj
                                                               options:NSJSONWritingPrettyPrinted
                                                                 error:&error];
            NSString *weatherJSON = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            NSString *javascriptCall = [NSString stringWithFormat:@"updateWeather(%@)", weatherJSON];
            
            [self.webView stringByEvaluatingJavaScriptFromString:javascriptCall];
            NSLog(@"Made Call");
            
        }
    }
    
}

- (void) buildSchoolView
{
    [self setTheme];
    [self setGameInformation];
    [self getWeatherData];
    [self getTwitterFeed];
    [self.navBarTitle setTitle: self.schoolName];
    
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
        
        NSString *message = [[NSString alloc] initWithFormat: @"Anyone going to see the game this week? #%@", self.schoolName];
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

#pragma mark Utility Methods


-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

#pragma mark House Keeping

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
