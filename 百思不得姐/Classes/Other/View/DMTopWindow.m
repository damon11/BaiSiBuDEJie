//
//  DMTopWindow.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/5/31.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTopWindow.h"

@implementation DMTopWindow

static UIWindow *window_;

+(void)initialize{
    window_ = [[UIWindow alloc]init];
    window_.frame = CGRectMake(0, 0, DMSCREENWIDTH, 20);
    window_.windowLevel = UIWindowLevelAlert;
    [window_ addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(windowClick)]];
    window_.backgroundColor = [UIColor clearColor];
}
     
+(void)show{
         
     window_.hidden = NO;
}

+(void)hide{
     window_.hidden = YES;
}
     //监听窗口点击
+(void)windowClick{
//    1.scrollview
//    2.keywindow
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [self searchScrollViewInView:window];
    
}
+ (void)searchScrollViewInView:(UIView *)superview{
    
         for(UIScrollView *subview in superview.subviews){
         
           
             //如果是scrollview，滚动最顶部
             if([subview isKindOfClass:[UIScrollView class]] && subview.isShowingOnWindow){
                 CGPoint offset = subview.contentOffset;
                 offset.y = - subview.contentInset.top;
                 [subview setContentOffset:offset animated:YES];
             }
             //继续查找子控件
              [self searchScrollViewInView:subview];
         }
   
}
    
@end
