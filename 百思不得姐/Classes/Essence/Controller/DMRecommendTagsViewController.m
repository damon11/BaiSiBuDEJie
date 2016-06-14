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
/*当前页码*/
@property(nonatomic, assign) NSInteger page;
/** 上一次请求参数 */
@property(nonatomic,strong) NSDictionary *params;
@end

static NSString *DMTagId = @"tag";

@implementation DMRecommendTagsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
  
    [self setupRefresh];
}

-(void)setupTableView
{
    self.title = @"推荐标签";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DMRecommendTagCell class]) bundle:nil] forCellReuseIdentifier:DMTagId];
    self.tableView.rowHeight = 70;
    self.tableView.separatorStyle = UITableViewCellAccessoryNone;
    self.tableView.backgroundColor = DXGlobalBg;
}


-(void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTags)];
    //自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTags)];
}

-(void)loadNewTags
{
    
    //结束上拉刷新
    [self.tableView.mj_footer endRefreshing];
    //当前页码
    self.page = 0;
    //发送请求
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    self.params = params;
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(self.params != params) return ;
        self.tags = [DMRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_header endRefreshing];

    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        if(self.params != params) return ;
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        //恢复页码
        self.page--;
    }];
}

-(void)loadMoreTags{
    
    //结束上拉刷新
    [self.tableView.mj_header endRefreshing];
    //当前页码
    self.page++;
    //发送请求
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"tag_recommend";
    params[@"action"] = @"sub";
    params[@"c"] = @"topic";
    params[@"page"] = @(self.page);
    self.params = params;
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if(self.params != params) return ;
        self.tags = [DMRecommendTag mj_objectArrayWithKeyValuesArray:responseObject];
        [self.tableView reloadData];
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        if(self.params != params) return ;
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        //恢复页码
        self.page--;
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
