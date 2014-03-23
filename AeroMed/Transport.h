//
//  Transport.h
//
//
//
//

#import <Foundation/Foundation.h>

@interface Transport : NSObject <NSCoding>

@property (nonatomic, strong) NSString *transportNumber;
@property (nonatomic, strong) NSString *transportType;
@property (nonatomic, strong) NSArray *crewMembers;
@property (nonatomic, strong) NSString *ageGroup;
@property (nonatomic, strong) NSString *otherNotes;
@property (nonatomic, strong) NSString *specialTransport;
@property (nonatomic, strong) NSDictionary *checkListResults;
@property (nonatomic, strong) NSDate *dateStarted; 
+ (NSString *)getPathToArchive;
@end
