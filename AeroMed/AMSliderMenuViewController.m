//
//  AMSideBarViewController.m
//  AeroMed
//
//  Created by Michael Torres on 2/16/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMSliderMenuViewController.h"
#import "SWRevealViewController.h"

@interface AMSliderMenuViewController ()
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation AMSliderMenuViewController

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
    
    _menuItems = @[@"title",@"transports", @"documentation",@"trends", @"logout"];

}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

// Set status bar content to white 
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    return [self.menuItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = [self.menuItems objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell..
    if ([CellIdentifier isEqualToString:@"title"]) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        NSString *email = [[PFUser currentUser] email];
        NSMutableString *greeting = [[NSMutableString alloc] init];
        [greeting appendString:@"Hi "];
        [greeting appendString:[email substringToIndex:[email rangeOfString:@"@"].location]];
        cell.textLabel.text = greeting;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
        cell.textLabel.enabled = YES;
    }
   
    
    return cell;
}

// For iOS 7 we need to customize the views here
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    self.tableView.separatorColor = [UIColor colorWithWhite:0.15f alpha:0.2f];
    cell.contentView.backgroundColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
    
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self.tableView reloadData];
}

- (void)didTapBack:(id)sender {
    NSLog(@"Going back.");
    [self.navigationController popViewControllerAnimated:YES];
}


- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
    // Set the title of navigation bar by using the menu items
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    UINavigationController *destViewController = (UINavigationController*)segue.destinationViewController;
    destViewController.title = [[_menuItems objectAtIndex:indexPath.row] capitalizedString];
    
    // If we clicked the logout button then logout
    if ([segue.identifier isEqualToString:@"logout"]) {
        if([PFUser currentUser]){
            [PFUser logOut];
            destViewController.title = @"Aero Med";
        }
    }
    
    // If we clicked the docuements cell
    if ([segue.identifier isEqualToString:@"documentation"]) {

            destViewController.title = @"Documentation";
            destViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Menu" style:UIBarButtonItemStylePlain target:self action:@selector(didTapBack:)];
        
    }
    
    // If we clicked the transports cell
    if ([segue.identifier isEqualToString:@"transports"]) {
        destViewController.title = @"Aero Med Transports";
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
    }
}


@end
