//  MasterViewController.h
//  jsonTestApp01

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface MasterViewController : UITableViewController

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSString *next_url;
@end
