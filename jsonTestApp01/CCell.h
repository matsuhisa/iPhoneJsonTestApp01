//  CCell.h
//  jsonTestApp01

#import <UIKit/UIKit.h>

@protocol CCellDelegate;
@interface CCell : UITableViewCell

@property (nonatomic, weak) id <CCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
@property (weak, nonatomic) IBOutlet UILabel *updatedAtLabel;
@property (weak, nonatomic) IBOutlet UITextView *messageTextView;
@property (weak, nonatomic) IBOutlet UIImageView *mainImage;

// ウェブフォント
@property (weak, nonatomic) IBOutlet UILabel *iconLabel;

// 画像表示処理
@property (nonatomic, copy) NSString *imageUrl;

@property (weak, nonatomic) IBOutlet UIView *maskView;
//@property (weak, nonatomic) IBOutlet UIView *testView;



@end

@protocol CCellDelegate <NSObject>
@end