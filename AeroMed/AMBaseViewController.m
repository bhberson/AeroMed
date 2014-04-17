//
//  AMiPhoneBaseViewController.m
//  AeroMed
//
//  Created by Michael Torres on 2/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMBaseViewController.h"
#import "AMTransportDetailViewController.h"
#import "SWRevealViewController.h"
#import "TransportCell.h"

@interface AMBaseViewController ()
@property NSMutableArray *documents;

@end

@implementation AMBaseViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self retrieveTransports];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (self) {
        self.documents = [NSMutableArray array];
        self.transports = [[NSMutableArray alloc] init];

        
        // Set the status bar content to white in navigation bar
        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

        
        // Set the side bar button action to show slide out menu
        self.sidebarButton.target = self.revealViewController;
        self.sidebarButton.action = @selector(revealToggle:);
        [self.tableView setDelegate:self];
        [self.tableView setDataSource:self];

        // Set the gesture
        
        // Admins can swipe left to delete so they do not get this gesture
        if (![[PFUser currentUser] objectForKey:@"isAdmin"]) {
            [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
        }
        
    }
  
}

- (void)retrieveTransports
{
    NSMutableArray *allTransports = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Transport"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query orderByDescending:@"createdAt"];
    [query setLimit: 1000];
    
    __weak AMBaseViewController *weakSelf = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. Add the returned objects to allObjects
            [allTransports addObjectsFromArray:objects];

            weakSelf.transports = [NSMutableArray arrayWithArray:objects];
            [weakSelf.tableView reloadData];

            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Admins can only edit.
    if ([[PFUser currentUser] objectForKey:@"isAdmin"]) {
        return YES;
    } else {
        return NO;
    }
}

// Delete the transport
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *transport = [self.transports objectAtIndex:indexPath.row];
    [self.transports removeObject:transport];
    [transport deleteInBackground];
    [self.tableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"TransportCell";
    TransportCell *cell = (TransportCell *)[tableView
                                            dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[TransportCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    PFObject *transport = [self.transports objectAtIndex:indexPath.row];
    cell.numLabel.text = [transport[@"TransportNumber"] stringValue];
    cell.typeLabel.text = transport[@"transportType"];
    
    // If we need to set the transport a checklist
    if (!transport[@"checklist"]) {
        cell.hasChecklist.hidden = NO;
    } else {
        cell.hasChecklist.hidden = YES;
    }

    return cell;
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

- (void)amiPadTransportViewControllerDidCancel:
(AMiPadTransportViewController *)controller
{
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)amiPadTransportViewControllerDidSave:
(AMiPadTransportViewController *)controller
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
        AMiPadTransportViewController
        *amiPadTransportViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
		amiPadTransportViewController.delegate = self;
	}
    if ([segue.identifier isEqualToString:@"ViewTransport"])
	{
        AMTransportDetailViewController *detailController = (AMTransportDetailViewController *)segue.destinationViewController;
        detailController.detailItem = [self.transports objectAtIndex:self.tableView.indexPathForSelectedRow.row]; 
    }
}

- (void)amiPhoneTransportViewController:
(AMiPhoneTransportViewController *)controller
                        didAddTransport:(PFObject *)transport
{
	[self.transports insertObject:transport atIndex:0];
    
    [self.tableView reloadData];
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)amiPadTransportViewController:
(AMiPadTransportViewController *)controller
                        didAddTransport:(PFObject *)transport
{
	[self.transports insertObject:transport atIndex:0];
    
    [self.tableView reloadData];
    
	[self dismissViewControllerAnimated:YES completion:nil];
}

@end
