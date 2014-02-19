//
//  AMiPadSignupViewController.h
//  AeroMed
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMiPadSignupViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *signupButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordEntry;
@property (weak, nonatomic) IBOutlet UITextField *usernameEntry;
@property (weak, nonatomic) IBOutlet UITextField *emailEntry;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
- (IBAction)didTapSignup:(id)sender;
@end
