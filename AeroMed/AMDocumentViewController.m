//
//  AMDocumentViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
#import "AMDocumentViewController.h"

@implementation AMDocumentViewController

-(void) viewDidLoad {
    [super viewDidLoad];
    //TODO: Handle ios 6 bar color
    
    // Set right barbutton item to display type 
    UIImage *iconType = [UIImage imageNamed:@"folder"];
    UIBarButtonItem *displayType = [[UIBarButtonItem alloc] initWithImage:iconType style:UIBarButtonItemStylePlain target:self action:nil];
    self.navigationItem.rightBarButtonItem = displayType;
    [displayType setEnabled:NO];
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:0.200 green:0.749 blue:1.000 alpha:1.000]];
	[self.navigationItem setTitle:[self.info objectForKey:@"title"]];
    
    [self.scrollView setDelegate:self];
}


#pragma mark - Scrollview methods 

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"Scrolling");
}
@end
