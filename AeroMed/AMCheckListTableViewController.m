//
//  AMCheckListTableViewController.m
//  AeroMed
//
//  Created by Michael Torres on 3/16/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMCheckListTableViewController.h"
#import "AMiPadBaseViewController.h"
#import "AMiPhoneBaseViewController.h"

@interface AMCheckListTableViewController ()
@property NSMutableArray *dataArray;

@end

@implementation AMCheckListTableViewController

- (id)initWithStyle:(UITableViewStyle)style
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
    

    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneTapped:)];
    self.navigationItem.rightBarButtonItem = done;
    
 
    
    NSLog(@"%@",_checkList);
 
    _dataArray = [[NSMutableArray alloc] initWithCapacity:self.checkList.count];
    
    // Initialize our data array to hold a dictionary to hold cell data and checkmark data
    for (NSString *item in self.checkList) {
        NSMutableDictionary *dataDic = [[NSMutableDictionary alloc] initWithCapacity:2];
        [dataDic setObject:[NSNumber numberWithBool:NO] forKey:@"checked"];
        [_dataArray addObject:dataDic];
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
    return [self.checkList count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"checkCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text =[self.checkList objectAtIndex:indexPath.row];
  
    NSMutableDictionary *item = [_dataArray objectAtIndex:indexPath.row];
    
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
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *item = [_dataArray objectAtIndex:indexPath.row];
    
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
    [self performSegueWithIdentifier:@"toTransport" sender:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"toTransport"]) {
        //TODO pass data and probably combine base view controllers of ipad and iphones
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            AMiPadBaseViewController *ipadVC = (AMiPadBaseViewController *)segue.destinationViewController;
            
        } else {
            AMiPhoneBaseViewController *iphoneVC = (AMiPhoneBaseViewController *)segue.destinationViewController;
        }
    }
}

@end
