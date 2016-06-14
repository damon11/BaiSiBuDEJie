//
//  DMTabBar.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/21.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTabBar.h"
#import "DMPublishViewController.h"
#import "DMNavigationController.h"

@interface DMTabBar()
@property(nonatomic, weak)UIButton *publishButton;
@end

@implementation DMTabBar

-(instancetype)initWithFrame:(CGRect)frame
{
    if(self){
        self = [super initWithFrame:frame];
        //设置tabBar背景色
        [self setBackgroundImage:[UIImage imageNamed:@"tabbar-light"]];
        //添加发布按钮
        
        UIButton *publishButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [publishButton setBackgroundImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        publishButton.size = publishButton.currentBackgroundImage.size;
        [publishButton addTarget:self action:@selector(publishClick) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:publishButton];
        self.publishButton = publishButton;
    }
    return self;
}
-(void)publishClick{
    DMPublishViewController *pulish = [[DMPublishViewController alloc]init];
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:pulish animated:NO completion:nil];
    
      
}
-(void)layoutSubviews
{
    [super layoutSubviews];

    //也可以用这种添加Button点击事件发送通知
//    static BOOL added = NO;
    
    CGFloat width = self.width;
    CGFloat height = self.height;
    
        //设置发布按钮
//    self.publishButton.width = self.publishButton.currentBackgroundImage.size.width;
//    self.publishButton.height = self.publishButton.currentBackgroundImage.size.height;
    self.publishButton.center = CGPointMake(width * 0.5,height *0.5);
    
    //设置其他UITabBarButton的frame
    CGFloat buttonY = 0;
    CGFloat buttonW = width /5;
    CGFloat buttonH = height;
    NSInteger index = 0;
    
    for(UIControl *button in self.subviews){
//        if(![button isKindOfClass:NSClassFromString(@"UITabBarButton")]) continue;
        if(![button isKindOfClass:[UIControl class]]||button == self.publishButton) continue;
        //设置按钮的x值
        CGFloat buttonX = buttonW * ((index > 1)?(index + 1):index);
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        
        //增加索引
        index++;
//        if(added == NO){
//            //监听按钮点击
//            [button addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
//        }
    }
//    added = YES;
}
//-(void)buttonClick{
//    //发出一个通知
//    [DMNotificationCenter postNotificationName:DMTabBarDidSelectNotification object:nil];
//}
@end
