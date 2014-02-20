//
//  main.m
//  AeroMed
//
//  Created by Brody Berson on 1/10/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Pixate/Pixate.h>

#import "AppDelegate.h"

int main(int argc, char * argv[])
{
    @autoreleasepool {
        [Pixate licenseKey:@"Q7JS9-FNOML-SPNJ5-ISE0S-FO9SO-L692A-A480S-LKVON-8UDRP-6FM6R-TVJ1C-VDF5U-7A936-EBV74-M0D0L-42"forUser:@"torresmi@mail.gvsu.edu"];
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException * e) {
            NSLog(@"Exception: %@", e);
        }
    }
}
