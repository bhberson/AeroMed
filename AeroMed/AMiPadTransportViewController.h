//
//  AMiPadTransportViewController.h
//  AeroMed
//
//  Created by Brody Berson on 3/10/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Transport.h"

@class AMiPadTransportViewController;

@protocol AMiPadTransportViewControllerDelegate <NSObject>
- (void)amiPadTransportViewControllerDidCancel:(AMiPadTransportViewController *)controller;
- (void)amiPadTransportViewController:(AMiPadTransportViewController *)controller didAddTransport:(Transport *)transport;
@end

@interface AMiPadTransportViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;

@property (nonatomic, weak) id <AMiPadTransportViewControllerDelegate> delegate;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end