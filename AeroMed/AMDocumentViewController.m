//
//  AMDocumentViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
#import "AMDocumentViewController.h"
#import "AMDocumentTableViewCell.h"
#import "UIAlertView+AMBlocks.h"



@interface AMDocumentViewController ()

@property id <ChecklistProtocol> myDelegate;
@property (strong, nonatomic) NSMutableArray *sectionNames;
@property (strong, nonatomic) NSMutableDictionary *data;
@property (strong, nonatomic) NSMutableArray *checkListItems;
@property BOOL isAdmin;

@end

@implementation AMDocumentViewController 

-(void) viewDidLoad {
    [super viewDidLoad];

    // Contains section names as the key and the database key as the value
    self.data = [[NSMutableDictionary alloc] initWithDictionary:self.doc[@"sections"]];
    self.sectionNames = [[NSMutableArray alloc] initWithArray:[self.data allValues]];
    
    // Move dates to top if they are there
    if ([self.sectionNames containsObject:@"Date Created"]) {
        [self.sectionNames removeObject:@"Date Created"];
        [self.sectionNames insertObject:@"Date Created" atIndex:0];
    }
    if ([self.sectionNames containsObject:@"Date Revised"]) {
        [self.sectionNames removeObject:@"Date Revised"];
        [self.sectionNames insertObject:@"Date Revised" atIndex:1];
    }
    
	[self.navigationItem setTitle:[self.doc objectForKey:@"title"]];
    NSMutableArray *barButtons = [[NSMutableArray alloc] init];
    
    // If we need to show a checklist then prepare for one
    if (self.shouldDisplayChecklist) {
        
        UIBarButtonItem *checkButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"check-true.png"]
                                                                        style:UIBarButtonItemStylePlain
                                                                       target:self
                                                                       action:@selector(checkMarkTapped:)];
        
        [barButtons addObject:checkButton];
        self.checkListItems = [[NSMutableArray alloc] init];
        for (NSString *s in self.sectionNames) {
            
           // NSString *check = [[[self.data allKeysForObject:s] objectAtIndex:0] lowercaseString];
            NSString *check = [s lowercaseString];
            
            // Check for checklist section
            if ([check isEqualToString:@"checklist"] || [check isEqualToString:@"documentation checklist"]) {
                // 2 possible key combinations
                
                if ([self.doc objectForKey:@"documentationchecklist"]) {
                    [self.checkListItems addObjectsFromArray:self.doc[@"documentationchecklist"]];
                } else if ([self.doc objectForKey:@"checklist"]) {
                    [self.checkListItems addObjectsFromArray:self.doc[@"checklist"]];
                }
                break; 
            }
            
            // Check for minimum items required for documentation
            if ([check isEqualToString:@"minimum items required for documentation"]) {
                
                // 3 possible key combinations
                if ([self.doc objectForKey:@"minimumitemsrequiredfordocumenation"]) {
                    [self.checkListItems addObjectsFromArray:self.doc[@"minimumitemsrequiredfordocumentation"]];
                } else if ([self.doc objectForKey:@"documentationItems"]) {
                    [self.checkListItems addObjectsFromArray:self.doc[@"documentationItems"]];
                } else if ([self.doc objectForKey:@"documentationItems"]) {
                    [self.checkListItems addObjectsFromArray:self.doc[@"documentationItems"]]; 
                }
            }
        }
    }
    
    // Set the add button if the user is an admin
    if ([[PFUser currentUser] objectForKey:@"isAdmin"]) {
        self.isAdmin = YES;
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(showAddDialog)];
        [barButtons addObject:addButton];
    }
    
    if (barButtons.count > 0) {
        [self.navigationItem setRightBarButtonItems:barButtons animated:YES];
    }
}

// Convert the array of strings into a formatted string
- (NSString *)getDocumentString:(NSString *)key {
    NSMutableString *data = [[NSMutableString alloc] init];
    id object = [self.doc objectForKey:key];
    
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *ar = (NSArray *)object;
        for (int i = 0; i < ar.count; i++) {
            [data appendString:@"- "];
            [data appendString:ar[i]];
            
            if (i < ar.count -1) {
                [data appendFormat:@"\n"];
            }
        }
    } else if ([object isKindOfClass:[NSString class]]) {
        [data appendString:(NSString *)object];
    }
    
    
    return [[NSString alloc] initWithString:data];
}

