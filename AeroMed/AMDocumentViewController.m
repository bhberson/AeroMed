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
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
	[self.navigationItem setTitle:[self.info objectForKey:@"title"]];
    
    [self.scrollView setDelegate:self];
    
    [self queryForDocument];
}

-(void)queryForDocument {
   // PFQuery *query = [PFQuery queryWithClassName:@""]
}

#pragma mark - Scrollview methods 

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    NSLog(@"Scrolling");
}
@end
