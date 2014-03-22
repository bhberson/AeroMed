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
    
    if (self) {
        self.documents = [NSMutableArray array];
        
        // Set the status bar content to white in navigation bar
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

        
        // Set the side bar button action to show slide out menu
        _sidebarButton.target = self.revealViewController;
        _sidebarButton.action = @selector(revealToggle:);
        
        // Set the gesture
        [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        
        [self initStandardDocuments];
    }
  
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Create the standard documents
- (void)initStandardDocuments {
    
    [self queryForDocuments];
    [self queryForFiles];
  
}

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
	cell.numLabel.text = transport.transportNumber;

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
        
		UINavigationController *navigationController = (UINavigationController *)
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
#warning This was causing the nil pointer when done pressed
//	[self.tableView insertRowsAtIndexPaths:
//     [NSArray arrayWithObject:indexPath]
//                          withRowAnimation:UITableViewRowAnimationAutomatic];
	[self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Queries

// Query for the document contents
-(void) queryForDocuments {
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    
    PFQuery *query = [PFQuery queryWithClassName:@"OperatingProcedure"];
    [query whereKeyExists:@"title"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (!error) {
            // Save an array of PFObjects
            NSMutableArray *operatingProcedures = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            
            for (int i = 0; i < objects.count; i++) {
                OperatingProcedure *op = objects[i];
                [operatingProcedures addObject:op];
            }
            
            // Save to file
            [NSKeyedArchiver archiveRootObject:operatingProcedures toFile:[OperatingProcedure getPathToArchive]];

        }
        
    }];
}

// Query for all the filenames and structure
- (void) queryForFiles {
    
    NSUserDefaults *storage = [NSUserDefaults standardUserDefaults];
    
    PFQuery *query = [PFQuery queryWithClassName:@"NavigationStructure"];
    [query whereKey:@"organization" equalTo:@"Aero Med"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *company = [objects firstObject];
            
            // Get the structure property which is an array
            NSArray *structure = company[@"structure"];
            [storage setObject:structure forKey:@"structure"];
            [storage synchronize];
        }
        
    }];
}
@end
