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
#import "Transport.h"
#import "TransportCell.h"

@interface AMiPhoneBaseViewController ()
@property NSMutableArray *documents;

@end

@implementation AMiPhoneBaseViewController

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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
	return [self.transports count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	TransportCell *cell = (TransportCell *)[tableView
                                      dequeueReusableCellWithIdentifier:@"TransportCell"];
	Transport *transport = [self.transports objectAtIndex:indexPath.row];
	cell.numLabel.text = transport.number;

    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (editingStyle == UITableViewCellEditingStyleDelete)
	{
		[self.transports removeObjectAtIndex:indexPath.row];
		[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
	}
}

- (void)amiPhoneTransportViewControllerDidCancel:
(AMiPhoneTransportViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)amiPhoneTransportViewControllerDidSave:
(AMiPhoneTransportViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"AddTransport"])
	{
		UINavigationController *navigationController =
        segue.destinationViewController;
		AMiPhoneTransportViewController
        *amiPhoneTransportViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
		amiPhoneTransportViewController.delegate = self;
	}
}

- (void)amiPhoneTransportViewController:
(AMiPhoneTransportViewController *)controller
                       didAddTransport:(Transport *)transport
{
	[self.transports addObject:transport];
	NSIndexPath *indexPath =
    [NSIndexPath indexPathForRow:[self.transports count] - 1
                       inSection:0];
	[self.tableView insertRowsAtIndexPaths:
     [NSArray arrayWithObject:indexPath]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
