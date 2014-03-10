//
//  AMDocumentViewController.h
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.

#import <UIKit/UIKit.h>

@interface AMDocumentViewController : UIViewController <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSDictionary* info;
@end
