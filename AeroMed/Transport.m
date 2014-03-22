//
//  Transport.m
//
//
//
//

#import "Transport.h"

@implementation Transport




- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

#pragma mark - NSCoding for offline use

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.transportNumber forKey:@"transportNumber"];
    [aCoder encodeObject:self.transportType forKey:@"transportType"];
    [aCoder encodeObject:self.crewMembers forKey:@"crewMembers"];
    [aCoder encodeObject:self.ageGroup forKey:@"ageGroup"];
    [aCoder encodeObject:self.otherNotes forKey:@"otherNotes"];
    [aCoder encodeObject:self.specialTransport forKey:@"specialTransport"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.transportNumber = [aDecoder decodeObjectForKey:@"transportNumber"];
    self.transportType = [aDecoder decodeObjectForKey:@"transportType"];
    self.crewMembers = [aDecoder decodeObjectForKey:@"crewMembers"];
    self.ageGroup = [aDecoder decodeObjectForKey:@"ageGroup"];
    self.otherNotes = [aDecoder decodeObjectForKey:@"otherNotes"];
    self.specialTransport = [aDecoder decodeObjectForKey:@"specialTransport"];
    
    return self;
}

+ (NSString *)getPathToArchive {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [paths objectAtIndex:0];
    return [docsDir stringByAppendingPathComponent:@"transport.model"];
}
@end
