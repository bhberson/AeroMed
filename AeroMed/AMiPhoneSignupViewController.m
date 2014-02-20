//
//  AMiPoneSignupViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPhoneSignupViewController.h"

@interface AMiPhoneSignupViewController ()

@end

@implementation AMiPhoneSignupViewController

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

    // Back up in navigation
    UIImage *backArrow = [UIImage imageNamed:@"backArrow"];
    UIImage *backArrowPressed = [UIImage imageNamed:@"backArrowPressed"];
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:backArrow forState:UIControlStateNormal];
    [backButton setImage:backArrowPressed forState:UIControlStateSelected];
    
    backButton.frame = CGRectMake(2.0f, 2.0f, 40.0f, 40.0f);
    [backButton addTarget:self action:@selector(didTapBack:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    self.navigationItem.leftBarButtonItem = back;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"triangular"]];
    
    [self.usernameEntry setDelegate:self];
    [self.passwordEntry setDelegate:self];
    [self.emailEntry setDelegate:self];
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapSignup:(id)sender {
    
    NSString *user = [self.usernameEntry text];
    NSString *pass = [self.passwordEntry text];
    NSString *email = [self.emailEntry text];
    
    if ([user length] < 4 || [pass length] < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Username and Password must both be at least 4 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else if ([email length] < 8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter your email address." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else {
        
        [self.activityIndicator startAnimating];
        
        // Create a new user 
        PFUser *newUser = [PFUser user];
        newUser.username = user;
        newUser.password = pass;
        newUser.email = email;
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            [self.activityIndicator stopAnimating];
            if (error) {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            } else {
                [self performSegueWithIdentifier:@"signupToMain" sender:self];
            }
        }];
    }
    
}

- (void)didTapBack:(id)sender {
    NSLog(@"Going back.");
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissKeyboard {
    [self.usernameEntry resignFirstResponder];
    [self.passwordEntry resignFirstResponder];
    [self.emailEntry resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
@end
