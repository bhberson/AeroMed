//
//  OBImpression.m
//  AeroMed
//
//

#import "OBImpression.h"
#import <Parse/PFObject+Subclass.h>

@implementation OBImpression

// Use dynamic to tell compiler that the setter and getters are declared somewhere else
@dynamic title, originalDate, revisedDate, considerations, interventions, testsAndStudies,
medications, checklist, impressions, otherConsiderations;

// Return the class name
+ (NSString *)parseClassName {
    return @"OBImpression";
}

#pragma mark - NSCoding for offline use

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.originalDate forKey:@"originalDate"];
    [aCoder encodeObject:self.revisedDate forKey:@"revisedDate"];
    [aCoder encodeObject:self.considerations forKey:@"considerations"];
    [aCoder encodeObject:self.interventions forKey:@"interventions"];
    [aCoder encodeObject:self.testsAndStudies forKey:@"testAndStudies"];
    [aCoder encodeObject:self.medications forKey:@"medications"];
    [aCoder encodeObject:self.checklist forKey:@"checklist"];
    [aCoder encodeObject:self.impressions forKey:@"impressions"];
    [aCoder encodeObject:self.otherConsiderations forKey:@"other"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.title = [aDecoder decodeObjectForKey:@"title"];
    self.originalDate = [aDecoder decodeObjectForKey:@"originalDate"];
    self.revisedDate = [aDecoder decodeObjectForKey:@"revisedDate"];
    self.considerations = [aDecoder decodeObjectForKey:@"considerations"];
    self.interventions = [aDecoder decodeObjectForKey:@"interventions"];
    self.testsAndStudies = [aDecoder decodeObjectForKey:@"testAndStudies"];
    self.medications = [aDecoder decodeObjectForKey:@"medications"];
    self.checklist = [aDecoder decodeObjectForKey:@"checklist"];
    self.impressions = [aDecoder decodeObjectForKey:@"impressions"];
    self.otherConsiderations = [aDecoder decodeObjectForKey:@"other"];
    
    return self;
}

+ (NSString *)getPathToArchive {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [paths objectAtIndex:0];
    return [docsDir stringByAppendingPathComponent:@"obimpression.model"];
}
@end
