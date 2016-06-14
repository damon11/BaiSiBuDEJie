//
//  DMRecommendUserViewController.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/8.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMRecommendUserViewController.h"
#import "DMConmentViewController.h"
#import "DMTopicCell.h"
#import "DMHomeButton.h"
#import "DMTopicViewController.h"
#import "AFNetworking.h"
#import "DMRecommendUser.h"
#import "MJExtension.h"
#import "MJRefresh.h"
@interface DMRecommendUserViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) DMRecommendUser *user;
/**
 *  标签栏底部的红色指示器
 */
@property (nonatomic, weak) UIView *indicatorView;
/**
 *  当前选中的按钮
 */
@property (nonatomic, weak) DMHomeButton *selecedButton;
/**
 *  控制器背景
 */
@property (nonatomic, weak) UIScrollView *backScrollView;
/**
 *  顶部所有标签
 */
@property (nonatomic, weak) UIScrollView *titlesView;
/**
 *  底部的所有内容
 */
@property (nonatomic, weak) UIScrollView *contentView;
/** buttonarray */
@property(nonatomic,strong) NSMutableArray *buttonArr;
/** header背景View */
@property(nonatomic,weak) UIView *headerView;
/** labelY */
@property(nonatomic,assign) CGFloat labelY;
/** 背景图片 */
@property(nonatomic,weak) UIImageView *backView;
@end



@implementation DMRecommendUserViewController


-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self loadUser];
    
    [self setupScrollView];
    
    [self setupHeader];
    
    [self setupChildView];
    
    [self setupTitleView];
    
    [self setupContentView];
}



-(void)setupScrollView{
    self.title = @"推荐关注用户";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor grayColor];
    UIScrollView *backScrollView = [[UIScrollView alloc] init];
    backScrollView.width = self.view.width;
    backScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(240, 0, 0, 0);
    backScrollView.delegate =self;
    backScrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    backScrollView.height = DMSCREENHEIGTH + 261;
    backScrollView.contentSize = CGSizeMake(DMSCREENWIDTH, DMSCREENHEIGTH * 15 - self.tabBarController.tabBar.height - 261);
    backScrollView.y = -174;
    backScrollView.backgroundColor = DXGlobalBg;
    backScrollView.alwaysBounceVertical = YES;
    [self.view addSubview:backScrollView];
    self.backScrollView = backScrollView;
 
}


-(void)setupChildView{
    DMTopicViewController *tiezi = [[DMTopicViewController alloc]init];
    tiezi.title = @"帖子";
    [self addChildViewController:tiezi];
    DMTopicViewController *fenxiang = [[DMTopicViewController alloc]init];
    fenxiang.title = @"分享";
    [self addChildViewController:fenxiang];
    DMTopicViewController *pinglun = [[DMTopicViewController alloc]init];
    pinglun.title = @"评论";
    [self addChildViewController:pinglun];
}

