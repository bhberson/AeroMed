//
//  OBImpression.h
//  AeroMed
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface OBImpression : PFObject <PFSubclassing, NSCoding>

// Title
@property (nonatomic, retain) NSString *title;

// Dates
@property (nonatomic, retain) NSString *originalDate;
@property (nonatomic, retain) NSString *revisedDate;

// Transport considerations
@property (nonatomic, retain) NSArray *considerations;

// Critical Interventions
@property (nonatomic, retain) NSArray *interventions;

// Pertinent Labs, Tests & Studies
@property (nonatomic, retain) NSArray *testsAndStudies;

// Medications
@property (nonatomic, retain) NSArray *medications;

// Checklist
@property (nonatomic, retain) NSArray *checklist;

// Suggested Impressions
@property (nonatomic, retain) NSArray *impressions;

// Other Considerations
@property (nonatomic, retain) NSArray *otherConsiderations;

+ (NSString *)parseClassName;
+ (NSString *)getPathToArchive;
@end
