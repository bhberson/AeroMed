//
//  AMDocumentViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.
#import "AMDocumentViewController.h"

@interface AMDocumentViewController ()
@property (weak, atomic) PFObject *doc;

@end

@implementation AMDocumentViewController 

-(void) viewDidLoad {
    [super viewDidLoad];
    //TODO: Handle ios 6 bar color
    
    [self.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
	[self.navigationItem setTitle:[self.info objectForKey:@"title"]];
    
    [self addData];
}



-(void)addData {
    
    if (_doc) {
        
        NSMutableString *text = [self formatOperatingProcedure];
        self.textView.text = text;
        
    }
}

-(NSMutableString *)formatOperatingProcedure {
    NSMutableString *data = [[NSMutableString alloc] initWithString:_doc[@"title"]];
    [data appendString:@"\n"];
    [data appendString:@"Original Data:"];
    [data appendString:_doc[@"originalDate"]];
    
                            
    return data;
}

@end
