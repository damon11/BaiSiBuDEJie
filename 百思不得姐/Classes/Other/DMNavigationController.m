//
//  DMNavigationController.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/22.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMNavigationController.h"

@implementation DMNavigationController
/**
 *  第一次使用这个类的时候调一次
 */
+(void)initialize
{
    //当导航栏用在DMNavgationController中，appearance设置才会生效
//    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:[self class], nil];
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:@{NSFontAttributeName: [UIFont boldSystemFontOfSize:20]}];
    
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    //UIControlStateNormal
    NSMutableDictionary *itemAttrs = [NSMutableDictionary dictionary];
    itemAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    itemAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
    [item setTitleTextAttributes:itemAttrs forState:UIControlStateNormal];
    //UIControlStateDisabled
    NSMutableDictionary *itemDisabledAttrs = [NSMutableDictionary dictionary];
    itemDisabledAttrs[NSForegroundColorAttributeName] = [UIColor lightGrayColor];
    [item setTitleTextAttributes:itemDisabledAttrs forState:UIControlStateDisabled];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


/**
 *  可以在这个方法中拦截所有push进来的控制器
 */
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if(self.childViewControllers.count > 0){//如果push进来的不是第一个控制器
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:@"返回" forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"navigationButtonReturn"] forState:UIControlStateNormal];
        [button setImage: [UIImage imageNamed:@"navigationButtonReturnClick"] forState:UIControlStateHighlighted];
        button.size = CGSizeMake(100, 30);
        button.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
//        button.contentMode = UIViewContentModeLeft;//imageview用起来好
        button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        [button sizeToFit];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:button];
        //隐藏tabBar
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //这句super的push要放在后面,让viewController可以覆盖上面的leftBarBtutonItem
    [super pushViewController:viewController animated:animated];
}

-(void)back{
    
    [self popViewControllerAnimated:YES];
    
}
@end
