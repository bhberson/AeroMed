//
//  AMiPhoneTransportViewController.m
//  AeroMed
//
//  Created by Brody Berson on 3/9/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPhoneTransportViewController.h"

@interface AMiPhoneTransportViewController ()

@end

@implementation AMiPhoneTransportViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		NSLog(@"init AMiPhoneTransportViewController");
	}
	return self;
}

- (IBAction)cancel:(id)sender
{
    [self.delegate amiPhoneTransportViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
    Transport *transport = [[Transport alloc] init];
	transport.number = self.numTextField.text;
	[self.delegate amiPhoneTransportViewController:self
                                   didAddTransport:transport];
}

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	if (indexPath.section == 0)
		[self.numTextField becomeFirstResponder];
}

- (void)dealloc
{
	NSLog(@"dealloc PlayerDetailsViewController");
}

@end
