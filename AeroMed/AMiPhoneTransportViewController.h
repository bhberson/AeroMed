//
//  AMiPhoneTransportViewController.h
//  AeroMed
//
//  Created by Brody Berson on 3/9/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transport.h"

@class AMiPhoneTransportViewController;

@protocol AMiPhoneTransportViewControllerDelegate <NSObject>
- (void)amiPhoneTransportViewControllerDidCancel:(AMiPhoneTransportViewController *)controller;
- (void)amiPhoneTransportViewController:(AMiPhoneTransportViewController *)controller didAddTransport:(Transport *)transport;
@end

@interface AMiPhoneTransportViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;

@property (nonatomic, weak) id <AMiPhoneTransportViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
