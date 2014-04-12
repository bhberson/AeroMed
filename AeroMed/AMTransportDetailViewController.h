//
//  AMTransportDetailViewController.h
//  AeroMed
//
//  Created by Brody Berson on 4/9/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AMTransportDetailViewController : UITableViewController <UINavigationControllerDelegate>

@property (strong, nonatomic) PFObject *detailItem;
@property (strong, nonatomic) IBOutlet UITextField *crewMember4TextField;
@property (strong, nonatomic) IBOutlet UITextField *crewMember3TextField;
@property (strong, nonatomic) IBOutlet UITextField *crewMember2TextField;
@property (strong, nonatomic) IBOutlet UITextField *crewMember1TextField;
@property (weak, nonatomic) IBOutlet UITextField *numTextField;
@property (weak, nonatomic) IBOutlet UITextField *notesTextField;
@property (strong, nonatomic) IBOutlet UITextField *ageGroupTextField;
@property (strong, nonatomic) IBOutlet UITextField *transportTypeTextField;
@property (strong, nonatomic) IBOutlet UITextField *specialTransportTextField;


@end
