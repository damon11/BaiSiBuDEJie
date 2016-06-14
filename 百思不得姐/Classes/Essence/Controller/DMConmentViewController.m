//
//  DMConmentViewController.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/5/23.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMConmentViewController.h"
#import "DMTopicCell.h"
#import "DMTopics.h"
#import "MJRefresh.h"
#import "AFNetworking.h"
#import "DMComment.h"
#import "DMUser.h"
#import "MJExtension.h"
#import "DMCommentCell.h"
#import "DMShareView.h"
static NSString * const DMCommentId = @"comment";

static NSInteger const DMHeaderLabelTag = 99;
@interface DMConmentViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITextField *textfield;
//底部工具条间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

/** 最热评论 */
@property(nonatomic,strong) NSArray *hotComments;
/** 最新评论 */
@property(nonatomic,strong) NSMutableArray *latestComments;
/** 保存帖子的top_cmt */
@property(nonatomic,strong) DMComment *saved_top_cmt;
/** 保存页码 */
@property(nonatomic,assign) NSInteger page;

/** 管理者 */
@property(nonatomic,strong) AFHTTPSessionManager *manager;
/** 选中的行号 */
@property(nonatomic,strong) NSIndexPath *selected;

/** 分享视图 */
@property(nonatomic,strong) DMShareView *shareViewc;
@end

@implementation DMConmentViewController


-(AFHTTPSessionManager *)manager{
    if(!_manager){
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}


-(DMShareView *)shareViewc{
    if(!_shareViewc){
        _shareViewc = [[DMShareView alloc] init];
        _shareViewc.backgroundColor = [UIColor whiteColor];
        _shareViewc.hidden = YES;
        _shareViewc.userInteractionEnabled = YES;
    }
    return _shareViewc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupBasic];
    
    [self setupHeader];
    
    [self setupRefresh];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if(self.topic.type == DMTopicTypeVideo){
        [DMNotificationCenter postNotificationName:@"videoReset" object:nil];
    }else if(self.topic.type == DMTopicTypeVoice){
        [DMNotificationCenter postNotificationName:@"voiceReset" object:nil];
    }
    
    
}
-(void)setupRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewComment)];
    
    
    //自动改变透明度
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    [self.tableView.mj_header beginRefreshing];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreComment)];
    self.tableView.mj_footer.hidden = YES;
}

-(void)loadNewComment{
    //结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";

    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        if(![responseObject isKindOfClass:[NSDictionary class]]){//说明没有评论数据
            [self.tableView.mj_header endRefreshing];
            return;
        }
            
        
       //最热评论
        self.hotComments = [DMComment mj_objectArrayWithKeyValuesArray:responseObject[@"hot"]];
        
        //最新评论
        self.latestComments = [DMComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        //页码
        self.page = 1;
        
        //刷新数据
        [self.tableView reloadData];
        //结束刷新状态
        [self.tableView.mj_header endRefreshing];
        
        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.tableView scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
        //控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if(self.latestComments.count >= total){//全部加载完毕
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_header endRefreshing];
    }];
}

-(void)loadMoreComment{
    
    //结束之前的所有请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    //页码
    NSInteger page = self.page + 1;
    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"dataList";
    params[@"c"] = @"comment";
    params[@"data_id"] = self.topic.ID;
    params[@"hot"] = @"1";
    params[@"page"] = @(page);
    DMComment *cmt = [self.latestComments lastObject];
    params[@"lastcid"] = cmt.ID;
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        if(![responseObject isKindOfClass:[NSDictionary class]]){//说明没有评论数据
            [self.tableView.mj_footer endRefreshing];
            return;
        }
        //最新评论
        NSArray *newComments = [DMComment mj_objectArrayWithKeyValuesArray:responseObject[@"data"]];
        [self.latestComments addObjectsFromArray:newComments];
        
        //页码
        self.page = page;
        
        //刷新页面
        [self.tableView reloadData];
        
       
        
        //控制footer的状态
        NSInteger total = [responseObject[@"total"] integerValue];
        if(self.latestComments.count >= total){//全部加载完毕
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
        }else{
            //结束刷新状态
            [self.tableView.mj_footer endRefreshing];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.tableView.mj_footer endRefreshing];
    }];
}