-(void)setupHeader{
    //header大背景
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    header.frame = CGRectMake(0, 0, DMSCREENWIDTH, 523);
    self.headerView = header;
    UIView *backV = [[UIView alloc] init];
    backV.frame = CGRectMake(0, 0, DMSCREENWIDTH, 523);
    backV.backgroundColor = [UIColor clearColor];
    
    
    //图片背景
    UIImageView *backView = [[UIImageView alloc] init];
    backView.userInteractionEnabled = YES;
    backView.backgroundColor = [UIColor grayColor];
    backView.image = [UIImage imageNamed:@"pushguidemid"];
    backView.frame = CGRectMake(0, 0, DMSCREENWIDTH, 400);
    self.backView = backView;
    UIView *backImgV = [[UIView alloc] init];
    backImgV.frame = CGRectMake(0, 0, DMSCREENWIDTH, 400);
   
    
    
    //右侧点赞按钮
    UIButton *zanBtn = [[UIButton alloc] init];

    zanBtn.frame = CGRectMake(DMSCREENWIDTH - 80, 250, 70, 25);
    zanBtn.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    [zanBtn addTarget:self action:@selector(zanBtnClick) forControlEvents:UIControlEventTouchUpInside];
    zanBtn.layer.cornerRadius = zanBtn.height/2;
    zanBtn.layer.masksToBounds = YES;
    zanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    zanBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [zanBtn setTitle:@"639" forState:UIControlStateNormal];
    [zanBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [zanBtn setImage:[UIImage imageNamed:@"commentLikeButtonClick"] forState:UIControlStateNormal];

    //关注按钮
    UIButton *GzBtn = [[UIButton alloc] init];
    GzBtn.userInteractionEnabled = YES;
    GzBtn.frame = CGRectMake(DMSCREENWIDTH - 80, backView.height - 25 - 20, 70, 25);
    GzBtn.backgroundColor = [UIColor whiteColor];
    GzBtn.layer.cornerRadius = 3.0f;
    GzBtn.layer.masksToBounds = YES;
    GzBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//    GzBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 5, 0, 0);
    [GzBtn setTitle:@"关注" forState:UIControlStateNormal];
    [GzBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [GzBtn setImage:[UIImage imageNamed:@"commentLikeButtonClick"] forState:UIControlStateNormal];
    //头像
    UIImageView *headerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"header_cry_icon"]];
    headerView.center = CGPointMake(30+15, backView.height);
    headerView.layer.cornerRadius = headerView.height/2;
    headerView.layer.masksToBounds = YES;
    headerView.layer.borderWidth = 0.5;
    headerView.layer.borderColor = [UIColor lightGrayColor].CGColor;\
    //性别图标
    UIImageView *sexView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Profile_manIcon"]];
    sexView.frame = CGRectMake(CGRectGetMaxX(headerView.frame)+10, CGRectGetMinY(headerView.frame)+3, 15, 15);
    //昵称
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.frame = CGRectMake(CGRectGetMaxX(sexView.frame) + 10, sexView.y, 200, 15);
    nameLabel.text = @"DAMON";
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.font = [UIFont systemFontOfSize:13];
    
    //等级
    UILabel *DJLabel = [[UILabel alloc] init];
    DJLabel.frame = CGRectMake(sexView.x, backView.height + 7, 30, 15);
    DJLabel.text = @"等级:";
    DJLabel.textColor = [UIColor grayColor];
    DJLabel.font = [UIFont systemFontOfSize:13];
    //等级数据
    UILabel *DJLabelStr = [[UILabel alloc] init];
    DJLabelStr.frame = CGRectMake(CGRectGetMaxX(DJLabel.frame)+2, backView.height + 7, 200, 15);
    DJLabelStr.text = @"LV1";
    DJLabelStr.textColor = [UIColor grayColor];
    DJLabelStr.font = [UIFont systemFontOfSize:13];
    
    //积分
    UILabel *JFLabel = [[UILabel alloc] init];
    JFLabel.frame = CGRectMake(sexView.x, CGRectGetMaxY(DJLabel.frame) + 5, 30, 15);
    JFLabel.text = @"积分:";
    JFLabel.textColor = [UIColor grayColor];
    JFLabel.font = [UIFont systemFontOfSize:13];
    //积分数据
    UILabel *JFLabelStr = [[UILabel alloc] init];
    JFLabelStr.frame = CGRectMake(CGRectGetMaxX(JFLabel.frame)+2, CGRectGetMaxY(DJLabel.frame) + 5, 200, 15);
    JFLabelStr.text = @"1200";
    JFLabelStr.textColor = [UIColor grayColor];
    JFLabelStr.font = [UIFont systemFontOfSize:13];
    //关注数据
    UILabel *GZLabelStr = [[UILabel alloc] init];
    GZLabelStr.frame = CGRectMake(CGRectGetMinX(GzBtn.frame)-10, backView.height + 7, 30, 15);
    GZLabelStr.text = @"1";
    GZLabelStr.textAlignment = NSTextAlignmentCenter;
    GZLabelStr.textColor = [UIColor lightGrayColor];
    GZLabelStr.font = [UIFont systemFontOfSize:12];
    //关注
    UILabel *GZLabel = [[UILabel alloc] init];
    GZLabel.frame = CGRectMake(GZLabelStr.x, CGRectGetMaxY(GZLabelStr.frame) + 5, 30, 15);
    GZLabel.text = @"关注";
    GZLabel.textAlignment = NSTextAlignmentCenter;
    GZLabel.textColor = [UIColor grayColor];
    GZLabel.font = [UIFont systemFontOfSize:12];
    //间隔线
    UILabel *line = [[UILabel alloc] init];
    line.frame = CGRectMake(CGRectGetMaxX(GZLabel.frame)+10, backView.height + 7, 1, CGRectGetMaxY(GZLabel.frame)-CGRectGetMinY(GZLabelStr.frame));
    line.backgroundColor = [UIColor lightGrayColor];

    //粉丝数据
    UILabel *FSLabelStr = [[UILabel alloc] init];
    FSLabelStr.frame = CGRectMake(CGRectGetMaxX(line.frame)+10, backView.height + 7, 30, 15);
    FSLabelStr.text = @"200";
    FSLabelStr.textAlignment = NSTextAlignmentCenter;
    FSLabelStr.textColor = [UIColor lightGrayColor];
    FSLabelStr.font = [UIFont systemFontOfSize:12];
    //粉丝
    UILabel *FSLabel = [[UILabel alloc] init];
    FSLabel.frame = CGRectMake(FSLabelStr.x, CGRectGetMaxY(FSLabelStr.frame) + 5, 30, 15);
    FSLabel.text = @"粉丝";
    FSLabel.textAlignment = NSTextAlignmentCenter;
    FSLabel.textColor = [UIColor grayColor];
    FSLabel.font = [UIFont systemFontOfSize:12];
    
    
    for(int i= 0; i<3;i++){
        UILabel *TZlabel = [[UILabel alloc] init];
        TZlabel.frame = CGRectMake((DMSCREENWIDTH-30)/3*0.5-10+((DMSCREENWIDTH-30)/3+10)*i, CGRectGetMaxY(JFLabel.frame)+20, 30, 20);
        TZlabel.textAlignment = NSTextAlignmentCenter;
        TZlabel.text = [NSString stringWithFormat:@"%d",i];
        self.labelY = CGRectGetMaxY(TZlabel.frame);
        [header addSubview:TZlabel];
    }
    
    
    
    [backV addSubview:JFLabel];
    [backV addSubview:DJLabel];
    [backV addSubview:DJLabelStr];
    [backV addSubview:JFLabelStr];
    [backV addSubview:GZLabelStr];
    [backV addSubview:GZLabel];
    [backV addSubview:line];
    [backV addSubview:FSLabelStr];
    [backV addSubview:FSLabel];
    [backV addSubview:nameLabel];
    [backV addSubview:sexView];
    [backV addSubview:headerView];
    [backV addSubview:GzBtn];
    [backV addSubview:zanBtn];
    [backImgV addSubview:backView];
    [header addSubview:backImgV];
    [header addSubview:backV];
    [self.backScrollView addSubview:header];
}

