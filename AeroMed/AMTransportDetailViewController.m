//
//  AMTransportDetailViewController.m
//  AeroMed
//
//  Created by Brody Berson on 4/9/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMTransportDetailViewController.h"

@interface AMTransportDetailViewController ()

@end

@implementation AMTransportDetailViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self.detailItem) {
        self.numTextField.text = self.detailItem.transportNumber;
        self.crewMember1TextField.text = self.detailItem.crewMembers[0];
        self.crewMember2TextField.text = self.detailItem.crewMembers[1];
        self.crewMember3TextField.text = self.detailItem.crewMembers[2];
        self.crewMember4TextField.text = self.detailItem.crewMembers[3];
        self.ageGroupTextField.text = self.detailItem.ageGroup;
        self.transportTypeTextField.text = self.detailItem.transportType;
        self.specialTransportTextField.text = self.detailItem.specialTransport;
        self.notesTextField.text = self.detailItem.otherNotes;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
