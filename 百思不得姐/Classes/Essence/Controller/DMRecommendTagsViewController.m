//
//  DMRecommendTagsViewController.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/25.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMRecommendTagsViewController.h"
#import "MBProgressHUD.h"
#import "AFNetworking.h"
#import "UIViewController+HUD.h"
#import "MJRefresh.h"
#import "DMRecommendTag.h"
#import "MJExtension.h"
#import "DMRecommendTagCell.h"
@interface DMRecommendTagsViewController ()
@property(nonatomic,strong) NSArray *tags;
@end

static NSString *DMTagId = @"tag";

@implementation DMRecommendTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
  
    [self loadTags];
}

-(void)setupTableView
{
    self.title = @"推荐标签";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DMRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:DMTagId];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.backgroundColor = DXGlobalBg;
}

-(void)loadTags
{
    //发送请求
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        self.tags = [DMRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        [self showHint:@"加载标签数据失败"];
    }];
}
#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.tags.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DMRecommendTagCell *cell = [tableView dequeueReusableCellWithIdentifier:DMTagId];
    
    cell.recommendTag = self.tags[indexPath.row];
    
    return cell;
}

@end
