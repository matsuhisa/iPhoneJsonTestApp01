//  CCell.m
//  jsonTestApp01

#import "CCell.h"

@interface CCell ()
- (void)initializeIcon;
@end

@implementation CCell
-(void)initializeIcon
{

}


-(void)setImageUrl:(NSString *)newImageUrl
{
    NSLog(@"-------------");
    NSLog(@"initializeIcon");
    NSLog(@"-------------");

    // 枠線
    [[self.maskView layer] setBorderColor:[[UIColor  colorWithRed:0.75 green:0.76 blue:0.78 alpha:1.0] CGColor]];
    [[self.maskView layer] setBorderWidth:1.0];

    //
    /*
    self.testView.layer.cornerRadius = 8; // if you like rounded corners
    self.testView.layer.shadowOffset = CGSizeMake(0, -10); // 上向きの影
    self.testView.layer.shadowRadius = 3;
    self.testView.layer.shadowOpacity = 0.8;
    */
    
    // 絵文字のテスト
    UniChar unicode = 0xF000;
    NSString* icon  = [[NSString alloc] initWithCharacters:&unicode length:1];
    //[self.iconLabel setFont:[UIFont fontWithName:@"FontAwesome" size:20.0]];
    self.iconLabel.font = [UIFont fontWithName:@"FontAwesome" size:20.0];
    self.iconLabel.text = icon;
    
    _imageUrl = newImageUrl;
    
    // 画像取得
    NSURL *image_url = [NSURL URLWithString:self.imageUrl];
    
    // セッションを用意する
    // - タイムアウトの時間などを設定可能らしい
    NSURLSessionConfiguration* config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession* session = [NSURLSession sessionWithConfiguration:config];
    
    // タスクの設定をする
    NSURLSessionDataTask* task =
    [session dataTaskWithURL:image_url
           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
               
               // オリジナル画像
               UIImage* image = [UIImage imageWithData:data];
               
               // リサイズの流れ
               // 1.横サイズ指定（600）でリサイズ
               // 2.切り抜きをする（600x400）

               // サイズ指定
               NSInteger target_width  = 600;
               NSInteger target_height = 400;

               // リサイズ
               float resize_width_per = target_width/image.size.width;
               CGRect rect = CGRectMake(0, 0, target_width, (image.size.height*resize_width_per));
               NSLog(@"-------------");
               NSLog(@"%f", image.size.height*resize_width_per);
               NSLog(@"-------------");
               UIGraphicsBeginImageContext(rect.size);
               [image drawInRect:rect];
               UIImage *createImage  = UIGraphicsGetImageFromCurrentImageContext();
               UIGraphicsEndImageContext();

               
               // クリッピング（切り抜き）
               // http://blog.livedoor.jp/arumisoft/archives/6688207.html
               // http://qiita.com/blurrednote/items/3ad3aa92024b4f7401cd
               CGRect scaledRect = CGRectMake(0, 0, target_width, target_height);
               CGImageRef clip = CGImageCreateWithImageInRect(createImage.CGImage,scaledRect);
               UIImage *clipedImage = [UIImage imageWithCGImage:clip scale:1 orientation:UIImageOrientationUp];
               CGImageRelease(clip);

               // Retinaの判別
               /*
               float scale = [[UIScreen mainScreen] scale];
               //CGRect scaledRect = CGRectMake(rect.origin.x * scale, rect.origin.y * scale, rect.size.width * scale, rect.size.height * scale);
               CGRect scaledRect = CGRectMake(0, 0, 600, 300);
               CGImageRef clip = CGImageCreateWithImageInRect(createImage.CGImage,scaledRect);
               UIImage *clipedImage = [UIImage imageWithCGImage:clip scale:1 orientation:UIImageOrientationUp];
               CGImageRelease(clip);
               */
               
               // 設定
               _mainImage.contentMode = UIViewContentModeScaleAspectFit;
               //_mainImage.contentMode = UIViewContentModeScaleToFill;
               //_mainImage.contentMode = UIViewContentModeScaleAspectFill;
               
               
               // UIImageVIewを更新する
               dispatch_async(dispatch_get_main_queue(), ^{
                   //_mainImage.image = createImage;
                   //_mainImage.image = image;
                   _mainImage.image = clipedImage;
               });
           }];
    
    [task resume];
}

@end
