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
    transport.crewMembers = [[NSMutableArray alloc] init];
    if (self.crewMember1TextField.text != nil) {
        [transport.crewMembers addObject:self.crewMember1TextField.text];
    }
    if (self.crewMember2TextField.text != nil) {
        [transport.crewMembers addObject:self.crewMember2TextField.text];
    }
    if (self.crewMember3TextField.text != nil) {
        [transport.crewMembers addObject:self.crewMember3TextField.text];
    }
    if (self.crewMember4TextField.text != nil) {
        [transport.crewMembers addObject:self.crewMember4TextField.text];
    }
    transport.ageGroup = self.ageGroupTextField.text;
    transport.transportType = self.transportTypeTextField.text;
    transport.specialTransport = self.specialTransportTextField.text;
    transport.otherNotes = self.notesTextField.text;
	[self.delegate amiPhoneTransportViewController:self
                                   didAddTransport:transport];
}

- (instancetype)initWithStyle:(UITableViewStyle)style
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
    self.crewMemberPicker = [[UIPickerView alloc] init];
    self.crewMemberPicker.delegate = self;
    self.crewMemberPicker.dataSource = self;
    self.crewMemberPicker.showsSelectionIndicator = YES;
    self.crewMember1TextField.inputView = self.crewMemberPicker;
    self.crewMember2TextField.inputView = self.crewMemberPicker;
    self.crewMember3TextField.inputView = self.crewMemberPicker;
    self.crewMember4TextField.inputView = self.crewMemberPicker;
    self.ageGroupPicker = [[UIPickerView alloc] init];
    self.ageGroupPicker.delegate = self;
    self.ageGroupPicker.dataSource = self;
    self.ageGroupPicker.showsSelectionIndicator = YES;
    self.ageGroupTextField.inputView = self.ageGroupPicker;
    self.ageGroupArray = [[NSArray alloc] initWithObjects:@"Adult",@"Pediatric",@"Neonatal",nil];
    [self pickerView:self.ageGroupPicker
        didSelectRow:0
         inComponent:0];
    self.transportTypePicker = [[UIPickerView alloc] init];
    self.transportTypePicker.delegate = self;
    self.transportTypePicker.dataSource = self;
    self.transportTypePicker.showsSelectionIndicator = YES;
    self.transportTypeTextField.inputView = self.transportTypePicker;
    self.transportTypeArray = [[NSArray alloc] initWithObjects:@"Rotor Wing",@"Fixed Wing",@"Ground",nil];
    [self pickerView:self.transportTypePicker
        didSelectRow:0
         inComponent:0];
    self.specialTransportPicker = [[UIPickerView alloc] init];
    self.specialTransportPicker.delegate = self;
    self.specialTransportPicker.dataSource = self;
    self.specialTransportPicker.showsSelectionIndicator = YES;
    self.specialTransportTextField.inputView = self.specialTransportPicker;
    self.specialTransportArray = [[NSArray alloc] initWithObjects:@"Isolette",@"LVAD",@"IABP",@"NICU", @"Other in Notes",nil];
    [self pickerView:self.specialTransportPicker
        didSelectRow:0
         inComponent:0];
    
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
    [self.crewMember1TextField resignFirstResponder];
    [self.crewMember2TextField resignFirstResponder];
    [self.crewMember3TextField resignFirstResponder];
    [self.crewMember4TextField resignFirstResponder];
    [self.ageGroupTextField resignFirstResponder];
    [self.transportTypeTextField resignFirstResponder];
    [self.specialTransportTextField resignFirstResponder];

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

    if(pickerView == self.crewMemberPicker) {
        self.crewMember1TextField.text = [self.crewMemberArray objectAtIndex:row];
    } else if(pickerView == self.ageGroupPicker) {
        self.ageGroupTextField.text = [self.ageGroupArray objectAtIndex:row];
    } else if(pickerView == self.transportTypePicker) {
        self.transportTypeTextField.text = [self.transportTypeArray objectAtIndex:row];
    }else if(pickerView == self.specialTransportPicker) {
        self.specialTransportTextField.text = [self.specialTransportArray objectAtIndex:row];
    }else {
        assert(NO);
    }
    
}

@end
