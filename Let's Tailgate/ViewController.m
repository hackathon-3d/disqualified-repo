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
    
    UINavigationItem *title = [[UINavigationItem alloc] initWithTitle:@"Let's Tailgate"];
    [self.navBar pushNavigationItem:title animated:YES];
    
    [self.webView setDelegate:self];
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

#pragma mark House Keeping

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
