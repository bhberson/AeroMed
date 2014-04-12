//
//  AMiPadChartViewController.m
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMChartViewController.h"
#import "SWRevealViewController.h"

#define IPAD UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad

@interface AMChartViewController ()
@property (strong, nonatomic) NSMutableArray *allTransports;
@property (strong, nonatomic) NSMutableArray *checklistData;
@property int daysBack;
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
  
    self.bottomText.hidden = YES;
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
    else {
        [label appendFormat:@"%d", index];
        [label appendString:@" days ago - "];
    }

    [label appendFormat:@"%0.2f%%", [self barValueAtIndex:index] * 100];

    self.bottomText.text = label;
    self.bottomText.hidden = NO;
    
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
    
    // Initialize the checklist data
    self.checklistData = [[NSMutableArray alloc] initWithCapacity:self.daysBack];
    for (int i = 0; i < self.daysBack; i++) {
        [self.checklistData addObject:[NSNumber numberWithInt:0]];
    }
    
    __block int daysAway;
    __block NSArray *oldData;
    __block NSMutableArray *newData;
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            
            // The find succeeded. Add the returned objects to allObjects
            self.allTransports = [[NSMutableArray alloc] initWithArray:objects];
            //self.shouldSetData= YES;
            
            // Iterate through the transports and get the days away
            for (PFObject *transport in self.allTransports) {
                 daysAway = [self daysSinceDate:[transport createdAt]];
    
                // If it is in our graph range then add the checklist results to that day index
                if (daysAway < 30) {
    
                    // If a checklist is set for that transport. It should be, but users be users.
                    if (transport[@"checklist"]) {
    
                        // If we have more than one transport in a day then we need to add to the list
                        if (![self.checklistData objectAtIndex:daysAway]) {
                            oldData = [self.checklistData objectAtIndex:daysAway];
                            newData = transport[@"checklist"];
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
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}
@end