-(void)loadUser{
    

    //参数
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"a"] = @"friend_recommend";
    params[@"c"] = @"user";
    
    //发送请求
    [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * task, id responseObject) {


        //下拉刷新 直接覆盖就行
        self.user = [DMRecommendUser mj_objectWithKeyValues:responseObject[@"top_list"]];
        
   
    } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
       
    }];
}



/**
 *  设置顶部标签栏
 */
-(void)setupTitleView{
    
    //标签栏整体
    UIScrollView *titlesView = [[UIScrollView alloc]init];
    //    titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    [titlesView setBackgroundColor:[UIColor whiteColor]];
    titlesView.width = self.view.width;
    titlesView.height = DMTitleViewH;
    titlesView.y = self.labelY+5;
    titlesView.showsHorizontalScrollIndicator = NO;
    titlesView.alwaysBounceHorizontal = YES;
    [self.headerView addSubview:titlesView];
    
    self.titlesView = titlesView;
    
    //底部的红色指示器
    UIView *indicatorView = [[UIView alloc] init];
    indicatorView.backgroundColor = [UIColor redColor];
    indicatorView.height = 2;
    indicatorView.tag = -1;
    indicatorView.y = titlesView.height - indicatorView.height;
    
    self.indicatorView = indicatorView;
    
    
    //    //内部子标签
    //    NSArray *titles = @[@"全部",@"视频",@"声音",@"图片",@"段子"];
    CGFloat width = INDICATORWIDTH;
    CGFloat height = titlesView.height;
    for(NSInteger i = 0; i < self.childViewControllers.count/*titles.count*/; i++){
        DMHomeButton *button = [[DMHomeButton alloc] init];
        button.tag = i;
        button.height = height;
        button.width = width;
        button.x = i * width;
        [button setTitle:self.childViewControllers[i].title/*titles[i]*/ forState:UIControlStateNormal];
        //        [button layoutIfNeeded];//强制布局(强制更新子控件frame)
        
        [button addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
        [titlesView addSubview:button];
        [self.buttonArr addObject:button];
        if(i == 0){
            button.enabled = NO;
            //设置缩放比例
            button.scale = 1.0;
            self.selecedButton = button;
            //根据文字内容适应宽度
            [button.titleLabel sizeToFit];
            self.indicatorView.width = button.titleLabel.width;
            self.indicatorView.centerX = button.centerX;
        }
    }
    [titlesView addSubview:indicatorView];
    self.titlesView.contentSize = CGSizeMake(self.childViewControllers.count/*titles.count*/ * width, 0);
    
}



-(void)setupContentView{
    //不要自动调整inset
//    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = CGRectMake(0, CGRectGetMaxY(self.headerView.frame), DMSCREENWIDTH, DMSCREENHEIGTH*15);
    contentView.backgroundColor = [UIColor whiteColor];
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.scrollsToTop = NO;
    
//    [self.view insertSubview:contentView atIndex:0];
    [self.backScrollView addSubview:contentView];
    contentView.contentSize = CGSizeMake(DMSCREENWIDTH * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    //默认显示第0个子控制器
    [self scrollViewDidEndScrollingAnimation:contentView];
   
}


-(void)titleClick:(DMHomeButton *)button{
    self.selecedButton.enabled = YES;
    button.enabled = NO;
    self.selecedButton = button;

    
    //contentView滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x =  button.tag * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
    
    
    //让其他label回到最初状态
    for(DMHomeButton *otherButton in self.buttonArr){
        if(otherButton != button)
            otherButton.scale = 0.0;
    }
    
    
    
    //让对应标题居中
    CGPoint titleOffset = self.titlesView.contentOffset;
    titleOffset.x = button.centerX - self.contentView.width * 0.5;
    //左边超出处理
    if(titleOffset.x < 0) titleOffset.x = 0;
    //右边超出处理
    CGFloat maxTitleOffsetX = self.titlesView.contentSize.width - self.titlesView.width;
    if(titleOffset.x > maxTitleOffsetX) titleOffset.x = maxTitleOffsetX;
    
    [self.titlesView setContentOffset:titleOffset animated:YES];
    
}


#pragma mark -<UIScrollViewDelegate>
//结束的滚动动画以后会调用此方法（比如-（void）setContentOffset:(CGPoint)contentOffset animated:(BOOL)animated;方法执行的动画完毕后）
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    //添加子控件的View
    
    
    //当前的索引
    NSInteger index = scrollView.contentOffset.x /scrollView.width;
    
    
    //取出子控制器
    UITableViewController *vc = self.childViewControllers[index];
    
    //如果当前位置已经显示过了，就直接返回
    if([vc isViewLoaded]) return;
    
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0;
    vc.view.backgroundColor = DXGlobalBg;
    vc.tableView.height = scrollView.height ;
    vc.tableView.contentInset = UIEdgeInsetsZero;
    vc.tableView.showsVerticalScrollIndicator = NO;
    vc.tableView.scrollEnabled = NO;
    [scrollView addSubview:vc.view];
}
/**
 *  停止减速，手指松开scrollView后，停止减速完毕后会调用这个方法
 */
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self scrollViewDidEndScrollingAnimation:scrollView];
    
    //点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:self.titlesView.subviews[index]];
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}

