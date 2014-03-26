//
//  AMDecorationView.m
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMDecorationView.h"

@implementation AMDecorationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%@", NSStringFromCGRect(frame));
        UIImage *backgroundImage = [UIImage imageNamed:@"helicopter.jpg"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = backgroundImage;
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self addSubview:imageView];
    }
    return self;
}



@end