-(void)setupHeader{
    
    UIView *header = [[UIView alloc] init];
    
    
    //清空top_cmt
    if(self.topic.top_cmt){
        self.saved_top_cmt = self.topic.top_cmt;
        self.topic.top_cmt = nil;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    
    //添加cell
    DMTopicCell *cell = [DMTopicCell viewFromXib];
    cell.topic = self.topic;
    cell.size = CGSizeMake(DMSCREENWIDTH, self.topic.cellHeight);
    [header addSubview:cell];
    //header的高度
    header.height = self.topic.cellHeight + DMTopicCellMargin;
    
    //设置header
    self.tableView.tableHeaderView = header;
}
-(void)setupBasic{
    
    self.title = @"评论";
    self.navigationItem .rightBarButtonItem = [UIBarButtonItem itemWithImage:@"comment_nav_item_share_icon" highImage:@"comment_nav_item_share_icon_click" target:self action:@selector(shareView)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    //cell的高度 //ios8以上支持此方法
    self.tableView.estimatedRowHeight = 44;//估算高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;//每行自动算高度
    //去分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //背景色
    self.tableView.backgroundColor = DXGlobalBg;
    
    //内边距
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, DMTopicCellMargin, 0);
    
    //注册
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([DMCommentCell class]) bundle:nil] forCellReuseIdentifier:DMCommentId];
}
-(void)keyboardWillChangeFrame:(NSNotification *)note{
    //键盘隐藏完毕的Frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
//    修改底部约束
    self.bottomSpace.constant = DMSCREENHEIGTH - frame.origin.y;
    //动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //动画
    [UIView animateWithDuration:duration animations:^{
        [self.view layoutIfNeeded];
    }];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [DMNotificationCenter postNotificationName:@"removeShareView" object:nil];
    //恢复帖子的top_cmt
    if(self.saved_top_cmt){
        self.topic.top_cmt = self.saved_top_cmt;
        [self.topic setValue:@0 forKey:@"cellHeight"];
    }
    //取消所有任务
    [self.manager invalidateSessionCancelingTasks:YES];
}

-(NSArray *)commentsInSection:(NSInteger)section{
    if(section == 0){
        return self.hotComments.count ? self.hotComments :self.latestComments;
    }
    return self.latestComments;
}

-(DMComment *)commentInIndexPath:(NSIndexPath *)indexPath{
    return [self commentsInSection:indexPath.section][indexPath.row];
}
#pragma mark -<UITableViewDelegate>
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [[UIMenuController sharedMenuController] setMenuVisible:NO animated:YES];

    [self.view endEditing:YES];
    
    [DMNotificationCenter postNotificationName:@"removeShareView" object:nil];
    
}


#pragma mark -<UITableViewDataSource>
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    //隐藏尾部控件
    
    tableView.mj_footer.hidden = !(latestCount == 0);
    
    if(hotCount) return 2;  //有“最热评论”+“最新评论”
    if(latestCount) return 1; //没有“最热评论”,有“最新评论"
    return 0;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger hotCount = self.hotComments.count;
    NSInteger latestCount = self.latestComments.count;
    if(section == 0) {
        return hotCount ?hotCount :latestCount;
    }
    return latestCount;
    
}

