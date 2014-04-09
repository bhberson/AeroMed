//
//  AMiPadChartViewController.m
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPadChartViewController.h"
#import "SWRevealViewController.h"

@interface AMiPadChartViewController ()
@property (strong, nonatomic) NSMutableArray *topFolders;
@property (strong, nonatomic) NSMutableArray *showingData;
@property (strong, nonatomic) NSMutableArray *checklistNames;
@property (strong, nonatomic) NSDate *checklistDate;
@property (strong, nonatomic) NSMutableArray *checklistData;

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
    self.barChart.delegate = self;
    self.barChart.dataSource = self;
    self.barChart.backgroundColor = [UIColor darkGrayColor];
    [self.barChart reloadData];
    
    // Set the status bar content to white in navigation bar
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
    // Menu button
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = sidebarButton;

    // Mock transport
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setLocale:[NSLocale currentLocale]];
    [dateFormat setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    self.checklistDate = [dateFormat dateFromString:@"2014/4/7"];

    // Mock checklist data
    [self.checklistData addObject:@{@"checked": [NSNumber numberWithBool:YES]}];
    [self.checklistData addObject:@{@"checked": [NSNumber numberWithBool:YES]}];
    [self.checklistData addObject:@{@"checked": [NSNumber numberWithBool:YES]}];
    [self.checklistData addObject:@{@"checked": [NSNumber numberWithBool:NO]}];
    [self.checklistData addObject:@{@"checked": [NSNumber numberWithBool:YES]}];
    
    [self.checklistNames addObject:@"Item1"];
    [self.checklistNames addObject:@"Item2"];
    [self.checklistNames addObject:@"Item3"];
    [self.checklistNames addObject:@"Item4"];
    [self.checklistNames addObject:@"Item5"];

    [self isDateWithinMonth:self.checklistDate];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.barChart setState:JBChartViewStateExpanded animated:YES callback:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.barChart setState:JBChartViewStateCollapsed];
    
    NSString *email = [[PFUser currentUser] email];
    NSMutableString *title = [[NSMutableString alloc] init];
    [title appendString:[email substringToIndex:[email rangeOfString:@"@"].location]];
    [title appendString:@"'s Performance"];
    self.titleText.text = title;
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (bool)isDateWithinMonth:(NSDate *)date {
    NSDate *now = [[NSDate alloc] init];

    // Get the system calendar
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];

    NSDateComponents *breakdownInfo = [sysCalendar components:NSDayCalendarUnit
                                                     fromDate:date
                                                       toDate:now
                                                      options:0];

    return ([breakdownInfo day] < 31) ? YES : NO;
}

#pragma mark - chart methods

- (NSInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView{
    return 30; // number of bars in chart
}

- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtAtIndex:(NSInteger)index {
    return index; // height of bar at index
}

- (void)barChartView:(JBBarChartView *)barChartView didSelectBarAtIndex:(NSUInteger)index touchPoint:(CGPoint)touchPoint
{
    // Update view
    self.bottomText.text = @"Oh Fancy";
    self.bottomText.hidden = NO;
    
}

- (void)didUnselectBarChartView:(JBBarChartView *)barChartView
{
    // Update view
    self.bottomText.hidden = YES;
}

- (UIColor *)barSelectionColorForBarChartView:(JBBarChartView *)barChartView
{
    return [UIColor whiteColor]; // color of selection view
}


- (UIView *)barChartView:(JBBarChartView *)barChartView barViewAtIndex:(NSUInteger)index
{
    UIView *barView = [[UIView alloc] init];
    barView.backgroundColor = (index % 2 == 0) ? [UIColor colorWithRed:0.200 green:0.749 blue:1.000 alpha:1.000]: [UIColor greenColor];
    return barView;
}
@end