/**
 *  只要ScrollView在滚动，就会调用
 */
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView == self.backScrollView){
    CGFloat offsetY = scrollView.contentOffset.y;
        DXLog(@"%f",offsetY);
        if(offsetY < 0){
            CGFloat scale = 1 - (offsetY / 70);
            self.backView.transform = CGAffineTransformMakeScale(scale, scale);
        }
    
    
        
}
    if(scrollView == self.contentView){
    CGFloat scale = scrollView.contentOffset.x /scrollView.width;
    if (scale < 0 || scale > self.titlesView.subviews.count - 3) return;
    
    //整数部分              //小数部分
    NSInteger leftIndex = scale;
    DMHomeButton *leftButton = self.titlesView.subviews[leftIndex];
    
    //根据实时滚动设置指示器的位置
    CGFloat titleLabelx = CGRectGetMinX(leftButton.titleLabel.frame);
    float xx = scrollView.contentOffset.x * (INDICATORWIDTH/DMSCREENWIDTH)+titleLabelx;
    [self.indicatorView setX:xx];
    
    
    NSInteger rightIndex = leftIndex + 1;
    //titlesView包含5个button 1个UIView 1个ImageView
    DMHomeButton *rightButton = (rightIndex == self.titlesView.subviews.count-2) ? nil :self.titlesView.subviews[rightIndex];
    
    //右边比例
    CGFloat rightScale = scale - leftIndex;
    //左边比例
    CGFloat leftScale = 1 - rightScale;
    
    //设置button的比例
    leftButton.scale = leftScale;
    rightButton.scale = rightScale;
    }
}



-(void)zanBtnClick{
    DXLog(@"ZAN");
}


@end
