//
//  AMiPadTransportViewController.m
//  AeroMed
//
//  Created by Brody Berson on 3/10/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPadTransportViewController.h"

@interface AMiPadTransportViewController ()

@end

@implementation AMiPadTransportViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
	if ((self = [super initWithCoder:aDecoder]))
	{
		NSLog(@"init AMiPadTransportViewController");
	}
	return self;
}

- (IBAction)cancel:(id)sender
{
    [self.delegate amiPadTransportViewControllerDidCancel:self];
}
- (IBAction)done:(id)sender
{
    Transport *transport = [[Transport alloc] init];
	transport.number = self.numTextField.text;
	[self.delegate amiPadTransportViewController:self
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
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
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

- (void)dismissKeyboard {
    [self.numTextField resignFirstResponder];
    [self.notesTextField resignFirstResponder];
}

- (void)dealloc
{
	NSLog(@"dealloc AMiPadTransportViewController");
}

@end
