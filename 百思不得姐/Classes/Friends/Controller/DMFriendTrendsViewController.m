//
//  DMFriendTrendsViewController.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/21.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMFriendTrendsViewController.h"
#import "DMRecommendViewController.h"
#import "DMLoginRegisterController.h"
@interface DMFriendTrendsViewController ()

@end

@implementation DMFriendTrendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航栏
    //self.title = @"我的关注";//会影响导航栏和tabbar的title
    
    self.navigationItem.title = @"我的关注";

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithImage:@"friendsRecommentIcon" highImage:@"friendsRecommentIcon-click" target:self action:@selector(friendsClick)];
    
    self.view.backgroundColor = DXGlobalBg;
    DXLogFunc;
}

-(void)friendsClick
{
    DMRecommendViewController *vc = [[DMRecommendViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)loginReigister:(id)sender {
    DMLoginRegisterController *vc = [[DMLoginRegisterController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}
@end
