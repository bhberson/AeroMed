//
//  AMiPadLoginViewController.h
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMiPadLoginViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordEntry;
@property (weak, nonatomic) IBOutlet UITextField *usernameEntry;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (IBAction)didTapLogin:(id)sender;
@end
