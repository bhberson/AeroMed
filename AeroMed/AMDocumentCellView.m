//
//  AMDocumentCellView.m
//  AeroMed
//
//  Created by Michael Torres on 3/26/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMDocumentCellView.h"

@implementation AMDocumentCellView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.176 green:0.690 blue:1.000 alpha:1.000];
        self.headerLabel.adjustsFontSizeToFitWidth = YES;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
