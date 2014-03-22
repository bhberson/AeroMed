//
//  Medication.m
//  AeroMed
//
//  Created on 3/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "Medication.h"
#import <Parse/PFObject+Subclass.h>

@implementation Medication

// Use dynamic to tell compiler that the setter and getters are declared somewhere else
@dynamic name, originalDate, revisedDate, indications, adultDosage, pediatricDosage, considerations;

// Return the class name
+ (NSString *)parseClassName {
    return @"Medication";
}

#pragma mark - NSCoding for offline use

-(void)encodeWithCoder:(NSCoder *)aCoder {
   
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    

    
    return self;
}

+ (NSString *)getPathToArchive {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [paths objectAtIndex:0];
    return [docsDir stringByAppendingPathComponent:@"medications.model"];
}
@end
