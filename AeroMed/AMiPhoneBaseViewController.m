//
//  AMiPhoneBaseViewController.m
//  AeroMed
//
//  Created by Michael Torres on 2/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPhoneBaseViewController.h"
#import "SWRevealViewController.h"
#import "OperatingProcedure.h"

@interface AMiPhoneBaseViewController ()
@property NSMutableArray *documents;

@end

@implementation AMiPhoneBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.documents = [NSMutableArray array];
    
    // Set the status bar content to white in navigation bar
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    
    // Set the side bar button action to show slide out menu
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
    [self initStandardDocuments];
    
    NSLog(@"Saved document %@", [[self.documents objectAtIndex:0] title]);
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Create the standard documents
- (void)initStandardDocuments {
    
    OperatingProcedure *alcoholWithdrawal = [OperatingProcedure object];
    alcoholWithdrawal.title = @"Acute Alcohol Withdrawal";
    alcoholWithdrawal.originalDate = @"18 October 2012";
    alcoholWithdrawal.revisedDate = @"18 October 2012";
    alcoholWithdrawal.considerations = @[@"Patient and Crew Safety due to patient anxiety, etc"];
    alcoholWithdrawal.interventions = @[@"Treat withdrawal symptoms aggressively",
                                        @"Anticipate Seizures",
                                        @"Consider associated diagnosis",
                                        @"Head injury",
                                        @"GI Bleed",
                                        @"Infection/Sepsis"];
    alcoholWithdrawal.testsAndStudies = @[@"Blood Alcohol Level",
                                          @"CMP",
                                          @"Head CT",
                                          @"12 Lead ECG"];
    alcoholWithdrawal.medications = @[@"Benzodiazepines",
                                      @"Diprovan (propofol)",
                                      @"Thiamine",
                                      @"Glucose"];
    alcoholWithdrawal.checklist = @[@"Duration/Amount of alcohol ingestion",
                                    @"Time of last alcohol intake",
                                    @"Other substance ingestion"];
    alcoholWithdrawal.impressions = @[@"Acute alcohol withdrawal",
                                      @"Alcohol Dependence",
                                      @"Delirium Tremens",
                                      @"Acute agitation"];
    alcoholWithdrawal.otherConsiderations = nil;
    

    // Add all documents
    [self.documents addObject:alcoholWithdrawal];
  
    
}

@end
