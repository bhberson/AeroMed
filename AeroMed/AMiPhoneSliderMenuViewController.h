//
//  AMSideBarViewController.h
//  AeroMed
//
//  Created by Michael Torres on 2/16/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AMiPhoneSliderMenuViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *sidebarButton;
- (void)logoutButtonTouchHandler:(id)sender;
@end
