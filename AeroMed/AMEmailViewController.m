//
//  AMEmailViewController.m
//  AeroMed
//
//  Created by Mario Galeno on 4/7/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMEmailViewController.h"
#import "SWRevealViewController.h"


@interface AMEmailViewController ()

@end

@implementation AMEmailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    // Menu button
    UIBarButtonItem *sidebarButton = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    self.navigationItem.leftBarButtonItem = sidebarButton;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
    
    [self.recipientText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5]CGColor]];
    [self.recipientText.layer setBorderWidth:2.0];
    self.recipientText.layer.cornerRadius = 5;
    self.recipientText.clipsToBounds = YES;
    
    [self.subjectText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5]CGColor]];
    [self.subjectText.layer setBorderWidth:2.0];
    self.subjectText.layer.cornerRadius = 5;
    self.subjectText.clipsToBounds = YES;
    
    [self.bodyText.layer setBorderColor:[[[UIColor grayColor] colorWithAlphaComponent:0.5] CGColor]];
    [self.bodyText.layer setBorderWidth:2.0];
    self.bodyText.layer.cornerRadius = 5;
    self.bodyText.clipsToBounds = YES;
    
}

- (IBAction)openMail:(id)sender {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        
        mailer.mailComposeDelegate = self;
        
        [mailer setToRecipients: [NSArray arrayWithObject: self.recipientText.text]];
        [mailer setSubject: self.subjectText.text];
        [mailer setMessageBody: self.bodyText.text isHTML:NO];
        
        [self presentViewController:mailer animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support emails"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) dismissKeyboard{
    [self.recipientText resignFirstResponder];
    [self.subjectText resignFirstResponder];
    [self.bodyText resignFirstResponder];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
