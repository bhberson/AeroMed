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
@property (strong, nonatomic) PFObject *selectedObject;

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
    
    NSMutableString *title = [[NSMutableString alloc] init];
    [title appendString:@"Recent Transport Performance"];
    self.titleText.text = title;
    
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
    index = abs(index - (self.daysBack - 1));
    
    // Update view
    NSMutableString *label = [[NSMutableString alloc] init];
    if (index == 0) {
        [label appendString:@"Today - "];
    }
    else if (index == 1) {
        [label appendString:@"Yesterday - "];
    }
    else if (index < self.allTransports.count) {
        [label appendFormat:@"%d", index];
        [label appendString:@" days ago - "];
    } else {
        [label appendString:@"No transports "];
        [label appendFormat:@"%d", index];
        [label appendString:@" days ago"];
    }

    if (index < self.allTransports.count) {
        [label appendFormat:@"%0.2f%%", [self barValueAtIndex:index] * 100];

        [self.textButton setTitle:label forState:UIControlStateNormal];
        self.textButton.hidden = NO;
    
        self.selectedChecklist = [self.checklistData objectAtIndex:index];
        self.selectedObject = [self.allTransports objectAtIndex:index];
    }
    
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
    
    return 0;
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
    PFQuery *query = [PFQuery queryWithClassName:@"Transport"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
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
    [self setupCheckList:self.allTransports];
    
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
                if (![self.checklistData objectAtIndex:daysAway]) {
                    NSMutableArray *oldData = [self.checklistData objectAtIndex:daysAway];
                    NSMutableArray *newData = transport[@"checklist"];
                    [newData addObjectsFromArray:oldData];
                    [self.checklistData replaceObjectAtIndex:daysAway withObject:newData];
                } else {
                    [self.checklistData replaceObjectAtIndex:daysAway withObject:transport[@"checklist"]];
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
        
        // Select a crew member
    } else {
        
        if (self.allUsers == nil) {
            [self getUsers];
        }
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
    
    // We want to show the items
    if (isHidden) {
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

    self.allUsers = [[NSMutableArray alloc] init];
    for (PFObject *obj in self.allTransports) {
        NSMutableArray *crewMembers = [obj objectForKey:@"CrewMembers"];
        
        for (NSString *member in crewMembers) {
            
            if (![self.allUsers containsObject:member] && ![member isEqualToString:@""]) {
                [self.allUsers addObject:member];
            }
        }
    }
    self.selectedUser = [self.allUsers objectAtIndex:0]; 
    [self.userPicker reloadAllComponents]; 

    
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
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"detailTransport"]) {
        AMCheckListTableViewController *vc = (AMCheckListTableViewController *)segue.destinationViewController;
        [vc setCompletedChecklist:self.selectedChecklist];
        [vc setIsDisplayingCompletedList:YES];
        [vc setTransportData:self.selectedObject]; 
    }
}

@end
