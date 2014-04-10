//
//  AMTransportDetailViewController.m
//  AeroMed
//
//  Created by Brody Berson on 4/9/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMTransportDetailViewController.h"
#import "AMBaseDocumentViewController.h"

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
        
        UIBarButtonItem *docs = [[UIBarButtonItem alloc] initWithTitle:@"Documents" style:UIBarButtonItemStyleDone target:self action:@selector(docTapped)];
        self.navigationItem.rightBarButtonItem = docs;
        
        self.numTextField.text = [self.detailItem[@"TransportNumber"] stringValue];
        NSArray *crewMembers = self.detailItem[@"CrewMembers"];
        self.crewMember1TextField.text = [crewMembers objectAtIndex:0];
        self.crewMember2TextField.text = [crewMembers objectAtIndex:1];
        self.crewMember3TextField.text = [crewMembers objectAtIndex:2];
        self.crewMember4TextField.text = [crewMembers objectAtIndex:3];
        self.ageGroupTextField.text = self.detailItem[@"ageGroup"];
        self.transportTypeTextField.text = self.detailItem[@"transportType"];
        self.specialTransportTextField.text = self.detailItem[@"specialTransport"];
        self.notesTextField.text = self.detailItem[@"otherNotes"];
    }
}

- (void)docTapped {
    [self performSegueWithIdentifier:@"toBaseDocuments" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toBaseDocuments"]) {
        AMBaseDocumentViewController *vc = (AMBaseDocumentViewController *)segue.destinationViewController;
        [vc setTransportData:self.detailItem]; 
    }
    
}
@end
