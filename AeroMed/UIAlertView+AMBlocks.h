//
//  UIAlertView+AMBlocks.h
//  AeroMed
//
//  Created by Michael Torres on 4/3/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (AMBlocks)
- (void)showWithCompletion:(void(^)(UIAlertView *alertView, NSInteger buttonIndex))completion;

@end
