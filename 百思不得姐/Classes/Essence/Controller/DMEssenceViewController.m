//
//  DMEssenceViewController.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/21.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMEssenceViewController.h"
#import "DMRecommendTagsViewController.h"
#import "DMTopicViewController.h"
#import "DMHomeButton.h"
#import "DMRecommendUserViewController.h"


@interface DMEssenceViewController ()<UIScrollViewDelegate>
/**
 *  标签栏底部的红色指示器
 */
@property (nonatomic, weak) UIView *indicatorView;
/**
 *  当前选中的按钮
 */
@property (nonatomic, weak) DMHomeButton *selecedButton;
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
@end

@implementation DMEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航栏
    [self setupNav];
    //添加子控制器
    [self setupChildVces];
    //设置顶部标签栏
    [self setupTitleView];
    //底部的scroll
    [self setupContentView];
    
  
    
}

-(void)tagClick
{
    DMRecommendTagsViewController *tags = [[DMRecommendTagsViewController alloc]init];
    [self.navigationController pushViewController:tags animated:YES];
    
    

}
/**
 *  添加子控制器
 */
-(void)setupChildVces{
    DMTopicViewController *all = [[DMTopicViewController alloc]init];
    all.title = @"全部";
    all.type = DMTopicTypeAll;
    [self addChildViewController:all];
    DMTopicViewController *video = [[DMTopicViewController alloc]init];
    video.title = @"视频";
    video.type = DMTopicTypeVideo;
    [self addChildViewController:video];
    DMTopicViewController *voice = [[DMTopicViewController alloc]init];
    voice.title = @"声音";
    voice.type = DMTopicTypeVoice;
    [self addChildViewController:voice];
    DMTopicViewController *pictuer = [[DMTopicViewController alloc]init];
    pictuer.title = @"图片";
    pictuer.type = DMTopicTypePicture;
    [self addChildViewController:pictuer];
    DMTopicViewController *word = [[DMTopicViewController alloc]init];
    word.title = @"段子";
    word.type = DMTopicTypeWord;
    [self addChildViewController:word];
}
/**
 *  //设置导航栏内容
 */
-(void)setupNav{

    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"MainTagSubIcon" highImage:@"MainTagSubIconClick" target:self action:@selector(tagClick)];
    
    self.view.backgroundColor = DXGlobalBg;
}
/**
 *  设置顶部标签栏
 */
-(void)setupTitleView{
    
    //标签栏整体
    UIScrollView *titlesView = [[UIScrollView alloc]init];
//    titlesView.backgroundColor = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:0.7];
    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
    titlesView.width = self.view.width;
    titlesView.height = DMTitleViewH;
    titlesView.y = DMTitleViewY;
    titlesView.showsHorizontalScrollIndicator = NO;
    titlesView.alwaysBounceHorizontal = YES;
    [self.view addSubview:titlesView];
    self.titlesView = titlesView;
//    UIScrollView *titlesView = [[UIScrollView alloc]init];
//    titlesView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.7];
//    titlesView.contentSize =
    
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
/**
 *  设置
 */
-(void)setupContentView{
    //不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc]init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.pagingEnabled = YES;
    contentView.scrollsToTop = NO;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(DMSCREENWIDTH * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    //默认显示第0个子控制器
    [self scrollViewDidEndScrollingAnimation:contentView];
//    contentView.width = self.view.width;
//    contentView.y = 99;
//    contentView.height = self.view.height - contentView.y - self.tabBarController.tabBar.height;
//    contentView.contentInset = UIEdgeInsetsMake(99, 0, 49, 0);
//    [self.view addSubview:contentView];
//    
//    contentView.contentSize = CGSizeMake(0, 800);
}

-(void)titleClick:(DMHomeButton *)button{
    self.selecedButton.enabled = YES;
    button.enabled = NO;
    self.selecedButton = button;
    //动画
//    [UIView animateWithDuration:0.25 animations:^{
//        self.indicatorView.width = button.titleLabel.width;
//        self.indicatorView.centerX = button.centerX;
//    }];
    
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
    vc.tableView.height = scrollView.height;
    
    //设置内边距
    CGFloat bottom = self.tabBarController.tabBar.height;
    CGFloat top = CGRectGetMaxY(self.titlesView.frame);
    vc.tableView.contentInset = UIEdgeInsetsMake(top, 0, bottom, 0);
    //滚动条的内边距
    vc.tableView.scrollIndicatorInsets = vc.tableView.contentInset;
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
//      R G B
//黑色   0 0 0
//红色   1 0 0
//蓝色   0 0 1
//黄色   1 1 0
@end
