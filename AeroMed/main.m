//
//  main.m
//  AeroMed
//
//  Created by Brody Berson on 1/10/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "AppDelegate.h"
#import <PixateFreestyle/PixateFreestyle.h>

int main(int argc, char * argv[])
{
    @autoreleasepool {
        [PixateFreestyle initializePixateFreestyle];
       
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
    }
}
