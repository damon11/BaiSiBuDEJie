//
//  DMTopicViewController.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/1.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTopicViewController.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "DMTopics.h"
#import "MJExtension.h"
#import "MJRefresh.h"
#import "DMTopicCell.h"
#import "DMConmentViewController.h"
#import "DMNewViewController.h"
#import "KRVideoPlayerController.h"

static NSString *const DMTopicCellId = @"topic";

@interface DMTopicViewController ()
/**
 *  帖子数据
 */
@property(nonatomic, strong) NSMutableArray *topics;
/*当前页码*/
@property(nonatomic, assign) NSInteger page;
/*当加载下一页数据时需要这个参数*/
@property(nonatomic,strong) NSString *maxtime;

@property (nonatomic, strong) KRVideoPlayerController *videoController;
/** 上一次请求参数 */
@property(nonatomic,strong) NSDictionary *params;
/**上一次选中的索引（或者控制器）*/
@property(nonatomic, assign) NSInteger lastselectedIndex;
@end

@implementation DMTopicViewController

-(NSMutableArray *)topics{
    if(!_topics){
        _topics = [NSMutableArray array];
    }
    return _topics;
}
//-(NSString *)type{
//    return nil;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    //初始化表格
    [self setupTableView];
    //添加刷新控件
    [self setupRefresh];
    
}



-(void)setupTableView{
    //设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = DMTitleViewH + DMTitleViewY;
    self.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    //滚动条的内边距
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;

    self.tableView.separatorStyle = NO;
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DMTopicCell class]) bundle:nil] forCellReuseIdentifier:DMTopicCellId];
    
    //监听tabbar点击的通知
    [DMNotificationCenter addObserver:self selector:@selector(tabBarSelect) name:DMTabBarDidSelectNotification object:nil];
}
-(void)tabBarSelect{
    //如果选中的不是当前的导航控制器，直接返回
    //如果是连续选中2次，直接刷新
    if(self.lastselectedIndex == self.tabBarController.selectedIndex
//       &&self.tabBarController.selectedViewController == self.navigationController
       &&self.view.isShowingOnWindow){
        [self.tableView.mj_header beginRefreshing];
    }
    DXLogFunc;
        //记录这一次选中的索引
    self.lastselectedIndex = self.tabBarController.selectedIndex;
}

-(void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewTopics)];
    //自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreTopics)];
}

#pragma mark -param参数
-(NSString *)param{
    return [self.parentViewController isKindOfClass:[DMNewViewController class]] ? @"newlist":@"list";
}

#pragma mark -数据处理
/**
 *  加载新的帖子数据
 */
-(void)loadNewTopics{
    
    //结束上拉刷新
    [self.tableView.mj_footer endRefreshing];
    
    
    //当前页码
    self.page = 0;
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.param;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    self.params = params;
    //发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * task, id responseObject) {
        if(self.params != params) return ;
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        //下拉刷新 直接覆盖就行
        self.topics = [DMTopics mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        DXLog(@"%@",self.topics);
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
        //加载成功后 清空页码
        self.page = 0;
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        if(self.params != params) return ;
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        //恢复页码
        self.page--;
    }];
}

//先下拉刷新，再上来刷新第5页数据


//下拉刷新成功回来:只有一页数据,page == 0
//上拉刷新成功回来:最前面那页 + 第5页数据



/**
 *  加载更多的帖子数据
 */
-(void)loadMoreTopics{
    //结束下拉
    [self.tableView.mj_header endRefreshing];
    
    
    self.page++;
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = self.param;
    params[@"c"] = @"data";
    params[@"type"] = @(self.type);
    params[@"page"] = @(self.page);
    params[@"maxtime"] = self.maxtime;
    self.params = params;
    //发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * task, id responseObject) {
        if(self.params != params) return ;
        
        //存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        //上拉加载 不要覆盖之前数据 要存储起来
        //字典->模型
        NSMutableArray *newTopics = [NSMutableArray array];
        newTopics = [DMTopics mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.topics addObjectsFromArray:newTopics];
        //刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
        if(self.params != params) return ;
        //结束刷新
        [self.tableView.mj_footer endRefreshing];
        //刷新失败以防page加上一个
        self.page--;
    }];
}




#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    self.tableView.mj_footer.hidden = (self.topics.count == 0);
    return self.topics.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:DMTopicCellId];
    
    DMTopics *topic = self.topics[indexPath.row];
    cell.topic = topic;
    
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}

#pragma mark -代理方法
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取出帖子模型
    DMTopics *topic = self.topics[indexPath.row];
    
    return topic.cellHeight;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DMConmentViewController *cmtVc = [[DMConmentViewController alloc]init];
    cmtVc.topic = self.topics[indexPath.row];
    [self.navigationController pushViewController:cmtVc animated:YES];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
