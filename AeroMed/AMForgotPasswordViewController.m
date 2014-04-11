//
//  AMForgotPasswordViewController.m
//  AeroMed
//
//  Created by Mario Galeno on 3/30/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMForgotPasswordViewController.h"
#import "UIAlertView+AMBlocks.h"

@interface AMForgotPasswordViewController ()

@end

@implementation AMForgotPasswordViewController

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
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(didTapBack:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.emailEntry setDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)didTapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissKeyboard {
    [self.emailEntry resignFirstResponder];
}


- (IBAction)didTapResetPassword:(id)sender {
    PFQuery *query = [PFUser query];
    [query whereKey:@"email" equalTo:[self.emailEntry text]];
    NSArray *users = [query findObjects];
    
    if ([users count] > 0) {
        [PFUser requestPasswordResetForEmail:[self.emailEntry text]];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Sent" message:@"Check your email for further instructions" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
        
        [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Email Error" message:@"The email you entered is not associated with a user" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alert show];
        
    }
}

@end
