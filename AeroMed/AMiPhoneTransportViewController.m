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
	transport.transportNumber = self.numTextField.text;
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
    
    [self retrieveUsers];
    self.ageGroupArray = [[NSArray alloc] initWithObjects:@"Adult",@"Pediatric",@"Neonatal",nil];
    self.transportTypeArray = [[NSArray alloc] initWithObjects:@"Rotor Wing",@"Fixed Wing",@"Ground",nil];
    self.specialTransportArray = [[NSArray alloc] initWithObjects:@"Isolette",@"LVAD",@"IABP",@"NICU", @"Other in Notes",nil];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}

- (void)retrieveUsers
{
    NSMutableArray *allUsers = [[NSMutableArray alloc] init];
    self.crewMemberArray = [[NSMutableArray alloc] init];
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. The first 100 objects are available in objects
            [allUsers addObjectsFromArray:objects];
            for (PFUser* key in allUsers) {
                [self.crewMemberArray addObject:key.username];
            }
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
	NSLog(@"dealloc AMiPhoneTransportViewController");
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(pickerView == self.crewMemberPicker) {
        return [self.crewMemberArray count];
    } else if(pickerView == self.ageGroupPicker) {
        return [self.ageGroupArray count];
    } else if(pickerView == self.transportTypePicker) {
        return [self.transportTypeArray count];
    }else if(pickerView == self.specialTransportPicker) {
        return [self.specialTransportArray count];
    }else {
        assert(NO);
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)eve
{
    
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    //return [self.crewMemberArray objectAtIndex:row];
    if(pickerView == self.crewMemberPicker) {
        return [self.crewMemberArray objectAtIndex:row];
    } else if(pickerView == self.ageGroupPicker) {
        return [self.ageGroupArray objectAtIndex:row];
    } else if(pickerView == self.transportTypePicker) {
        return [self.transportTypeArray objectAtIndex:row];
    }else if(pickerView == self.specialTransportPicker) {
        return [self.specialTransportArray objectAtIndex:row];
    }else {
        assert(NO);
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

    
} //this method displays whenever selection indicator stops the row title is set as button title.

@end
