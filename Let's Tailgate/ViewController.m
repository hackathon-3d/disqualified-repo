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
    self.schoolInfo = [[DBManager getSharedInstance]getSchoolByName:schoolName];

    
}


- (void) setGameInformation
{
    self.gameInfo = @{@"month": [self.schoolInfo objectForKey:@"gamemonthnum"], @"day": [self.schoolInfo objectForKey:@"gamedaynum"], @"hour": [self.schoolInfo objectForKey:@"gamehournum"]};
    
}

#pragma mark StoryBoard Events

- (void) viewDidAppear:(BOOL)animated
{

    [self verifySchoolIsSelected];
    // Set Title Bar Info
    [self setNavigationBarStylesAndTitle];
    [self setupRecordLabel];
    [self setupGameLabel];
    [self setupWeatherView];
    [self setupTwitterFeed];
    
//    // Populate Data
    [self buildSchoolView];
    
}

- (void) setupTwitterFeed
{
    if([[self.schoolInfo objectForKey:@"tweet"] length] > 0)
    {
        self.twitterFeedController = [[TwitterFeedTableViewViewController alloc] init];
        
        [self.twitterFeedController setTableView:self.twitterTableView];
        [self.twitterTableView setDelegate:self.twitterFeedController];
        [self.twitterTableView setDataSource:self.twitterFeedController];
        
        [self.twitterFeedController searchForHashTag:[NSString stringWithFormat:@"#%@", [self.schoolInfo objectForKey:@"tweet"]]];
    }

}

- (void) setupWeatherView
{
    UIColor *baseColor = [self colorWithHexString:[self.schoolInfo objectForKey:@"color1"]];
    UIColor *accentColor = [self colorWithHexStringLoweredOpacity:[self.schoolInfo objectForKey:@"color2"]];
    
    self.weatherView.backgroundColor = accentColor;
    
    CALayer *layer = [self.weatherView layer];
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = baseColor.CGColor;
    bottomBorder.borderWidth = 4;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-1, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:[UIColor blackColor].CGColor];
    
    CALayer *rightBorder = [CALayer layer];
    rightBorder.borderColor = baseColor.CGColor;
    rightBorder.borderWidth = 4;
    rightBorder.frame = CGRectMake(layer.frame.size.width-1, -1, 1, layer.frame.size.height + 1);
    [rightBorder setBorderColor:[UIColor blackColor].CGColor];
    
    [layer addSublayer:bottomBorder];
    [layer addSublayer:rightBorder];
    
    self.weatherLabel.text = @"Sunny";
    
}

- (void) setupRecordLabel
{
    UIColor *baseColor = [self colorWithHexString:[self.schoolInfo objectForKey:@"color1"]];
    //UIColor *accentColor = [self colorWithHexStringLoweredOpacity:[self.schoolInfo objectForKey:@"color2"]];
    
    CALayer *layer = [self.recordLabel layer];
    CALayer *boldLayer = [self.recordBoldLabel layer];
    
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.borderColor = baseColor.CGColor;
    bottomBorder.borderWidth = 4;
    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-1, layer.frame.size.width, 1);
    [bottomBorder setBorderColor:[UIColor blackColor].CGColor];
    
    CALayer *bottomBorder2 = [CALayer layer];
    bottomBorder2.borderColor = baseColor.CGColor;
    bottomBorder2.borderWidth = 4;
    bottomBorder2.frame = CGRectMake(-1, layer.frame.size.height-1, layer.frame.size.width, 1);
    [bottomBorder2 setBorderColor:[UIColor blackColor].CGColor];
    
    [layer addSublayer:bottomBorder];
    [boldLayer addSublayer:bottomBorder2];
    
    [self.recordBoldLabel setFont:[UIFont fontWithName:@"Exo-Bold" size:14]];
    [self.recordLabel setFont:[UIFont fontWithName:@"Exo-Regular" size:14]];
    
    NSString *labelString = nil;
    
    if ([[self.schoolInfo objectForKey:@"aprank"] length] == 0)
    {
        labelString = [NSString stringWithFormat:@"0-0 / 0-0"];
    }
    else
    {
        labelString = [NSString stringWithFormat:@"0-0 / 0-0 (%@)", [self.schoolInfo objectForKey:@"aprank"]];
    }
    
    self.recordLabel.text = labelString;
}

