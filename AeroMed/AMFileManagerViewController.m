//
//  AMFileManagerViewController.m
//  AeroMed
//
//  Copyright (c) 2014 GVSU. All rights reserved.

#import "AMFileManagerViewController.h"
#import "AMDocumentViewController.h"
#import "AMFolderViewController.h"
#import "AMBaseDocumentViewController.h"
#import "SWRevealViewController.h"

#define kStructureKey @"Structure"

@interface AMFileManagerViewController ()
@property (strong, nonatomic) NSArray *documents;
@end

@implementation AMFileManagerViewController

- (void)viewDidLoad
{
    
   
    
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    
    // If we are in the main folder structure
    if (!self.isSubFolder) {
        NSLog(@"quering for structure");
        
        // If we do not have a structure then query the database
        if (self.navigationStructure == nil) {
            [self queryForFiles];
            
        // We already have a structure
        } else {
            self.viewControllerData = [[NSMutableArray alloc] initWithArray:self.navigationStructure];
             [self.centerText removeFromSuperview];
        }
        
    // If we are displaying the documents in a folder
    } else {
        [self queryForDocuments];
        [self.centerText removeFromSuperview];
    }
}

-(void) queryForDocuments {
    PFQuery *query = [PFQuery queryWithClassName:@"OperatingProcedure"];
    [query whereKeyExists:@"title"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        _documents = objects;
        
    }];
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
            self.navigationStructure = [[NSArray alloc] initWithArray:json];
            
            // Loop through our top level structures and store the dictionary info
            for (int i = 0; i < [json count]; i++) {
                NSMutableDictionary *data = [json objectAtIndex:i];
                [self.viewControllerData addObject:data];
            }

            // Reload the data
            [self reloadDataAnimated:YES];
            [self.centerText removeFromSuperview];
        } else {
          //  self.viewControllerData = [[NSArray alloc] init];
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
    
    // Get the relevant data for the navigation controller
    NSDictionary* navDict = [self.viewControllerData objectAtIndex: index];
    
    // Get the storyboard
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    
    // Determine if it is a folder or a document
    NSString *type = [navDict objectForKey:@"type"];
    AMDocumentViewController *viewController;
    

    if ([type isEqualToString:@"folder"]) {
        AMFolderViewController *viewController = [st instantiateViewControllerWithIdentifier:@"FolderViewController"];
        [viewController setInfo: navDict];
        return [[UINavigationController alloc] initWithRootViewController:viewController];
    } else if ([type isEqualToString:@"document"]) {
        viewController = [st instantiateViewControllerWithIdentifier:@"DocumentViewController"];
        [viewController setInfo: navDict];
        return [[UINavigationController alloc] initWithRootViewController:viewController];
    } else {
        NSLog(@"error");
        viewController = [st instantiateViewControllerWithIdentifier:@"DocumentViewController"];
    }
    
    
    //Return the custom view controller wrapped in a UINavigationController
    return [[UINavigationController alloc] initWithRootViewController:viewController];
}

-(void) noteViewController: (KLNoteViewController*) noteViewController didUpdateControllerCard:(KLControllerCard*)controllerCard toDisplayState:(KLControllerCardState) toState fromDisplayState:(KLControllerCardState) fromState {    
    NSInteger index = [noteViewController indexForControllerCard: controllerCard];
    NSDictionary* navDict = [self.viewControllerData objectAtIndex: index];
    

    if (toState == 3 && [[navDict objectForKey:@"type"] isEqualToString:@"folder"]) {
        NSLog(@"Folder was pulled up");
        self.viewControllerData = [[NSMutableArray alloc] initWithArray:[navDict objectForKey:@"contains"]];
        [self performSegueWithIdentifier:@"toBaseDocument" sender:self];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    // Go the base document view controller
    if ([segue.identifier isEqualToString:@"toBaseDocument"]) {
        NSLog(@"Performing segue to Base Document Controller");
        AMBaseDocumentViewController *vc = (AMBaseDocumentViewController *) segue.destinationViewController;
        vc.viewControllerData = [[NSMutableArray alloc] initWithArray:self.viewControllerData];
        vc.navigationStructure = self.navigationStructure;
        vc.isSubFolder = !self.isSubFolder;
    }
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
