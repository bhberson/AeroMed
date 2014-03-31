//
//  AMiPhoneLoginViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMLoginViewController.h"
#include<unistd.h>
#include<netdb.h>

@interface AMLoginViewController ()

@end

@implementation AMLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(didTapBack:)];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.usernameEntry setDelegate:self];
    [self.passwordEntry setDelegate:self];
    
    // Tags used to distinguish textfields
    self.usernameEntry.tag = 0;
    self.passwordEntry.tag = 1;
    
    // Initially hide UIPicker
    self.userPicker.hidden = YES;
    
    // Query for all users
    [self queryForUsers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)didTapLogin:(id)sender {
    
    NSString *user = [self.usernameEntry text];
    NSString *pass = [self.passwordEntry text];
    
    if ([user length] < 4 || [pass length] < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Username and Password must both be at least 4 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else {
        [self.activityIndicator startAnimating];
        [PFUser logInWithUsernameInBackground:user password:pass block:^(PFUser *user, NSError *error) {
            [self.activityIndicator stopAnimating];
            if (user) {
                [self performSegueWithIdentifier:@"loginToMain" sender:self];
            } else {
                NSLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:@"Invalid Username and/or Password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                [alert show];
            }
        }];
    }
}

- (IBAction)didTapForgotPassword:(id)sender {
    [self performSegueWithIdentifier:@"loginToForgot" sender:self];
}

- (void)didTapBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag != 0) {
        self.userPicker.hidden = YES;
        return YES;
    } else {
        [textField resignFirstResponder];
        self.userPicker.hidden = NO;
        return NO;
    }
}

- (void)dismissKeyboard {
    self.userPicker.hidden = YES; // dismiss UIPickerView
    [self.passwordEntry resignFirstResponder];
}

#pragma mark - UIPicker Delegate methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.allUsers count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    PFUser *user = [self.allUsers objectAtIndex:row];
    return user.username;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {

    PFUser *user = [self.allUsers objectAtIndex:row];
    self.usernameEntry.text = user.username;
}


#pragma mark - Queries

// Query for all users
- (void) queryForUsers {
    PFQuery *query = [PFUser query];
    
    self.allUsers = [NSMutableArray array];
    
    if ([self isNetworkAvailable]) {
        query.cachePolicy = kPFCachePolicyNetworkElseCache;
        [self.allUsers addObjectsFromArray:[query findObjects]];
    } else {
        NSLog(@"No connection for login");
       query.cachePolicy = kPFCachePolicyCacheOnly;
       [self.allUsers addObjectsFromArray:[query findObjects]];
    }
}

- (IBAction)showMessage:(id)sender {
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Data"
                                                      message:@"Sorry no data. Please connect to wifi."
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
    
    [message show];
}


-(BOOL)isNetworkAvailable
{
    char *hostname;
    struct hostent *hostinfo;
    hostname = "google.com";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection!\n");
        return NO;
    }
    else{
        NSLog(@"-> connection established!\n");
        return YES;
    }
}
@end
