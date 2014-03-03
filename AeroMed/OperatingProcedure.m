//
//  OperatingProcedure.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "OperatingProcedure.h"
#import <Parse/PFObject+Subclass.h>

@implementation OperatingProcedure

// Use dynamic to tell compiler that the setter and getters are declared somewhere else
@dynamic title, originalDate, revisedDate, considerations, interventions, testsAndStudies,
medications, checklist, impressions, otherConsiderations;

// Return the class name
+ (NSString *)parseClassName {
    return @"OperatingProcedure";
}


@end
