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
    NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myTransportNumber = [f numberFromString:self.numTextField.text];
    
    PFQuery *query = [PFQuery queryWithClassName:@"Transport"];
    
    [query whereKey:@"TransportNumber" equalTo:myTransportNumber];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count != 0){
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Transport Cancelled" message:@"Transport number already exists." delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
                
                [alert show];
                
                [self.delegate amiPhoneTransportViewControllerDidCancel:self];
            }
            else{
                
                NSMutableArray *crew = [NSMutableArray array];
                if (self.crewMember1TextField.text != nil) {
                    [crew addObject:self.crewMember1TextField.text];
                }
                if (self.crewMember2TextField.text != nil) {
                    [crew addObject:self.crewMember2TextField.text];
                }
                if (self.crewMember3TextField.text != nil) {
                    [crew addObject:self.crewMember3TextField.text];
                }
                if (self.crewMember4TextField.text != nil) {
                    [crew addObject:self.crewMember4TextField.text];
                }
                
                // Create the object.
                PFObject *pfTransport = [PFObject objectWithClassName:@"Transport"];
                [pfTransport setObject:myTransportNumber forKey:@"TransportNumber"];
                [pfTransport setObject:crew forKey:@"CrewMembers"];
                [pfTransport setObject:self.ageGroupTextField.text forKey:@"ageGroup"];
                [pfTransport setObject:self.transportTypeTextField.text forKey:@"transportType"];
                [pfTransport setObject:self.specialTransportTextField.text forKey:@"specialTransport"];
                [pfTransport setObject:self.notesTextField.text forKey:@"otherNotes"];
                // Save it as soon as is convenient.
                [pfTransport saveEventually];
                [self.delegate amiPhoneTransportViewController:self
                                               didAddTransport:pfTransport];
                
            }
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
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
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor lightGrayColor];
    
    [self retrieveUsers];
    self.numTextField.delegate = self;
    self.crewMemberPicker = [[UIPickerView alloc] init];
    self.crewMemberPicker.delegate = self;
    self.crewMemberPicker.dataSource = self;
    self.crewMemberPicker.showsSelectionIndicator = YES;
    self.crewMember1TextField.delegate = self;
    self.crewMember1TextField.inputView = self.crewMemberPicker;
    self.crewMember2TextField.delegate = self;
    self.crewMember2TextField.inputView = self.crewMemberPicker;
    self.crewMember3TextField.delegate = self;
    self.crewMember3TextField.inputView = self.crewMemberPicker;
    self.crewMember4TextField.delegate = self;
    self.crewMember4TextField.inputView = self.crewMemberPicker;
    self.ageGroupPicker = [[UIPickerView alloc] init];
    self.ageGroupPicker.delegate = self;
    self.ageGroupPicker.dataSource = self;
    self.ageGroupPicker.showsSelectionIndicator = YES;
    self.ageGroupTextField.delegate = self;
    self.ageGroupTextField.inputView = self.ageGroupPicker;
    self.ageGroupArray = [[NSArray alloc] initWithObjects:@"Adult",@"Pediatric",@"Neonatal",nil];
    [self pickerView:self.ageGroupPicker
        didSelectRow:0
         inComponent:0];
    self.transportTypePicker = [[UIPickerView alloc] init];
    self.transportTypePicker.delegate = self;
    self.transportTypePicker.dataSource = self;
    self.transportTypePicker.showsSelectionIndicator = YES;
    self.transportTypeTextField.delegate = self;
    self.transportTypeTextField.inputView = self.transportTypePicker;
    self.transportTypeArray = [[NSArray alloc] initWithObjects:@"Rotor Wing",@"Fixed Wing",@"Ground",nil];
    [self pickerView:self.transportTypePicker
        didSelectRow:0
         inComponent:0];
    self.specialTransportPicker = [[UIPickerView alloc] init];
    self.specialTransportPicker.delegate = self;
    self.specialTransportPicker.dataSource = self;
    self.specialTransportPicker.showsSelectionIndicator = YES;
    self.specialTransportTextField.delegate = self;
    self.specialTransportTextField.inputView = self.specialTransportPicker;
    self.specialTransportArray = [[NSArray alloc] initWithObjects:@"Isolette",@"LVAD",@"IABP",@"NICU", @"Other in Notes",nil];
    self.specialTransportTextField.placeholder = @"Leave Blank for None";
    self.notesTextField.delegate = self;
    self.notesTextField.placeholder = @"Leave Blank for None";
    
    NSDate *now = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    
    NSString *stringFromDate = [formatter stringFromDate:now];
    
    self.numTextField.text = [NSString stringWithFormat:@"%@%@", @"25", stringFromDate];
    self.numTextField.placeholder = [NSString stringWithFormat:@"%@%@%@", @"25", stringFromDate, @"XXXXX"];
    
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
        if ([self.crewMember1TextField isFirstResponder]) {
            self.crewMember1TextField.text = [self.crewMemberArray objectAtIndex:row];
        } else if ([self.crewMember2TextField isFirstResponder]) {
            self.crewMember2TextField.text = [self.crewMemberArray objectAtIndex:row];
        } else if ([self.crewMember3TextField isFirstResponder]) {
            self.crewMember3TextField.text = [self.crewMemberArray objectAtIndex:row];
        } else {
            self.crewMember4TextField.text = [self.crewMemberArray objectAtIndex:row];
        }
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == self.numTextField) {
        [self.notesTextField becomeFirstResponder];
        
        // scroll to row!
        
    } else if (textField == self.notesTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    UIBarButtonItem *doneButton = self.navigationItem.rightBarButtonItem;
    
    // verify the text field you wanna validate
    if (textField == self.numTextField) {
        if ([textField.text length] == 11) {
            doneButton.enabled = YES;
            doneButton.tintColor = [UIColor whiteColor];
        }
        if ([textField.text length] != 11) {
            doneButton.enabled = NO;
            doneButton.tintColor = [UIColor lightGrayColor];
        }
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    UIBarButtonItem *doneButton = self.navigationItem.rightBarButtonItem;
    
    // verify the text field you wanna validate
    if (textField == _numTextField) {
        
        if ([textField.text length] == 11) {
            doneButton.enabled = YES;
            doneButton.tintColor = [UIColor whiteColor];
        }
        if ([textField.text length] != 11) {
            doneButton.enabled = NO;
            doneButton.tintColor = [UIColor lightGrayColor];
        }
        
        // allow backspace
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length < textField.text.length) {
            return YES;
        }
        
        // in case you need to limit the max number of characters
        if ([textField.text stringByReplacingCharactersInRange:range withString:string].length > 11) {
            return NO;
        }
        
        // limit the input to only the stuff in this character set, so no emoji or cirylic or any other insane characters
        NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
        
        if ([string rangeOfCharacterFromSet:set].location != NSNotFound) {
            return YES;
        }
        
        return NO;
    }
    
    return YES;
}

@end
