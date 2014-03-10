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
@property (nonatomic) BOOL tooManyDocuments;
@property (nonatomic) BOOL isSubFolder;
@property (strong, nonatomic) NSMutableArray *viewControllerData;
@property (strong, nonatomic) NSArray *topFolders;
@property (atomic) BOOL isClearingViews;
@end

@implementation AMFileManagerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (!_isSubFolder) {
        self.upButton.hidden = YES;
    } else {
        self.upButton.hidden = NO;
    }
   
  

}

-(void)viewWillAppear:(BOOL)animated {
    NSLog(@"view will appear");
    
    // If we are in the main folder structure
    if (!_isSubFolder) {
        
        // If we do not have a structure then query the database
        if (_topFolders == nil) {
            [self queryForFiles];
            
        // We already have a structure
        } else {
            self.viewControllerData = [[NSMutableArray alloc] initWithArray:_topFolders];
            
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
        
        // Contains an array of PFObjects
        _documents = objects;
        [self removeAllCards];
        [self reloadDataAnimated:YES];
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
            _topFolders = [[NSArray alloc] initWithArray:json];
            
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

-(void)upButtonTapped:(id)sender {
    _isSubFolder = NO;
    [self removeAllCards];
    _viewControllerData = nil;
    [self reloadDataAnimated:YES];
    _viewControllerData = [[NSMutableArray alloc] initWithArray:_topFolders];
    [self reloadDataAnimated:YES];
    
}

#pragma mark - Note card control

- (NSInteger)numberOfControllerCardsInNoteView:(KLNoteViewController*) noteView {
    NSInteger numCards =[self.viewControllerData count];
    
    // Limit the number of cards to display
    if (numCards > 10) {
        numCards = 10;
        _tooManyDocuments = YES;
    }
    
    return numCards;
}
- (UIViewController *)noteView:(KLNoteViewController*)noteView viewControllerAtIndex:(NSInteger)index {
    
    // Get the relevant data for the navigation controller
    NSDictionary *navDict = [self.viewControllerData objectAtIndex: index];
    NSArray *cardData = [self.documents objectAtIndex:index];
    
    // Get the storyboard
    UIStoryboard *st = [UIStoryboard storyboardWithName:[[NSBundle mainBundle].infoDictionary objectForKey:@"UIMainStoryboardFile"] bundle:[NSBundle mainBundle]];
    
    // Determine if it is a folder or a document
    NSString *type = [navDict objectForKey:@"type"];
    AMDocumentViewController *viewController;
    
    // If we are the 10th card in too many documents we want to show All Documents in the folder
    if (_tooManyDocuments && index == 10) {
        AMFolderViewController *viewController = [st instantiateViewControllerWithIdentifier:@"FolderViewController"];
        [viewController setAllDocuments:_documents];
        return viewController;
    }

    if ([type isEqualToString:@"folder"]) {
        AMFolderViewController *viewController = [st instantiateViewControllerWithIdentifier:@"FolderViewController"];
        [viewController setInfo: navDict];
        return [[UINavigationController alloc] initWithRootViewController:viewController];
    } else if ([type isEqualToString:@"document"]) {
        viewController = [st instantiateViewControllerWithIdentifier:@"DocumentViewController"];
        [viewController setInfo: navDict];
        [viewController setData:cardData];
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
    NSDictionary* navDict = [_viewControllerData objectAtIndex: index];


    if (toState == 3 && [[navDict objectForKey:@"type"] isEqualToString:@"folder"]) {
        NSLog(@"Folder was pulled up");
        self.viewControllerData = [[NSMutableArray alloc] initWithArray:[navDict objectForKey:@"contains"]];
        _isSubFolder = YES;
        [self removeAllCards];
        [self reloadDataAnimated:YES];
    }
    
}

// Remove all the cards from the view
-(void)removeAllCards {
    _isClearingViews = YES;
    for (UIView *view in self.view.subviews) {
        if ([view isMemberOfClass:[KLControllerCard class]]) {
            [(KLControllerCard *)view removeFromSuperview];
        }
    }
    
    if (!_isSubFolder) {
        self.upButton.hidden = YES;
    } else {
        self.upButton.hidden = NO;
    }
    _isClearingViews = NO;
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
