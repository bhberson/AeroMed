//
//  AMiPadBaseViewController.h
//  AeroMed
//
//  Created by Michael Torres on 2/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMiPadTransportViewController.h"

@interface AMiPadBaseViewController : UITableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate, AMiPadTransportViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
@property (nonatomic, strong) NSMutableArray *transports;

@end
