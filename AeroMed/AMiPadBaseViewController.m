//
//  AMiPadBaseViewController.m
//  AeroMed
//
//  Created by Michael Torres on 2/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPadBaseViewController.h"
#import "SWRevealViewController.h"
#import "Transport.h"
#import "TransportCell.h"

@interface AMiPadBaseViewController ()

@end
@implementation AMiPadBaseViewController

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
    
    NSLog(@"User logged in? %@", [PFUser currentUser] ? @"YES" : @"NO");
    
    // Set the side bar button action to show slide out menu
    _sidebarButton.target = self.revealViewController;
    _sidebarButton.action = @selector(revealToggle:);
    
    // Set the status bar content to white in navigation bar
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Set the gesture
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
		UINavigationController *navigationController =
        segue.destinationViewController;
		AMiPadTransportViewController
        *amiPadTransportViewController =
        [[navigationController viewControllers]
         objectAtIndex:0];
		amiPadTransportViewController.delegate = self;
	}
}

- (void)amiPadTransportViewController:
(AMiPadTransportViewController *)controller
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
