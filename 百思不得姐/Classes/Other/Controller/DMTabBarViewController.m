//
//  DMTabBarViewController.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/21.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTabBarViewController.h"
#import "DMEssenceViewController.h"
#import "DMNewViewController.h"
#import "DMFriendTrendsViewController.h"
#import "DMMeViewController.h"
#import "DMTabBar.h"
#import "DMNavigationController.h"
@interface DMTabBarViewController ()

@end

@implementation DMTabBarViewController

+ (void)initialize
{
    //添加子控制器
    //通过appearance统一设置所有UITabBarItem的文字属性
    //后面带有UI_APPEARANCE_SELECTOR的方法，都可以通过appearance对象来统一设置
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:12];
    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
    
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSFontAttributeName] = attrs[NSFontAttributeName];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor darkGrayColor];
    
    UITabBarItem *item = [UITabBarItem appearance];
    [item setTitleTextAttributes:attrs forState:UIControlStateNormal];
    [item setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setupChildVc:[[DMEssenceViewController alloc]init] title:@"精华" image:@"tabBar_essence_icon" selectImage:@"tabBar_essence_click_icon"];
    [self setupChildVc:[[DMNewViewController alloc]init] title:@"新帖" image:@"tabBar_new_icon" selectImage:@"tabBar_new_click_icon"];
    [self setupChildVc:[[DMFriendTrendsViewController alloc]init] title:@"关注" image:@"tabBar_friendTrends_icon" selectImage:@"tabBar_friendTrends_click_icon"];
    [self setupChildVc:[[DMMeViewController alloc]initWithStyle:UITableViewStyleGrouped] title:@"我" image:@"tabBar_me_icon" selectImage:@"tabBar_me_click_icon"];
    //更换tabBar kvc readonly比较适合kvc监听
    [self setValue:[[DMTabBar alloc] init] forKeyPath:@"tabBar"];
    
    
    
}



-(void)setupChildVc:(UIViewController *)vc title:(NSString *)title image:(NSString *)image selectImage:(NSString *)selectImage{
    
    //设置文字和图片
    vc.navigationItem.title = title;
    vc.tabBarItem.title = title;
    vc.tabBarItem.image = [UIImage imageNamed:image];
    vc.tabBarItem.selectedImage = [UIImage imageNamed:selectImage];
    //设置图片不被渲染
    //    UIImage *image = [UIImage imageNamed:@"tabBar_essence_click_icon"];
    //    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //包装一个导航控制器，添加导航控制器为tabBarController的子控制器
    DMNavigationController *nav = [[DMNavigationController alloc] initWithRootViewController:vc];
//    [UINavigationBar appearance]
    [nav.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    //添加为子控制器
    [self addChildViewController:nav];
}


@end
