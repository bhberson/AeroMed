//
//  AMiPadChartViewController.m
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMChartViewController.h"
#import "SWRevealViewController.h"
#import "AMCheckListTableViewController.h"


#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface AMChartViewController ()
@property (strong, nonatomic) NSMutableArray *allTransports;
@property (strong, nonatomic) NSString *selectedUser;
@property (strong, nonatomic) NSMutableArray *checklistData;
@property int daysBack;
@property (strong, nonatomic) NSMutableArray *allUsers;

@property (strong, nonatomic) NSDictionary *selectedChecklist;
@property (strong, nonatomic) NSMutableDictionary *validTransports;
@property int selectedDay;

@end

@implementation AMChartViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self hideShowPickerView];
    
  
    self.textButton.hidden = YES;
    self.barChart.delegate = self;
    self.barChart.dataSource = self;
    self.barChart.backgroundColor = [UIColor darkGrayColor];
    
    // Set the status bar content to white in navigation bar
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Menu button
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = sidebarButton;
    
    if (IPAD) {
        self.daysBack = 30;
    } else {
        self.daysBack = 15;
    }
    
    
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.barChart setState:JBChartViewStateCollapsed];
    [self.titleText adjustsFontSizeToFitWidth]; 
    if (![[PFUser currentUser] objectForKey:@"isAdmin"]) {
        self.titleText.text = [NSString stringWithFormat:@"%@'s Transport Performance", [[PFUser currentUser] objectForKey:@"username"]]; 
    } else {
        self.titleText.text = @"Recent Transport Performance";
        self.segmentedControl.selectedSegmentIndex = 0;
    }
    
    [self retrieveTransports];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (int)daysSinceDate:(NSDate *)date {
    NSDate *now = [[NSDate alloc] init];
    
    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    
    NSDateComponents *breakdown = [sysCalendar components:NSDayCalendarUnit
                                                 fromDate:date
                                                   toDate:now
                                                  options:0];
    
    return [breakdown day];
}

#pragma mark - chart methods

- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView {
    
    return self.daysBack; // number of bars in chart
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index {
    // flip the index around
    index = abs(index - (self.daysBack - 1));

    return [self barValueAtIndex:index];
}

- (NSUInteger)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return 2;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
    // flip the index around
    int rindex = abs(index - (self.daysBack - 1));
    self.selectedDay = rindex;
    // Update view
    NSMutableString *label = [[NSMutableString alloc] init];
    if (rindex == 0) {
        [label appendString:@"Today - "];
    }
    else if (rindex == 1) {
        [label appendString:@"Yesterday - "];
    } else {
        [label appendFormat:@"%d", rindex];
        [label appendString:@" days ago - "];
    }
    
    // Basically, if we are on a bar with a value from transports
    if ([self.validTransports objectForKey:[NSNumber numberWithInt:rindex]]) {
        self.selectedChecklist = [self.checklistData objectAtIndex:rindex];
        self.textButton.enabled = YES;
        [label appendFormat:@"%0.2f%%", [self barValueAtIndex:rindex] * 100];
    } else {
        [label appendString:@"None "];
        self.textButton.enabled = NO;
    }
    
    
    [self.textButton setTitle:label forState:UIControlStateNormal];
    [self.textButton setTitle:label forState:UIControlStateDisabled];
    self.textButton.hidden = NO;
    
}

- (float)barValueAtIndex:(NSUInteger)index {
    
    // If the index contains a dictionary
    if ([[self.checklistData objectAtIndex:index] isKindOfClass:[NSMutableDictionary class]]) {
        NSDictionary *data = [self.checklistData objectAtIndex:index];
        float total = [data count];
        float yes = 0;
      
        for (NSNumber *value in [data allValues]) {
            
            if([value boolValue])
                yes++; // increase total number of checked checklist items
        }
        
        if(total > 0) {
            return yes / total; // height of bar at index
        }
    }
    
    return 0.05;
}

- (void)didUnselectBarChartView:(JBBarChartView *)barChartView
{

}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor]; // color of selection view
}


- (UIView *)barChartView:(JBBarChartView *)barChartView barViewAtIndex:(NSUInteger)index
{
    UIView *barView = [[UIView alloc] init];
    barView.backgroundColor = (index % 2 == 0) ? [UIColor colorWithRed:0.285f green:0.781f blue:0.98f alpha:1.0f]:
                                                    [UIColor colorWithRed:0.0f green:0.625f blue:0.722f alpha:1.0f];
    return barView;
}

