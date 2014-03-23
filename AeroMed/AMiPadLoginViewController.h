//
//  AMiPadLoginViewController.h
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMiPadLoginViewController : UIViewController <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UITextField *passwordEntry;
@property (weak, nonatomic) IBOutlet UITextField *usernameEntry;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIPickerView *userPicker;

@property (strong, nonatomic) NSMutableArray *allUsers;

- (IBAction)didTapLogin:(id)sender;
- (void)dismissKeyboard;

@end
