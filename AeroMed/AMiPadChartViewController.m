//
//  AMiPadChartViewController.m
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPadChartViewController.h"
#import "SWRevealViewController.h"

static int const daysBack = 30; // must be 1 or greater

@interface AMiPadChartViewController ()
@property (strong, nonatomic) NSMutableArray *allTransports;
@property (strong, nonatomic) NSMutableArray *showingData;
@property (strong, nonatomic) NSMutableArray *checklistData;
@property (strong, nonatomic) NSMutableArray *graphData;
@property (strong, nonatomic) NSMutableArray *graphData2;
@property BOOL shouldSetData;
@end

@implementation AMiPadChartViewController

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
    // Do any additional setup after loading the view.
    
    self.bottomText.hidden = YES;
    //self.barChart.frame = CGRectMake(<#CGFloat x#>, <#CGFloat y#>, <#CGFloat width#>, <#CGFloat height#>);/*CGRectMake(kJBBarChartViewControllerChartPadding, kJBBarChartViewControllerChartPadding, self.view.bounds.size.width - (kJBBarChartViewControllerChartPadding * 2), kJBBarChartViewControllerChartHeight); */
    self.barChart.delegate = self;
    self.barChart.dataSource = self;
    self.barChart.backgroundColor = [UIColor darkGrayColor];
    //[self.barChart reloadData];
    
    // Set the status bar content to white in navigation bar
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Menu button
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = sidebarButton;
    
    // Initialize graph data array
    self.graphData = [[NSMutableArray alloc] initWithCapacity:daysBack];

    // Add empty cells for index insertion
    for (int i = 0; i < daysBack; i++) {
        int items = arc4random() % 6 + 1;
        NSMutableArray *randList = [[NSMutableArray alloc] init];
    
        for(int i = 0; i < items; i++) {
            BOOL b;
            int r = arc4random() % 10;
            b = (r < 7) ? YES : NO;
            [randList addObject:@{@"checked": [NSNumber numberWithBool:b]}];
        }
    
        [self.graphData addObject:randList];
    }
    
    // Mock transport
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    
    NSDate *checklistDate = [[NSDate alloc] init];
    //NSMutableArray *checklistNames = [[NSMutableArray alloc] init];
    
    
    checklistDate = [dateFormat dateFromString:@"2014/4/7"];

    // will be another loop to add to graph data
    //[self.graphData insertObject:self.checklistData atIndex:[self daysSinceDate:checklistDate]];
    
    /*
     [self.checklistNames addObject:@"Item1"];
     [self.checklistNames addObject:@"Item2"];
     [self.checklistNames addObject:@"Item3"];
     [self.checklistNames addObject:@"Item4"];
     [self.checklistNames addObject:@"Item5"];
     */
    self.graphData2 = [[NSMutableArray alloc] initWithCapacity:daysBack]; 
    for (int i = 0; i < daysBack; i++) {
        [self.graphData2 addObject:[NSNull null]];
    }
    
   
    
  //  [self.barChart reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    //[self.barChart setState:JBChartViewStateExpanded animated:YES callback:nil];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.barChart setState:JBChartViewStateCollapsed];
    
    //NSString *email = [[PFUser currentUser] email];
    NSMutableString *title = [[NSMutableString alloc] init];
    // [title appendString:[email substringToIndex:[email rangeOfString:@"@"].location]];
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
    
    // If this is set we have the data and we need to instantiate it in the array
    if (self.shouldSetData) {
        
        // Iterate through the transports and get the days away
        for (PFObject *transport in self.allTransports) {
            int daysAway = [self daysSinceDate:[transport createdAt]];
            
            // If it is in our graph range then add the checklist results to that day index
            if (daysAway < 30) {
                
                // If a checklist is set for that transport. It should be, but users be users.
                if (transport[@"checklist"]) {
                    
                    // If we have more than one transport in a day then we need to add to the list
                    if (![self.graphData2 objectAtIndex:daysAway]) {
                        NSArray *oldData = [self.graphData2 objectAtIndex:daysAway];
                        NSMutableArray *newData = transport[@"checklist"];
                        [newData addObjectsFromArray:oldData];
                        [self.graphData2 replaceObjectAtIndex:daysAway withObject:newData]; 
                    } else {
                        [self.graphData2 replaceObjectAtIndex:daysAway withObject:transport[@"checklist"]];
                    }
                }
            }
        }
        
        self.shouldSetData = NO; 
        
    }
    
    return daysBack; // number of bars in chart
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSUInteger)index {
    // flip the index around
    index = abs(index - (daysBack - 1));

    return [self barValueAtIndex:index];
}

- (NSUInteger)barPaddingForBarChartView:(JBBarChartView *)barChartView
{
    return 2;
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
    // flip the index around
    index = abs(index - (daysBack - 1));
    
    // Update view
    NSMutableString *label = [[NSMutableString alloc] init];
    if (index == 0) {
        [label appendString:@"Today - "];
    }
    else if (index == 1) {
        [label appendString:@"Yesterday - "];
    }
    else {
        [label appendFormat:@"%d", index];
        [label appendString:@" days ago - "];
    }

    [label appendFormat:@"%0.2f%%", [self barValueAtIndex:index] * 100];

    self.bottomText.text = label;
    self.bottomText.hidden = NO;
    
}

- (float)barValueAtIndex:(NSUInteger)index {
    // get checklist statistic array at index
    NSMutableArray *listArray;
    @try {
        listArray = [self.graphData objectAtIndex:index];
    } @catch (NSException *e) {
        NSLog(@"%@", e);
    }
    int total = 0;
    int yes = 0;
    
    for (NSDictionary *d in listArray) {
        total++; // increase total number of checklist items
        
        if([[d objectForKey:@"checked"] boolValue])
            yes++; // increase total number of checked checklist items
    }
    
    if(total > 0) {
        return (float)yes / (float)total; // height of bar at index
    }

    return 0;
}

- (void)didUnselectBarChartView:(JBBarChartView *)barChartView
{
    // Update view
    // self.bottomText.hidden = YES;
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor]; // color of selection view
}


- (UIView *)barChartView:(JBBarChartView *)barChartView barViewAtIndex:(NSUInteger)index
{
    UIView *barView = [[UIView alloc] init];
    barView.backgroundColor = (index % 2 == 0) ? [UIColor colorWithRed:0.285f green:0.781f blue:0.98f alpha:1.0f]: [UIColor colorWithRed:0.0f green:0.625f blue:0.722f alpha:1.0f];
    return barView;
}

- (void)retrieveTransports
{
    self.checklistData = [[NSMutableArray alloc] init];
    PFQuery *query = [PFQuery queryWithClassName:@"Transport"];
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [query setLimit: 100];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded. Add the returned objects to allObjects
            self.allTransports = [[NSMutableArray alloc] initWithArray:objects];
            self.shouldSetData= YES;
            
            [self.barChart reloadData];
            [self.barChart setState:JBChartViewStateCollapsed];
            [self.barChart setState:JBChartViewStateExpanded animated:YES callback:nil];
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}
@end