- (void) setupGameLabel
{
    UIColor *baseColor = [self colorWithHexString:[self.schoolInfo objectForKey:@"color1"]];
    //UIColor *accentColor = [self colorWithHexStringLoweredOpacity:[self.schoolInfo objectForKey:@"color2"]];
    
//    CALayer *layer = [self.nextGameLabel layer];
//    CALayer *bottomBorder = [CALayer layer];
//    bottomBorder.borderColor = baseColor.CGColor;
//    bottomBorder.borderWidth = 4;
//    bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-1, layer.frame.size.width, 1);
//    [bottomBorder setBorderColor:[UIColor blackColor].CGColor];
//    [layer addSublayer:bottomBorder];
    
    self.nextGameLabel.text = [NSString stringWithFormat:@"Next Game\n%@\n%@",
                               [self.schoolInfo objectForKey:@"gameday"],
                               [self.schoolInfo objectForKey:@"matchup"]];
    [self.nextGameLabel setFont:[UIFont fontWithName:@"Exo-Regular" size:14]];
}

- (void) setNavigationBarStylesAndTitle
{
    [self.navBarTitle setTitle: self.schoolName];
    [self.navBar setTintColor: [self colorWithHexString:[self.schoolInfo objectForKey:@"color1"]]];
}

#pragma mark Data Wrappers

- (void) getWeatherData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *wUrl = [NSString stringWithFormat:@"http://api.wunderground.com/api/fca034c5c94b1ad7/hourly10day/q/%@/%@.json",
                                                    [self.schoolInfo objectForKey:@"statecode"],
                                                    [self.schoolInfo objectForKey:@"cityweather"]];
        NSURL *dataURL = [NSURL URLWithString:wUrl];
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
            //NSString *icon_url = [hourlyData objectForKey: @"icon_url"];
            NSString *icon = [hourlyData objectForKey: @"icon"];
            
            //NSDictionary *weatherObj = @{@"temp": temp, @"condition_label": condition_label, @"icon_url": icon_url};
            
            self.weatherLabel.text = condition_label;
            [self.weatherLabel setFont:[UIFont fontWithName:@"Exo-Regular" size:16]];
            self.weatherTempLabel.text = temp;
            [self.weatherTempLabel setFont:[UIFont fontWithName:@"Exo-Bold" size:28]];
            
            NSString *imagePath = [[NSBundle mainBundle] pathForResource:icon ofType:@"png" inDirectory:@"weatherIcons"];
            self.weatherImage.image = [UIImage imageWithContentsOfFile:imagePath];
            
        }
    }
    
}

- (void) buildSchoolView
{
    [self setGameInformation];
    [self getWeatherData];
    [self.navBarTitle setTitle: self.schoolName];
    
}

#pragma mark UI Actions


- (IBAction)btnChangeTeam:(id)sender {
    // This is a segue to a modal
}


- (IBAction)btnTweet:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        
        SLComposeViewController *mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        NSString *message = [[NSString alloc] initWithFormat: @"Anyone going to see the game this week? #%@", [self.schoolInfo objectForKey:@"tweet"]];
        [mySLComposerSheet setInitialText:message];
        
        //[mySLComposerSheet addImage:[UIImage imageNamed:@"myImage.png"]];
        //[mySLComposerSheet addURL:[NSURL URLWithString:@"http://stackoverflow.com/questions/12503287/tutorial-for-slcomposeviewcontroller-sharing"]];
        
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            // Not Necessary yet
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    NSLog(@"Canceled Tweet");
                    break;
                case SLComposeViewControllerResultDone:
                    NSLog(@"Tweeted Successfully");
                    break;
                    
                default:
                    break;
            }
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    }
}

- (IBAction)btnBuyTickets:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[self.schoolInfo objectForKey:@"tickets"]]];
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

-(UIColor*)colorWithHexStringLoweredOpacity:(NSString*)hex
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
                           alpha:0.4f];
}

#pragma mark House Keeping

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
