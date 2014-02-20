//
//  AMiPhoneSplashScreenViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPhoneSplashScreenViewController.h"

@interface AMiPhoneSplashScreenViewController ()

@end

@implementation AMiPhoneSplashScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"triangular"]];
}

- (void)viewDidAppear:(BOOL)animated {
    [self checkStatus];
}

- (void)checkStatus {
    [_activityIndicator startAnimating];
    [self.loginButton setHidden:YES];
    [self.signupButton setHidden:YES];
    
    // If we are signed in already then go to the main view controller
    if ([PFUser currentUser]) {
        [self performSegueWithIdentifier:@"splashToMain" sender:self];
    } else {
        [self.activityIndicator stopAnimating];
        [self.loginButton setHidden:NO];
        [self.signupButton setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapLogin:(id)sender {
    [self performSegueWithIdentifier:@"splashToLogin" sender:self];
}

- (IBAction)didTapSignup:(id)sender {
    [self performSegueWithIdentifier:@"splashToSignup" sender:self]; 
}
@end
