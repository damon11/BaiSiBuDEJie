//
//  DMRecommendViewController.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/22.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMRecommendViewController.h"
#import "AFNetworking.h"
#import "MBProgressHUD.h"
#import "UIViewController+HUD.h"
#import "DMRecommendCategroyCell.h"
#import "DMRecommendUserCell.h"
#import "DMRecommendCategory.h"
#import "DMRecommendUser.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#define DMSelectedCategory self.categoies[self.categroyTableView.indexPathForSelectedRow.row]
@interface DMRecommendViewController ()<UITableViewDataSource,UITableViewDelegate>
/**
 *  分类表格
 */
@property (weak, nonatomic) IBOutlet UITableView *categroyTableView;
/**
 *  用户表格
 */
@property (weak, nonatomic) IBOutlet UITableView *userTableView;
/**
 *  左边数据
 */
@property (nonatomic, strong) NSArray *categoies;
/**
 *  右边数据
 */
@property (nonatomic, strong) NSArray *users;
@property (nonatomic, strong) NSMutableDictionary *params;

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation DMRecommendViewController

static NSString *const DMCategoryId = @"category";
static NSString *const DMUserId = @"user";



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupTableView];
    [self setupRfresh];
    [self loadCategories];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
}
-(void)checkFooterState
{
    DMRecommendCategory *category = DMSelectedCategory;
    
    self.userTableView.mj_footer.hidden = (category.users.count == 0);
    if(category.users.count == category.count){
        
        [self.userTableView.mj_footer endRefreshingWithNoMoreData];
    }else{
        [self.userTableView.mj_footer endRefreshing];
    }
}
#pragma mark <UITableViewDataSource>
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.categroyTableView) return self.categoies.count;
    
    [self checkFooterState];
    
    return [DMSelectedCategory users].count;
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.categroyTableView){//左边表格
        DMRecommendCategroyCell *cell = [tableView dequeueReusableCellWithIdentifier:DMCategoryId];
        cell.category = self.categoies[indexPath.row];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;

    }else {//右边表格
        DMRecommendUserCell *cell = [tableView dequeueReusableCellWithIdentifier:DMUserId];
        cell.user = [DMSelectedCategory users][indexPath.row];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        return cell;
    }
}
#pragma mark <UITableViewDelegate>


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //结束刷新
    [self.userTableView.mj_header endRefreshing];
    [self.userTableView.mj_footer endRefreshing];
    
    DMRecommendCategory *c = self.categoies[indexPath.row];
    
    DXLog(@"%@", c.name);
    
    if(c.users.count){
        [self.userTableView reloadData];
    }else{
        //赶紧刷新表格，目的是显示当前category的用户数据，
        [self.userTableView reloadData];
        
        //进入下拉刷新状态
        [self.userTableView.mj_header beginRefreshing];
    }
    
}

-(void)setupTableView
{
    //注册tableview
    
    [self.categroyTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DMRecommendCategroyCell class]) bundle:nil] forCellReuseIdentifier:DMCategoryId];
    [self.userTableView registerNib:[UINib nibWithNibName:NSStringFromClass([DMRecommendUserCell class]) bundle:nil] forCellReuseIdentifier:DMUserId];
    
//    设置inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.categroyTableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.userTableView.contentInset = self.categroyTableView.contentInset;
    self.userTableView.rowHeight = 70;
    self.userTableView.showsVerticalScrollIndicator = NO;
    
    self.title = @"推荐关注";
    self.view.backgroundColor = DXGlobalBg;
    
    
}

-(void)setupRfresh
{
    self.userTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewUsers)];
    self.userTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreUsers)];
    self.userTableView.mj_footer.hidden = YES;
}

/**
 *  上拉加载（右侧）
 */
-(void)loadMoreUsers
{
    
    DMRecommendCategory *category = DMSelectedCategory;
    //发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.ID);
    params[@"page"] = @(++category.currentPage);
    self.params = params;
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * task, id responseObject) {
        //字典数组 ——>数据模型
        NSArray *users = [DMRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //添加到当前类别对应的用户数组中
        
            [category.users addObjectsFromArray:users];
       
        if(self.params != params) return ;
        
        //刷新右边表格
        [self.userTableView reloadData];
        DXLog(@"%@",responseObject);
        //让底部控件结束刷新
        if(category.users.count < 20){
            if(category.currentPage > 1){
                [self.userTableView.mj_footer endRefreshingWithNoMoreData];
            }
            else{
                self.userTableView.mj_footer = nil;
            }
        }else{
            [self checkFooterState];
            
        }
        
    } failure:^(NSURLSessionDataTask * task, NSError *  error) {
        if(self.params != params) return ;
        [self showHint:@"加载推荐信息失败"];
    }];
}

/**
 *  下拉刷新（右侧）
 */
-(void)loadNewUsers{
    DMRecommendCategory *category = DMSelectedCategory;
    //设置当前页码为1
    category.currentPage = 1;
    
    //发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"list";
    params[@"c"] = @"subscribe";
    params[@"category_id"] = @(category.ID);
    params[@"page"] = @(category.currentPage);
    self.params = params;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * task, id responseObject) {
       
        //字典数组 ——>数据模型
        NSArray *users = [DMRecommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        //添加到当前类别对应的用户数组中
    
            [category.users removeAllObjects];
        
            [category.users addObjectsFromArray:users];
   
        
        category.total = [responseObject[@"totle"] integerValue];
        
        if(self.params != params) return ;
        
        //刷新右边表格
        [self.userTableView reloadData];
        DXLog(@"%@",responseObject[@"list"]);
        
        [self.userTableView.mj_header endRefreshing];
        
        //让底部控件结束刷新
        
        [self checkFooterState];
        
    } failure:^(NSURLSessionDataTask * task, NSError *  error) {
        [self showHint:@"加载推荐信息失败"];
        [self.userTableView.mj_header endRefreshing];
    }];
}

/**
 *  加载分类列表（左侧）
 */
-(void)loadCategories
{
    //发送请求
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"category";
    params[@"c"] = @"subscribe";
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * task, id responseObject) {
        NSLog(@"%@",responseObject);
        self.categoies = [DMRecommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.categroyTableView reloadData];
        
        //默认选中首行
        [self.categroyTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        [self.userTableView.mj_header beginRefreshing];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        [self showHint:@"加载推荐信息失败"];
    }];
}
-(AFHTTPSessionManager *)manager
{
    if(!_manager){
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}
#pragma mark - 控制器销毁
- (void)dealloc
{
    //停止所有操作
    [self.manager.operationQueue cancelAllOperations];
}
@end
