//
//  AMiPhoneBaseViewController.h
//  AeroMed
//
//  Created by Michael Torres on 2/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMiPhoneBaseViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;

@property (weak, nonatomic) IBOutlet UIButton *check1;

@property (weak, nonatomic) IBOutlet UIButton *check2;

@property (weak, nonatomic) IBOutlet UIButton *check3;

@property (weak, nonatomic) IBOutlet UILabel *label1;

@property (weak, nonatomic) IBOutlet UILabel *label2;

@property (weak, nonatomic) IBOutlet UILabel *label3;

- (IBAction)didTap1:(id)sender;

- (IBAction)didTap2:(id)sender;

- (IBAction)didTap3:(id)sender;

@end
