//
//  AMForgotPasswordViewController.h
//  AeroMed
//
//  Created by Mario Galeno on 3/30/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMForgotPasswordViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *emailEntry;

- (IBAction)didTapResetPassword:(id)sender;

- (void) dismissKeyboard;
@end
