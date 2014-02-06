//
//  AMiPhoneBaseViewController.m
//  AeroMed
//
//  Created by Michael Torres on 2/5/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPhoneBaseViewController.h"

@interface AMiPhoneBaseViewController ()
@property (nonatomic, strong) UIView *leftEye;
@property (nonatomic, strong) UIView *rightEye;
@property (nonatomic, strong) UIView *mouth; @end

@implementation AMiPhoneBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    UILabel *helloGuys = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 170, 70)];
    helloGuys.text = @"Hello Group!";
    [self.view addSubview:helloGuys];
    
	// Do any additional setup after loading the view.
    self.leftEye = [[UIView alloc] initWithFrame:CGRectMake(66,160,70,70)];
    self.leftEye.layer.cornerRadius = 50;
    self.leftEye.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.leftEye];
    
    self.rightEye = [[UIView alloc] initWithFrame:CGRectMake(200,160,70,70)];
    self.rightEye.layer.cornerRadius = 50;
    self.rightEye.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.rightEye];
    
    self.mouth = [[UIView alloc] initWithFrame:CGRectMake(98,247,136,50)];
    self.mouth.layer.cornerRadius = 10;
    self.mouth.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.mouth];
    
    
    
    [UIView animateWithDuration:6 animations:^ {
        self.leftEye.frame = CGRectMake(66, 1000, 70, 70);
        self.rightEye.frame = CGRectMake(200, 1000, 70, 70);
        self.mouth.frame = CGRectMake(98, 1000, 136, 50);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
