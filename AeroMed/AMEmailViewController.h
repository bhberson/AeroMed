//
//  AMEmailViewController.h
//  AeroMed
//
//  Created by Mario Galeno on 4/7/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface AMEmailViewController : UIViewController <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UITextField *recipientText;
@property (strong, nonatomic) IBOutlet UITextField *subjectText;
@property (strong, nonatomic) IBOutlet UITextView *bodyText;

- (IBAction)openMail:(id)sender;
- (void) dismissKeyboard;

@end
