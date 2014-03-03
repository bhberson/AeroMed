//
//  AMiPhoneBaseViewController.m
//  AeroMed
//
//  Created by Michael Torres on 2/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPhoneBaseViewController.h"
#import "SWRevealViewController.h"

@interface AMiPhoneBaseViewController ()

@end

@implementation AMiPhoneBaseViewController

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
    
    // Set the status bar content to white in navigation bar
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    if (![PFUser currentUser]) { // No user logged in
        // Create the log in view controller
        PFLogInViewController *logInViewController = [[PFLogInViewController alloc] init];
        [logInViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Create the sign up view controller
        PFSignUpViewController *signUpViewController = [[PFSignUpViewController alloc] init];
        [signUpViewController setDelegate:self]; // Set ourselves as the delegate
        
        // Assign our sign up controller to be displayed from the login controller
        [logInViewController setSignUpController:signUpViewController];
        
        // Present the log in view controller
        [self presentViewController:logInViewController animated:YES completion:NULL];
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"triangular"]];
    }
    
    // Change the menu button color
    //_sidebarButton.tintColor = [UIColor colorWithRed:0.118 green:0.302 blue:0.580 alpha:1.000];
    
    // Set the side bar button action to show slide out menu
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTap1:(id)sender {
    if ([self.check1.titleLabel.text length] == 0){
        [self.check1 setTitle:@"✔︎"
                 forState:UIControlStateNormal];
    } else {
        [self.check1 setTitle:@""
                 forState:UIControlStateNormal];
    }
}

- (IBAction)didTap2:(id)sender{
    if ([self.check2.titleLabel.text length] == 0){
        [self.check2 setTitle:@"✔︎"
                 forState:UIControlStateNormal];
    } else {
        [self.check2 setTitle:@""
                 forState:UIControlStateNormal];
    }
}

- (IBAction)didTap3:(id)sender{
    if ([self.check3.titleLabel.text length] == 0){
        [self.check3 setTitle:@"✔︎"
                 forState:UIControlStateNormal];
    } else {
        [self.check3 setTitle:@""
                 forState:UIControlStateNormal];
    }
}
@end
