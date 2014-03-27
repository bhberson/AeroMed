//
//  AMiPhoneSplashScreenViewController.h
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMSplashScreenViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator; 
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *signupButton;

- (IBAction)didTapLogin:(id)sender;
- (IBAction)didTapSignup:(id)sender;

@end
