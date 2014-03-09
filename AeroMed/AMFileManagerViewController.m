//
//  AMFileManagerViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.

#import "AMFileManagerViewController.h"
#import "AMDocumentViewController.h"
#import "SWRevealViewController.h"

#define kStructureKey @"Structure"

@interface AMFileManagerViewController ()

@end

@implementation AMFileManagerViewController

- (void)viewDidLoad
{
    // Get data from parse
    //TODO: select a company and handle no internet connection
    [self queryForFiles];
    
    [super viewDidLoad];

}

- (void) queryForFiles {
    PFQuery *query = [PFQuery queryWithClassName:@"NavigationStructure"];
    [query whereKey:@"organization" equalTo:@"Aero Med"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            self.viewControllerData = [[NSMutableArray alloc] init];
            NSLog(@"Found %d", objects.count);
            PFObject *company = [objects firstObject];
            NSLog(@"company: %@", company[@"organization"]);
            
            // Get the structure property which is an array
            NSArray *structure = company[@"structure"];
            
            // Convert the array into json
            NSError *err;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:structure options:NSJSONWritingPrettyPrinted error:&err];
            
            // Returns an array of dictionaries
            NSArray *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&err];
            
            // Loop through our top level structures and store the dictionary info
            for (int i = 0; i < [json count]; i++) {
                NSMutableDictionary *data = [json objectAtIndex:i];
                [self.viewControllerData addObject:data];
            }
            
            // Reload the data
            [self reloadDataAnimated:YES];
            [self.centerText removeFromSuperview];
        } else {
            self.viewControllerData = [[NSArray alloc] init];
            [self.centerText setText:@"Need internet connection"];
            //TODO: refresh when connection available
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Note card control
- (NSInteger)numberOfControllerCardsInNoteView:(KLNoteViewController*) noteView {
    return  [self.viewControllerData count];
}
- (UIViewController *)noteView:(KLNoteViewController*)noteView viewControllerAtIndex:(NSInteger)index {
    //Get the relevant data for the navigation controller
    NSDictionary* navDict = [self.viewControllerData objectAtIndex: index];
    
    //Initialize a blank uiviewcontroller for display purposes
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    
    AMDocumentViewController* viewController = [st instantiateViewControllerWithIdentifier:@"RootViewController"];
    [viewController setInfo: navDict];

    //Return the custom view controller wrapped in a UINavigationController
    return [[UINavigationController alloc] initWithRootViewController:viewController];
}

-(void) noteViewController: (KLNoteViewController*) noteViewController didUpdateControllerCard:(KLControllerCard*)controllerCard toDisplayState:(KLControllerCardState) toState fromDisplayState:(KLControllerCardState) fromState {    
    NSInteger index = [noteViewController indexForControllerCard: controllerCard];
    NSDictionary* navDict = [self.viewControllerData objectAtIndex: index];
    
    NSLog(@"%@ changed state %ld", [navDict objectForKey:@"title"], toState);
}

#pragma mark - Saving and loading data

//- (void)encodeWithCoder:(NSCoder *)encoder {
//    [encoder encodeObject:self.navigationStructure forKey:kStructureKey];
//}
//
//- (id)initWithCoder:(NSCoder *)decoder {
//    NSArray *structure = [decoder decodeObjectForKey:kStructureKey];
//    self.navigationStructure = structure;
//    return self;
//}

@end
