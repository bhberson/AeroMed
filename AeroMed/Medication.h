//
//  Medication.h
//  AeroMed
//
//  Created on 3/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <Parse/Parse.h>

@interface Medication : PFObject <PFSubclassing>

// Medication name
@property (nonatomic, retain) NSString *name;

// Dates
@property (nonatomic, retain) NSString *originalDate;
@property (nonatomic, retain) NSString *revisedDate;

// Indications
@property (nonatomic, retain) NSArray *indications;

// Adult Dosage
@property (nonatomic, retain) NSArray *adultDosage;

// Pediatric Dosage
@property (nonatomic, retain) NSArray *pediatricDosage;

// Considerations
@property (nonatomic, retain) NSArray *considerations;

+ (NSString *)parseClassName;

@end
