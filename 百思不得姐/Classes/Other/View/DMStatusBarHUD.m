//
//  DMStatusBarHUD.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/22.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMStatusBarHUD.h"
//消息停留时间
static CGFloat const DMMessageDuration = 2.0;
//消息显示/隐藏的动画时间
static CGFloat const DMAnimationDuration = 0.25;
@implementation DMStatusBarHUD
//全局窗口
static UIWindow *window_;
//定时器对象
static NSTimer *timer_;
/**
 *  初始化窗口
 */
+(void)setupWindow{
    //显示窗口
    CGFloat windowH = 20;
    CGRect frame = CGRectMake(0, -windowH, DMSCREENWIDTH, windowH);
    
    //显示窗口
    window_.hidden = YES;
    window_ = [[UIWindow alloc] init];
    window_.backgroundColor = [UIColor blackColor];
    window_.windowLevel = UIWindowLevelAlert;
    window_.frame = frame;
    window_.hidden = NO;
    
    //动画
    frame.origin.y = 0;
    [UIView animateWithDuration:DMAnimationDuration animations:^{
        window_.frame = frame;
    }];
}
+(void)showSuccess:(NSString *)msg{
    [self showMessage:msg image:[UIImage imageNamed:@"success"]];
    
}

+(void)showError:(NSString *)msg{
    [self showMessage:msg image:[UIImage imageNamed:@"error"]];
    
}

+(void)showMessage:(NSString *)msg{
    [self showMessage:msg image:nil];
}

+(void)showMessage:(NSString *)msg image:(UIImage *)image{
  
    //停止定时器
    [timer_ invalidate];
    
    [self setupWindow];
    //添加按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:msg forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    if(image){
        [button setImage:image forState:UIControlStateNormal];
         button.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    }

    button.frame = window_.bounds;
    [window_ addSubview:button];
    
    //定时消失
    timer_ = [NSTimer scheduledTimerWithTimeInterval:DMMessageDuration target:self selector:@selector(hide) userInfo:nil repeats:NO];
}



+(void)showLoading:(NSString *)msg{
    
    //停止定时器
    [timer_ invalidate];
    timer_ = nil;
    
    [self setupWindow];
    
    //添加文字
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.frame = window_.bounds;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = msg;
    label.textColor = [UIColor whiteColor];
    [window_ addSubview:label];
    
    //添加圈圈
    UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [loadingView startAnimating];
    CGFloat msgW = [msg sizeWithAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:12]}].width;
    CGFloat centerX = (window_.frame.size.width - msgW) * 0.5 - 20;
    CGFloat centerY = window_.frame.size.height * 0.5;
    loadingView.center = CGPointMake(centerX, centerY);
    [window_ addSubview:loadingView];
}

+(void)hide{
    [UIView animateWithDuration:DMAnimationDuration animations:^{
        CGRect frame = window_.frame;
        frame.origin.y = -frame.size.height;
        window_.frame = frame;
    } completion:^(BOOL finished) {
        window_ = nil;
        timer_ = nil;
    }];
   
}
@end
