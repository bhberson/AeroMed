//
//  AMiPadChartViewController.h
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JBBarChartView.h"

@interface AMChartViewController : UIViewController <JBBarChartViewDelegate, JBBarChartViewDataSource>
@property (weak, nonatomic) IBOutlet JBBarChartView *barChart;
@property (weak, nonatomic) IBOutlet UILabel *bottomText;
@property (weak, nonatomic) IBOutlet UILabel *titleText;


@end
