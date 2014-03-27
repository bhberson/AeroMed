//
//  AMChartViewController.h
//  AeroMed
//
//  Created by Michael Torres on 3/22/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBBarChartView.h"


@interface AMiPHoneChartViewController : UIViewController <JBBarChartViewDelegate, JBBarChartViewDataSource>
@property (weak, nonatomic) IBOutlet JBBarChartView *barChart;
@property (weak, nonatomic) IBOutlet UILabel *bottomText;
@property (weak, nonatomic) IBOutlet UILabel *titleText;
@property (weak, nonatomic) IBOutlet UILabel *rightText;
@property (weak, nonatomic) IBOutlet UILabel *leftText;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;

@end