//-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    NSInteger hotCount = self.hotComments.count;
//    if(section == 0){
//        return hotCount ? @"最热评论" :@"最新评论";
//    }
//    return @"最新评论";
//}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    static NSString *ID = @"header";
    //先从缓存池中找header
   UITableViewHeaderFooterView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:ID];
    
    UILabel *label = nil;
    
    if(header == nil){//缓存池中没有,自己创建
        header = [[UITableViewHeaderFooterView alloc]initWithReuseIdentifier:ID];
        
        //创建label
        label = [[UILabel alloc] init];
        label.textColor = DXRGBColor(67, 67, 67);
        label.backgroundColor = DXGlobalBg;
        label.width = DMSCREENWIDTH;
        label.x = DMTopicCellMargin;
        label.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        label.tag = DMHeaderLabelTag;
        [header addSubview:label];
        
    }else{//缓存池中取出来的
        label = (UILabel*)[header viewWithTag:DMHeaderLabelTag];
    }
    //设置label的数据
    NSInteger hotCount = self.hotComments.count;
    if(section == 0){
        label.text = hotCount ? @"最热评论" :@"最新评论";
    }else{
        label.text = @"最新评论";
    }
   
    return header;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(nonnull UIView *)view forSection:(NSInteger)section {
    view.tintColor = DXGlobalBg;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:DMCommentId];
    
    cell.comment = [self commentInIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellAccessoryNone;
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIMenuController *menu = [UIMenuController sharedMenuController];
    if(menu.isMenuVisible){
        [menu setMenuVisible:NO animated:YES];
    }else{
        //被点击的cell
        DMCommentCell *cell = (DMCommentCell*)[tableView cellForRowAtIndexPath:indexPath];
        //成为第一响应者
        [cell becomeFirstResponder];
       
        
        UIMenuItem *ding = [[UIMenuItem alloc]initWithTitle:@"顶" action:@selector(ding:)];
        UIMenuItem *replay = [[UIMenuItem alloc]initWithTitle:@"回复" action:@selector(replay:)];
        UIMenuItem *report = [[UIMenuItem alloc]initWithTitle:@"举报" action:@selector(report:)];
//        UIMenuItem *copy = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyText:)];
        menu.menuItems = @[ding,replay,report/*,copy*/];
        CGRect rect = CGRectMake(0, cell.height/2, cell.width, cell.height / 2);
        [menu setTargetRect:rect inView:cell.contentView];
        [menu setMenuVisible:YES animated:YES];

    }
    
}

-(void)shareView{
    
    if(self.shareViewc.isHidden){
       
        DMShareView *shareView = [[DMShareView alloc] init];
        self.shareViewc = shareView;
        [self.shareViewc setHidden:NO];
        [[UIApplication sharedApplication].keyWindow.rootViewController.view addSubview:self.shareViewc];
        self.tableView.userInteractionEnabled = NO;
    }else{
        self.tableView.userInteractionEnabled = YES;
        [DMNotificationCenter postNotificationName:@"removeShareView" object:nil];
    }
}

-(void)ding:(UIMenuController *)menu{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DXLog(@"顶 %@",[self commentInIndexPath:indexPath].content);
    
}
-(void)replay:(UIMenuController *)menu{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DXLog(@"回复 %@ %ld,",[self commentInIndexPath:indexPath].content,indexPath.section);
    
    [self.textfield becomeFirstResponder];
    
    if(self.hotComments.count && !self.latestComments.count){
        DMComment *hotComment = self.hotComments[indexPath.row];
        self.textfield.placeholder = [NSString stringWithFormat:@"回复:%@", hotComment.user.username];
    }else if(self.latestComments.count && !self.hotComments.count){
        DMComment *latestComment = self.latestComments[indexPath.row];
        self.textfield.placeholder = [NSString stringWithFormat:@"回复:%@", latestComment.user.username];
    }else if (self.hotComments.count && self.latestComments.count){
        if(indexPath.section == 0){
            DMComment *hotComment = self.hotComments[indexPath.row];
            
            self.textfield.placeholder = [NSString stringWithFormat:@"回复:%@", hotComment.user.username];
        }else{
            DMComment *latestComment = self.latestComments[indexPath.row];
            self.textfield.placeholder = [NSString stringWithFormat:@"回复:%@",latestComment.user.username];
        }
        
    }
    
}
-(void)report:(UIMenuController *)menu{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    DXLog(@"举报 %@",[self commentInIndexPath:indexPath].content);
}
//- (void)copyText:(UIMenuController *)menu {//复制
//    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
//    UIPasteboard *paste = [UIPasteboard generalPasteboard];
//    paste.string = [self commentInIndexPath:indexPath].content;
//}

@end
