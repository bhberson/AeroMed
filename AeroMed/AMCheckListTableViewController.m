//
//  AMCheckListTableViewController.m
//  AeroMed
//
//  Created by Michael Torres on 3/16/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMCheckListTableViewController.h"
#import "AMBaseViewController.h"

@interface AMCheckListTableViewController ()
@property NSMutableArray *dataArray;
@property NSMutableArray *allUsers;
@end

@implementation AMCheckListTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    

    // If we are just displaying a list then modify a little
    if (self.isDisplayingCompletedList) {
        UIBarButtonItem *mail = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showMail)];
        self.navigationItem.rightBarButtonItem = mail;
        [self queryForUsers];
    } else {
    
        UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneTapped:)];
        self.navigationItem.rightBarButtonItem = done;
    }

    
    NSLog(@"%@",self.checkList);
 
    self.dataArray = [[NSMutableArray alloc] initWithCapacity:self.checkList.count];
    
    // Initialize our data array to hold a dictionary to hold cell data and checkmark data
    for (NSArray *items in self.checkList) {
        
        // Create a dictionary that determines if it is checked or not
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithCapacity:2];
        [dataDic setObject:[NSNumber numberWithBool:NO] forKey:@"checked"];
        [self.dataArray addObject:dataDic];

    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    
    if (self.isDisplayingCompletedList) {
        return [self.completedChecklist count];
    } else {
        return [self.checkList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkCell" forIndexPath:indexPath];
    
    // Configure the cell...
    if (self.isDisplayingCompletedList) {
        NSString *item = [[self.completedChecklist allKeys] objectAtIndex:indexPath.row];
        cell.textLabel.text = item;
        BOOL checked = [[self.completedChecklist objectForKey:item] boolValue];
        
        UIImage *img = (checked) ? [UIImage imageNamed:@"check-yes"] : [UIImage imageNamed:@"check-no"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        button.frame = frame;
        [button setBackgroundImage:img forState:UIControlStateNormal];
        cell.accessoryView = button;
    } else {
        cell.textLabel.text =[self.checkList objectAtIndex:indexPath.row];
      
        NSMutableDictionary *item = [self.dataArray objectAtIndex:indexPath.row];
        
        BOOL checked = [[item objectForKey:@"checked"] boolValue];
        
        UIImage *img = (checked) ? [UIImage imageNamed:@"check-yes"] : [UIImage imageNamed:@"check-no"];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGRect frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        button.frame = frame;
        [button setBackgroundImage:img forState:UIControlStateNormal];
        [button addTarget:self action:@selector(checkMarkTapped:withEvent:) forControlEvents:UIControlEventTouchUpInside];
        button.backgroundColor = [UIColor clearColor];
        cell.accessoryView = button;
         
        [item setObject:cell forKey:@"cell"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!self.isDisplayingCompletedList) {
        [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *item = [self.dataArray objectAtIndex:indexPath.row];
    
    BOOL checked = [[item objectForKey:@"checked"] boolValue];
    
    checked = !checked;
    
    [item setObject:[NSNumber numberWithBool:checked] forKey:@"checked"];
    
    UITableViewCell *cell = [item objectForKey:@"cell"];
    UIButton *button = (UIButton *)cell.accessoryView;
    
    UIImage *newImage = (checked) ? [UIImage imageNamed:@"check-yes"] : [UIImage imageNamed:@"check-no"];
    
    [button setBackgroundImage:newImage forState:UIControlStateNormal];

}


# pragma mark - Buttons
- (void)checkMarkTapped:(id)sender withEvent: (UIEvent *) event {
  
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    
    if (indexPath != nil) {
        [self tableView: self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    }
    
}

- (void)doneTapped:(id)sender {
    UIAlertView *confirm = [[UIAlertView alloc]
        initWithTitle:@"Confirm"
        message:@"Are you sure you want to submit this checklist?"
        delegate:self
        cancelButtonTitle:nil
        otherButtonTitles:@"Yes", @"No", nil];

    [confirm show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        NSMutableDictionary *items = [[NSMutableDictionary alloc] init];
        int index = 0;
        for (NSMutableDictionary *dic in self.dataArray) {
            NSNumber *value = [dic objectForKey:@"checked"];
            NSString *key = [self.checkList objectAtIndex:index];
            index++;
            [items setObject:value forKey:key];
        }
        self.transportData[@"checklist"] = items;
        [self.transportData saveEventually];
        [self performSegueWithIdentifier:@"toTransport" sender:self];
    }
}

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    
//    if ([segue.identifier isEqualToString:@"toTransport"]) {
//        //TODO pass data and probably combine base view controllers of ipad and iphones
//        
//        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//            AMBaseViewController *ipadVC = (AMBaseViewController *)segue.destinationViewController;
//            
//        } else {
//            AMBaseViewController *iphoneVC = (AMBaseViewController *)segue.destinationViewController;
//        }
//    }
//}

// Query for all users
- (void) queryForUsers {
    PFQuery *query = [PFUser query];
    
    self.allUsers = [NSMutableArray array];
    
    query.cachePolicy = kPFCachePolicyNetworkElseCache;
    [self.allUsers addObjectsFromArray:[query findObjects]];
}

- (void)showMail {
    
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
    
        NSString *transportTitle = [[NSString alloc] initWithFormat:@"%@%@ Review", @"Transport #", [self.transportData[@"TransportNumber"] stringValue]];
        [mailer setSubject:transportTitle];
        
        NSMutableArray *toRecipients = [[NSMutableArray alloc] init];
        
        for (NSString *user in self.transportData[@"CrewMembers"]) {
            for (int i = 0; i < self.allUsers.count; i++) {
                PFUser *userData = [self.allUsers objectAtIndex:i];
                if ([user isEqualToString:userData[@"username"]]) {
                    [toRecipients addObject:userData[@"email"]];
                }
            }
        }
        
        [mailer setToRecipients:toRecipients];
        
       
        
    
        [self presentModalViewController:mailer animated:YES];
        [self presentViewController:mailer animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sorry"
                                                        message:@"Your device doesn't support emailing"
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
    [self dismissModalViewControllerAnimated:YES];
}
                                                   
                                    

@end
