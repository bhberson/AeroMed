//
//  AMDocumentViewController.h
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.

#import <UIKit/UIKit.h>

// Pass the array back to the parent view controller
@protocol ChecklistProtocol <NSObject>
@required
- (void)addChecklist:(NSArray *)items forObject:(NSString *)obj;
@end

@interface AMDocumentViewController : UITableViewController <UITextViewDelegate, UIAlertViewDelegate>
@property (weak, atomic) PFObject *doc;
@property BOOL shouldDisplayChecklist;
@property (weak, nonatomic) id <ChecklistProtocol> delegate;
@end
