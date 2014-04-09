//
//  AMiPhoneBaseViewController.h
//  AeroMed
//
//  Created by Michael Torres on 2/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMiPhoneTransportViewController.h"
#import "AMiPadTransportViewController.h"

@interface AMBaseViewController : UITableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, AMiPhoneTransportViewControllerDelegate, AMiPadTransportViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, strong) NSMutableArray *transports;
@property(weak, nonatomic) IBOutlet UITableView *tableView;

@end
