//
//  AMDocumentViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
#import "AMDocumentViewController.h"
#import "AMCheckListTableViewController.h"
#import "AMDocumentTableViewCell.h"

@interface AMDocumentViewController ()

@property (strong, nonatomic) NSArray *sectionHeaderTypes;
@end

@implementation AMDocumentViewController 

-(void) viewDidLoad {
    [super viewDidLoad];

    // Get the keys from the parse object and set them as sections
    self.sectionHeaderTypes = [[NSArray alloc] initWithArray:[self.doc allKeys]];
    NSLog(@"%@", self.sectionHeaderTypes);
    
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
    id object = [self.doc objectForKey:section];
    
    if ([object isKindOfClass:[NSArray class]]) {
        NSArray *ar = (NSArray *)object;
        for (int i = 0; i < ar.count; i++) {
            [data appendString:@"- "];
            [data appendString:ar[i]];
            
            if (i < ar.count -1) {
                [data appendFormat:@"\n"];
            }
        }
    } else if ([object isKindOfClass:[NSString class]]) {
        [data appendString:(NSString *)object];
    }
    
    
    return [[NSString alloc] initWithString:data];
}

// Calculate the height for the row based on the contents
- (CGFloat)getRowHeight:(NSString *)section {
    CGFloat height = 20.0f;
    CGSize max = CGSizeMake(self.view.frame.size.width, 800);
    CGRect rect;
    NSString *str = [[NSString alloc] init];
    
    str = [self getDocumentString:section]; 
    rect = [str boundingRectWithSize:max
                             options:NSStringDrawingUsesLineFragmentOrigin
                          attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]}
                             context:nil];
    height = rect.size.height;
    height += 45;
    
    return height;
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return self.sectionHeaderTypes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   
    // Get our custom cell
    AMDocumentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"docCell" forIndexPath:indexPath];
    

    // Get the data type we want to show and set that as the text for the row index
    cell.textView.text = [self getDocumentString:[self.sectionHeaderTypes objectAtIndex:indexPath.section]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return [self.sectionHeaderTypes objectAtIndex:section]; 
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return [self getRowHeight:[self.sectionHeaderTypes objectAtIndex:indexPath.section]];
    
}

- (void)checkMarkTapped:(id)sender {
    
    [self performSegueWithIdentifier:@"toCheckList" sender:self];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"toCheckList"]) {
        AMCheckListTableViewController *vc = (AMCheckListTableViewController *)segue.destinationViewController;
   
        [vc setCheckList:self.doc[@"checklist"]];
    }
}
@end
