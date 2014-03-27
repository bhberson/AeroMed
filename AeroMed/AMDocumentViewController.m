//
//  AMDocumentViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
#import "AMDocumentViewController.h"
#import "AMCheckListTableViewController.h"

@interface AMDocumentViewController ()


@end

@implementation AMDocumentViewController 

-(void) viewDidLoad {
    [super viewDidLoad];
    //TODO: Handle ios 6 bar color
    
 
	[self.navigationItem setTitle:[self.doc objectForKey:@"title"]];
    
    if (self.shouldDisplayChecklist) {
        UIImage *img = [UIImage imageNamed:@"checklist.png"];
        UIBarButtonItem *checklist = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStylePlain target:self action:@selector(checkMarkTapped:)];
        self.navigationItem.rightBarButtonItem = checklist;
    }
    
    
}

// Convert the array of strings into a formatted string
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
    return 8;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    static NSString *CellIdentifier = @"docCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    UITextView *data = (UITextView *)[cell.contentView viewWithTag:11];
    
    
    // Configure cell
    switch (indexPath.section) {
        case 0:
            data.text = _doc[@"originalDate"];
            break;
            
        case 1:
            data.text = _doc[@"revisedDate"];
            break;
            
        case 2:
            data.text = [self getDocumentString:@"considerations"];
            break;
            
        case 3:
            data.text = [self getDocumentString:@"interventions"];
            break;
            
        case 4:
            data.text = [self getDocumentString:@"testsAndStudies"];
            break;
            
        case 5:
            data.text = [self getDocumentString:@"medications"];
            break;
            
        case 6:
            data.text = [self getDocumentString:@"impressions"];
            break;
            
        case 7:
            data.text = [self getDocumentString:@"other"];
            break;
            
            
            
        default:
            break;
    }
    
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = [[NSString alloc] init];
    
    switch (section) {
        case 0:
            title = @"Original Date";
            break;
            
        case 1:
            title = @"Revised Date";
            break;
            
        case 2:
            title = @"Considerations";
            break;
            
        case 3:
            title = @"Interventions";
            break;
            
        case 4:
            title = @"Tests and Studies";
            break;
            
        case 5:
            title = @"Medications";
            break;
            
        case 6:
            title = @"Impressions";
            break;
            
        case 7:
            title = @"Other Considerations";
            break;
            
        default:
            break;
    }
    
    return title;
}

// user selected a card from the table
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 20.0f;
    CGSize max = CGSizeMake(self.view.frame.size.width, 800);
    CGRect rect;
    NSString *str = [[NSString alloc] init];
    
    switch (indexPath.section) {
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
   
    return height+45;
    
}

- (void)checkMarkTapped:(id)sender {
    
    [self performSegueWithIdentifier:@"toCheckList" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toCheckList"]) {
        AMCheckListTableViewController *vc = (AMCheckListTableViewController *)segue.destinationViewController;
   
        [vc setCheckList:_doc[@"checklist"]];
    }
}
@end
