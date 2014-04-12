//
//  AMiPadTransportViewController.h
//  AeroMed
//
//  Created by Brody Berson on 3/10/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>


@class AMiPadTransportViewController;

@protocol AMiPadTransportViewControllerDelegate <NSObject>
- (void)amiPadTransportViewControllerDidCancel:(AMiPadTransportViewController *)controller;
- (void)amiPadTransportViewController:(AMiPadTransportViewController *)controller didAddTransport:(PFObject *)transport;
@end

@interface AMiPadTransportViewController : UITableViewController <UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *crewMember4TextField;
@property (strong, nonatomic) IBOutlet UITextField *crewMember3TextField;
@property (strong, nonatomic) IBOutlet UITextField *crewMember2TextField;
@property (strong, nonatomic) IBOutlet UITextField *crewMember1TextField;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;
@property (strong, nonatomic) IBOutlet UITextField *ageGroupTextField;
@property (strong, nonatomic) IBOutlet UITextField *transportTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *specialTransportTextField;
@property (strong, nonatomic) UIPickerView *crewMemberPicker;
@property (strong, nonatomic) NSMutableArray *crewMemberArray;
@property (strong, nonatomic) UIPickerView *ageGroupPicker;
@property (strong, nonatomic) NSArray *ageGroupArray;
@property (strong, nonatomic) UIPickerView *transportTypePicker;
@property (strong, nonatomic) NSArray *transportTypeArray;
@property (strong, nonatomic) UIPickerView *specialTransportPicker;
@property (strong, nonatomic) NSArray *specialTransportArray;

@property (nonatomic, weak) id <AMiPadTransportViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;
- (void)dismissKeyboard;

@end