// Calculate the height for the row based on the contents
- (CGFloat)getRowHeight:(NSString *)key {
    CGFloat height = 20.0f;
    CGSize max = CGSizeMake(self.view.frame.size.width, 800);
    CGRect rect;
    NSString *str = [[NSString alloc] init];
    
    str = [self getDocumentString:key]; 
    rect = [str boundingRectWithSize:max
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                             context:nil];
    height = rect.size.height;
    height += 45;
    
    return height;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sectionNames.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    // Get our custom cell
    AMDocumentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCell" forIndexPath:indexPath];
    

    // Get the data type we want to show and set that as the text for the row index
    NSArray *key = [self.data allKeysForObject:[self.sectionNames objectAtIndex:indexPath.section]];
    cell.textView.text = [self getDocumentString:[key objectAtIndex:0]];
    [cell.textView setTag:indexPath.section];
    
    // Admins can edit documents
    if (self.isAdmin) {
        cell.textView.editable = YES; 
    }
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return [self.sectionNames objectAtIndex:section];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   NSArray *key = [self.data allKeysForObject:[self.sectionNames objectAtIndex:indexPath.section]];
    return [self getRowHeight:[key objectAtIndex:0]];
    
}

// Delete the section
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Save to database
    NSArray *key = [self.data allKeysForObject:[self.sectionNames objectAtIndex:indexPath.section]];
    [self.data removeObjectForKey:[key objectAtIndex:0]];
    [self.sectionNames removeObjectAtIndex:indexPath.section];
    
    [self.doc removeObjectForKey:[key objectAtIndex:0]];
    self.doc[@"sections"] = self.data;
    [self.doc saveEventually];
    [self.tableView reloadData]; 
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Admins can only edit. Make sure there is more than one cell.
    if (self.isAdmin && self.data.count > 1) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - Buttons
- (void)checkMarkTapped:(id)sender {
    
    [self.delegate addChecklist:self.checkListItems forObject:self.doc[@"title"]];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)showAddDialog {
    
    // Setup the dialog
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"New Section" message:@"Name of new section" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    [alertView addButtonWithTitle:@"Add"];
    [alertView setDelegate:self];
    // Show the dialog
    [alertView show];
    
}

#pragma mark - UITextView Delegate
- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    
    // Save changes to database
    NSArray *key = [self.data allKeysForObject:[self.sectionNames objectAtIndex:textView.tag]];
    self.doc[[key objectAtIndex:0]] = textView.text;
    [self.doc saveEventually]; 
    
    return YES;
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    
    // Add a new section to the document type in the folder
    if (buttonIndex == 1) {
        UITextField *name = [alertView textFieldAtIndex:0];
        
        if (name.text.length > 0) {
            
            // Save a version of it without spaces as the key for this new data
            NSArray* words = [name.text componentsSeparatedByCharactersInSet :[NSCharacterSet whitespaceCharacterSet]];
            NSString* nospacestring = [words componentsJoinedByString:@""];
            
            // No duplicate section names
            if ([self.data objectForKey:nospacestring]) {
                
                // Setup the dialog
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                                    message:@"Name is already used. Please pick another name."
                                                                   delegate:nil cancelButtonTitle:@"Ok"
                                                          otherButtonTitles:nil];
                [alertView setDelegate:self];
                // Show the dialog
                [alertView show];
                
            } else {
            
                [self.sectionNames addObject:name.text];
    
                [self.data setObject:name.text forKey:[nospacestring lowercaseString]];
                
                // Add to the section type of the object. db column key : section name
                self.doc[@"sections"] = self.data;
                // Save to parse
                self.doc[[nospacestring lowercaseString]] = @"";
                [self.doc saveEventually];
                
                [self.tableView reloadData];
            }
        }
    }
}
@end
