//
//  AMiPadBaseViewController.m
//  AeroMed
//
//  Created by Michael Torres on 2/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPadBaseViewController.h"
#import "SWRevealViewController.h"

@interface AMiPadBaseViewController ()

@end
@implementation AMiPadBaseViewController

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
    
    NSLog(@"User logged in? %@", [PFUser currentUser] ? @"YES" : @"NO");
    
    // Set the side bar button action to show slide out menu
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"triangular"]];
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Login code 

///*!
// Sent to the delegate to determine whether the log in request should be submitted to the server.
// @param username the username the user tries to log in with.
// @param password the password the user tries to log in with.
// @result a boolean indicating whether the log in should proceed.
// */
//- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password{
//    // Check if both fields are completed
//    if (username && password && username.length != 0 && password.length != 0){
//        [PFUser logInWithUsernameInBackground:username
//                                     password:password
//                                       target:self
//                                     selector:@selector(handleUserLogin:error:)];
//        return YES; // Begin login process
//    }
//    
//    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
//                                message:@"Please fill out all information!"
//                               delegate:nil
//                      cancelButtonTitle:@"OK"
//                      otherButtonTitles:nil] show];
//    return NO; // Interrupt login process
//}
//
///*! @name Responding to Actions */
///// Sent to the delegate when a PFUser is logged in.
//- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user{
//    [self dismissViewControllerAnimated:YES completion:NULL];
//}
//
///// Sent to the delegate when the log in attempt fails.
//- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error{
//    NSLog(@"User failed to log in");
//}
//
///// Sent to the delegate when the log in screen is dismissed.
//- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController{
//    [self.navigationController popViewControllerAnimated:YES];
//    
//}
//
//- (void) handleUserLogin:(PFUser *)user error:(NSError *)error {
//    if (user) {
//        // Login successful
//        [self dismissViewControllerAnimated:YES completion:NULL];
//    } else {
//        // unsucessful login
//        NSLog(@"%@", [error localizedDescription]);
//        
//        [[[UIAlertView alloc] initWithTitle:@"Unsuccessful Login"
//                                    message:@"Please try again"
//                                   delegate:nil
//                          cancelButtonTitle:@"Ok"
//                          otherButtonTitles:nil] show];
//    }
//}

@end
