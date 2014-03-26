//
//  Folder.h
//  AeroMed
//
//  Created by Michael Torres on 3/26/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Folder : PFObject <PFSubclassing>
// Title
@property (nonatomic, retain) NSString *title;

+ (NSString *)parseClassName;
+ (NSString *)getPathToArchive;
@end