- (void)retrieveTransports
{
    self.checklistData = [[NSMutableArray alloc] init];
    self.validTransports = [[NSMutableDictionary alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Transport"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query orderByDescending:@"createdAt"];
    [query setLimit: 100];
    

    __weak AMChartViewController *weakClass = self;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            [weakClass setUpTransports:objects];
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}



- (void)setUpTransports:(NSArray *)objects {
    
    // First create all transports. Then setup the checklist data for all transports 
    self.allTransports = [[NSMutableArray alloc] initWithArray:objects];
    
    // If we are not an admin then only show user's transports 
    if (![[PFUser currentUser] objectForKey:@"isAdmin"]) {
        self.selectedUser = [[PFUser currentUser] objectForKey:@"username"];
        // Filtered transports
        NSMutableArray *userTransports = [[NSMutableArray alloc] init];
        for (PFObject *obj in self.allTransports) {
            NSArray *crew = obj[@"CrewMembers"];
            
            if ([crew containsObject:self.selectedUser]) {
                [userTransports addObject:obj];
            }
            
        }
        [self setupCheckList:userTransports];
        
    // Show all recent transports
    } else {
        [self setupCheckList:self.allTransports];
        [self getUsers];
    }
    
}

- (void)setupCheckList:(NSArray *)transports {
    int daysAway = 0;
    
    // Initialize the checklist data
    self.checklistData = [[NSMutableArray alloc] initWithCapacity:self.daysBack];
    for (int i = 0; i < self.daysBack; i++) {
        [self.checklistData addObject:[NSNumber numberWithInt:0]];
    }
    
    // Iterate through the transports and get the days away
    for (PFObject *transport in transports) {
        daysAway = [self daysSinceDate:[transport createdAt]];
        
        // If it is in our graph range then add the checklist results to that day index
        if (daysAway < 30) {
            
            // If a checklist is set for that transport. It should be, but users be users.
            if (transport[@"checklist"]) {
                
                // If we have more than one transport in a day then we need to add to the list
                if ([[self.checklistData objectAtIndex:daysAway] isKindOfClass:[NSMutableDictionary class]]) {
                    NSMutableDictionary *oldData = [self.checklistData objectAtIndex:daysAway];
                    NSMutableDictionary *newData = transport[@"checklist"];
                    [newData addEntriesFromDictionary:oldData];
                    [self.checklistData replaceObjectAtIndex:daysAway withObject:newData];
                    
                    // We have multiple valid transports for that day, so add them to the array
                    NSMutableArray *oldtransports = [self.validTransports objectForKey:[NSNumber numberWithInt:daysAway]];
                    [oldtransports addObject:transport];
                    [self.validTransports setObject:oldtransports forKey:[NSNumber numberWithInt:daysAway]];
                } else {
                    [self.checklistData replaceObjectAtIndex:daysAway withObject:transport[@"checklist"]];
                    
                    // Add this to the valid transports dictionary with the day as the key
                    NSMutableArray *transp = [[NSMutableArray alloc] initWithObjects:transport, nil];
                    [self.validTransports setObject:transp forKey:[NSNumber numberWithInt:daysAway]];
                }
            }
        }
    }
    
    [self.barChart reloadData];
    [self.barChart setState:JBChartViewStateCollapsed];
    [self.barChart setState:JBChartViewStateExpanded animated:YES];
}

- (IBAction)segmentChanged:(id)sender {
    
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        [self setupCheckList:self.allTransports];
        self.titleText.text = @"Recent Transport Performance";
        // Select a crew member
    } else {
        self.titleText.text = [NSString stringWithFormat:@"%@'s Transport Performance", self.selectedUser];
        [self hideShowPickerView];
    }
}

- (IBAction)showDetails:(id)sender {
    [self performSegueWithIdentifier:@"detailTransport" sender:self]; 
}

- (IBAction)doneTapped:(id)sender {
    [self hideShowPickerView];
    
    // Filtered transports
    NSMutableArray *userTransports = [[NSMutableArray alloc] init];
    for (PFObject *obj in self.allTransports) {
        NSArray *crew = obj[@"CrewMembers"];
        
        if ([crew containsObject:self.selectedUser]) {
            [userTransports addObject:obj];
        }
        
    }
    [self setupCheckList:userTransports];
    
    
}

- (void)hideShowPickerView {
    BOOL isHidden = self.userPicker.hidden;
    
    // Only admins can select users
    if (![[PFUser currentUser] objectForKey:@"isAdmin"]) {
        self.segmentedControl.hidden = YES;
        self.userPicker.hidden = YES;
        self.toolBar.hidden = YES;
        
    } else if (isHidden) {
        self.userPicker.hidden = NO;
        self.toolBar.hidden = NO;
        self.segmentedControl.hidden = YES;
        self.textButton.hidden = YES;
    } else {
        self.userPicker.hidden = YES;
        self.toolBar.hidden = YES;
        self.segmentedControl.hidden = NO;
        self.textButton.hidden = NO;
    }
}

// Query for all users
- (void) getUsers {

    if (self.allTransports != nil) {
        self.allUsers = [[NSMutableArray alloc] init];
        for (PFObject *obj in self.allTransports) {
            NSMutableArray *crewMembers = [obj objectForKey:@"CrewMembers"];
            
            for (NSString *member in crewMembers) {
                
                if (![self.allUsers containsObject:member] && ![member isEqualToString:@""]) {
                    [self.allUsers addObject:member];
                }
            }
        }
        
        if (self.allUsers.count > 0) {
            self.selectedUser = [self.allUsers objectAtIndex:0];
        }
        [self.userPicker reloadAllComponents];
    }

    
}

#pragma mark - UIPicker Delegate methods
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.allUsers count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
   
    return [self.allUsers objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectedUser = [self.allUsers objectAtIndex:row];
    self.titleText.text = [NSString stringWithFormat:@"%@'s Transport Performance", self.selectedUser];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailTransport"]) {
        AMCheckListTableViewController *vc = (AMCheckListTableViewController *)segue.destinationViewController;
        [vc setCompletedChecklist:self.selectedChecklist];
        [vc setIsDisplayingCompletedList:YES];
        [vc setAssociatedTransports:[self.validTransports objectForKey:[NSNumber numberWithInt:self.selectedDay]]];
    }
}

@end
