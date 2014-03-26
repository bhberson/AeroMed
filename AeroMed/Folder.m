//
//  Folder.m
//  AeroMed
//
//  Created by Michael Torres on 3/26/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "Folder.h"
#import <Parse/PFObject+Subclass.h>

@implementation Folder
@dynamic title; 

// Return the class name
+ (NSString *)parseClassName {
    return @"Folder";
}

- (Class)classForCoder
{
    return [self class]; // Instead of NSMutableDictionary
}

#pragma mark - NSCoding for offline use

-(void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.title forKey:@"title"];
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.title = [aDecoder decodeObjectForKey:@"title"];
    
    return self;
}

+ (NSString *)getPathToArchive {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentationDirectory, NSUserDomainMask, YES);
    
    NSString *docsDir = [paths objectAtIndex:0];
    return [docsDir stringByAppendingPathComponent:@"folder.model"];
}
@end
