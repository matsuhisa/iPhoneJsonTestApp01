//  MasterViewController.m
//  jsonTestApp01

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "CCell.h"

@interface MasterViewController ()
- (void)initializePhotos;
@end

@implementation MasterViewController

- (void)initializePhotos
{
    NSMutableArray *tempPhotos = [[NSMutableArray alloc] init];
    self.photos = tempPhotos;
    
    
}

- (void)awakeFromNib
{
    [super awakeFromNib];
[UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.000 green:0.549 blue:0.890 alpha:1.000];
[UINavigationBar appearance].tintColor = [UIColor whiteColor];
[UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self fetchDataFromUrl:@"http://localhost:3000/photos.json"];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.photos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    CCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *photo = _photos[indexPath.row];
    
    cell.titleLabel.text      = photo[@"title"];
    cell.messageTextView.text = photo[@"message"];
    cell.updatedAtLabel.text  = photo[@"updated_at"]; // 日付は文字列としてくる？
    
    cell.imageUrl = photo[@"image_url"];
    
    cell.idLabel.text         = [photo[@"id"] stringValue];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// データー読み込み
// - URL を指定して読み込み
- (void)fetchDataFromUrl:(NSString *)post_url
{
    NSLog(@"----------");
    NSLog(@"%@", post_url);
    NSURL *url = [NSURL URLWithString:post_url];
    NSURLSession *session = [NSURLSession sharedSession];
    
    NSURLSessionDataTask *task =
    [session dataTaskWithURL:url
           completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
     {
         if (error)
         {
             // 通信が異常終了したときの処理
             return;
         }
         
         // 通信が正に常終了したときの処理
         NSError *jsonError = nil;
         NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
         
         // JSONエラーチェック
         if (jsonError != nil) return;
         
         // 検索結果をディクショナリにセット
         if([self.photos count] > 0)
         {
             self.photos = [NSMutableArray arrayWithArray:self.photos];
             [self.photos addObjectsFromArray:jsonDictionary[@"data"]];
         }else{
             self.photos = jsonDictionary[@"data"];
         }
         
         // 次のページの情報があるか
         self.next_url = jsonDictionary[@"pagination"][@"next_url"];

         // TableView をリロード
         // メインスレッドでやらないと最悪クラッシュする
         [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
         //[session invalidateAndCancel];
     }];
    
    // 通信開始
    [task resume];
    NSLog(@"----------");
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //一番下までスクロールしたかどうか
    if(self.tableView.contentOffset.y >= (self.tableView.contentSize.height - self.tableView.bounds.size.height))
    {
        //まだ表示するコンテンツが存在するか判定し存在するなら○件分を取得して表示更新する
        if(self.next_url.length > 0)
        {
            [self fetchDataFromUrl:self.next_url];
        }else{
            
        }
    }
}

// テーブルビューを再描画する
- (void)reloadTableView
{
    [self.tableView reloadData];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
    }
}

@end
