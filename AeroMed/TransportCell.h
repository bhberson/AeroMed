//
//  TransportCell.h
//
//
//  Created by Brody Berson
//
//

#import <UIKit/UIKit.h>

@interface TransportCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel *numLabel;
@property (nonatomic, strong) IBOutlet UILabel *typeLabel;
@property (strong, nonatomic) IBOutlet UILabel *hasChecklist;

@end
