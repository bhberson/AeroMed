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

@end

@implementation AMiPadChartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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

#pragma mark - chart methods

- (NSInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView{
    return 10; // number of bars in chart
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
