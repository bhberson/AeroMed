//
//  AMiPadChartViewController.h
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBBarChartView.h"

@interface AMChartViewController : UIViewController <JBBarChartViewDelegate, JBBarChartViewDataSource,
UIPickerViewDataSource, UIPickerViewDelegate, UIToolbarDelegate>
@property (weak, nonatomic) IBOutlet JBBarChartView *barChart;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UIPickerView *userPicker;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;
@property (weak, nonatomic) IBOutlet UIButton *textButton;

- (IBAction)segmentChanged:(id)sender;

- (IBAction)showDetails:(id)sender;

- (IBAction)doneTapped:(id)sender;
- (void)setUpTransports:(NSArray *)objects; 
@end
