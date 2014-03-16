//
//  AMDocumentViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
#import "AMDocumentViewController.h"

@interface AMDocumentViewController ()


@end

@implementation AMDocumentViewController 

-(void) viewDidLoad {
    [super viewDidLoad];
    //TODO: Handle ios 6 bar color
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
	[self.navigationItem setTitle:[self.info objectForKey:@"title"]];
    
}


- (NSString *)getDocumentString:(NSString *)section {
    NSMutableString *data = [[NSMutableString alloc] init];
    NSArray *ar = _doc[section];
    
    for (int i = 0; i < ar.count; i++) {
        [data appendString:@"- "];
        [data appendString:ar[i]];
        
        if (i < ar.count -1) {
            [data appendFormat:@"\n"];
        }
    }
    
    
    return [[NSString alloc] initWithString:data];
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
    int count = 8;
    return count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier = @"docCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    UILabel *label = (UILabel *)[cell.contentView viewWithTag:10];
    
    
    UITextView *data = (UITextView *)[cell.contentView viewWithTag:11];
    
    
    // Configure cell
    switch (indexPath.row) {
        case 0:
            label.text = @"Original Date:";
            data.text = _doc[@"originalDate"];
            break;
            
        case 1:
            label.text = @"Revised Date:";
            data.text = _doc[@"revisedDate"];
            break;
            
        case 2:
            label.text = @"Considerations:";
            data.text = [self getDocumentString:@"considerations"];
            break;
            
        case 3:
            label.text = @"Interventions:";
            data.text = [self getDocumentString:@"interventions"];
            break;
            
        case 4:
            label.text = @"Tests and Studies:";
            data.text = [self getDocumentString:@"testsAndStudies"];
            break;
            
        case 5:
            label.text = @"Medications:";
            data.text = [self getDocumentString:@"medications"];
            break;
            
        case 6:
            label.text = @"Impressions:";
            data.text = [self getDocumentString:@"impressions"];
            break;
            
        case 7:
            label.text = @"Other Considerations:";
            data.text = [self getDocumentString:@"other"];
            break;
            
            
            
        default:
            break;
    }
    
    
    return cell;
}

// user selected a card from the table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 20.0f;
    CGSize max = CGSizeMake(201, 800);
    CGRect rect;
    NSString *str = [[NSString alloc] init];
    
    switch (indexPath.row) {
        case 0:
            str = _doc[@"originalDate"];
           rect = [str boundingRectWithSize:max
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                                                       context:nil];
            height = rect.size.height;
            
            break;
        case 1:
            str = _doc[@"revisedDate"];
            rect = [str boundingRectWithSize:max
                                                       options:NSStringDrawingUsesLineFragmentOrigin
                                                    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                                                       context:nil];
            height = rect.size.height;
            
            break;
        case 2:
            str = [self getDocumentString:@"considerations"];
            rect = [str boundingRectWithSize:max
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                                   context:nil];
            height = rect.size.height;
            
            break;
            
        case 3:
            str = [self getDocumentString:@"interventions"];
            rect = [str boundingRectWithSize:max
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                                    context:nil];
            height = rect.size.height;
            
            break;
            
        case 4:
            str = [self getDocumentString:@"testsAndStudies"];
            rect = [str boundingRectWithSize:max
                                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                                                                            context:nil];
            height = rect.size.height;
            
            break;
            
        case 5:
            str = [self getDocumentString:@"medications"];
            rect = [str boundingRectWithSize:max
                                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                                                                            context:nil];
           height = rect.size.height;
            
            break;
        case 6:
            str = [self getDocumentString:@"impressions"];
            rect = [str boundingRectWithSize:max
                                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                                                                            context:nil];
            height = rect.size.height;
            
            break;
        case 7:
            str = [self getDocumentString:@"other"];
            rect = [str boundingRectWithSize:max
                                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                                                                            context:nil];
            height = rect.size.height;
            
            break;
            
        default:
            break;
    }
   
    return height+60;
    
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
