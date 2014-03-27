//
//  AMFolderViewController.m
//  AeroMed
//
//  Created by Michael Torres on 3/8/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMFolderViewController.h"
#import "AMDocumentViewControllerOld.h"

@interface AMFolderViewController ()
@property (weak, nonatomic) NSArray *navigationStructure;
@property (weak, nonatomic) NSArray *folderContainments;
@end

@implementation AMFolderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIImage *iconType = [UIImage imageNamed:@"folder"];
    UIBarButtonItem *displayType = [[UIBarButtonItem alloc] initWithImage:iconType style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = displayType;
    [displayType setEnabled:NO];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.200 green:0.749 blue:1.000 alpha:1.000]];
    
    // If we are passed in documents to show then show them as an All Documents table
    if (self.allDocuments) {
        [self.navigationItem setTitle:@"All Documents"];
    } else {
        [self.navigationItem setTitle:[self.info objectForKey:@"title"]];
        _navigationStructure = [self.info objectForKey:@"contains"];
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
    NSInteger items = 0;
    if (self.allDocuments) {
        items = [self.allDocuments count];
    } else {
        items = [_navigationStructure count];
    }
    return items;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"myCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (self.allDocuments) {
        // Data for all documents
        PFObject *document = [self.allDocuments objectAtIndex:indexPath.row];
        
        // Configure the cell...
        cell.textLabel.text = document[@"title"];
        cell.detailTextLabel.text = @"";
    } else {
        // Data for cell
        NSDictionary *data = [_navigationStructure objectAtIndex:indexPath.row];
    
        // Configure the cell...
        cell.textLabel.text = [data objectForKey:@"title"];
        cell.detailTextLabel.text = [data objectForKey:@"type"];
    }
    
    return cell;
}

// user selected a card from the table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Send a notification to the file manager to display the card that was selected
    PFObject *document = [self.allDocuments objectAtIndex:indexPath.row];
    NSDictionary *data = [NSDictionary dictionaryWithObject:document forKey:@"cardSelected"];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tappedCard" object:nil userInfo:data];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/



@end
