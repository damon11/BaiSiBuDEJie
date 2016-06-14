//
//  DMPublishViewController.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/20.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMPublishViewController.h"
#import "DMVerticalButton.h"
#import <pop.h>
#import "DMPostWordViewController.h"
#import "DMNavigationController.h"
#import "DMLoginTool.h"
static CGFloat const DMAnimationDelay = 0.1;
static CGFloat const DMSpringFactor = 10;
@interface DMPublishViewController ()

@end

@implementation DMPublishViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //让控制器的View不能被点
    self.view.userInteractionEnabled = NO;
    
    //数据
    NSArray *images = @[@"publish-video",@"publish-picture",@"publish-text",@"publish-audio",@"publish-review",@"publish-offline"];
    NSArray *titles = @[@"发视频",@"发图片",@"发段子",@"发声音",@"审帖",@"离线下载"];
    //中间的6个按钮
    int maxCols = 3;
    CGFloat buttonW = 72;
    CGFloat buttonH = buttonW + 30;
    CGFloat buttonStartY = (DMSCREENHEIGTH - 2 * buttonH) * 0.5;
    CGFloat buttonStartX = 25;
    CGFloat xMargin = (DMSCREENWIDTH - 2 * buttonStartX - maxCols *buttonW) / (maxCols - 1);
    for (int i = 0; i < images.count; i++) {
        DMVerticalButton *button = [[DMVerticalButton alloc] init];
        [self.view addSubview:button];
        //设置内容
        button.titleLabel.font = [UIFont systemFontOfSize:14];
        button.tag = i;
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //计算X\Y
        int row = i / maxCols;
        int col = i % maxCols;
        CGFloat buttonX = buttonStartX + col * (xMargin + buttonW);
        CGFloat buttonEndY = buttonStartY + row * (buttonH + 10);
        CGFloat buttonBeginY = buttonEndY - DMSCREENHEIGTH;
        
        //添加动画
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        anim.fromValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonBeginY, buttonW, buttonH)];
        anim.toValue = [NSValue valueWithCGRect:CGRectMake(buttonX, buttonEndY, buttonW, buttonH)];
        anim.springBounciness = 5;
        anim.springSpeed = DMSpringFactor;
        anim.beginTime = CACurrentMediaTime() + 0.1 * (images.count - i);
        [button pop_addAnimation:anim forKey:nil];
        
    }
    
    
    //添加标语
    UIImageView *sloganView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:sloganView];
    
    //标语动画
    POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
    CGFloat centerX = DMSCREENWIDTH * 0.5;
    CGFloat centerEndY = DMSCREENHEIGTH * 0.2;
    CGFloat centerBeginY = centerEndY - DMSCREENHEIGTH;
    sloganView.centerY = centerBeginY;
    sloganView.centerX = centerX;
    anim.fromValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerBeginY)];
    anim.toValue = [NSValue valueWithCGPoint:CGPointMake(centerX, centerEndY)];
    anim.beginTime = CACurrentMediaTime() + images.count * DMAnimationDelay;
    anim.springBounciness = 5;
    anim.springSpeed = DMSpringFactor;
    [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        //标题动画执行完毕，恢复点击事件
        self.view.userInteractionEnabled = YES;
    }];
    [sloganView pop_addAnimation:anim forKey:nil];
}


- (IBAction)cancel:(id)sender {
    [self cancelWithCompletionBlock:nil];
    
}


-(void)cancelWithCompletionBlock:(void(^)())complettionBlock{
    //让控制器的View不能被点击
    self.view.userInteractionEnabled = NO;
    
    int beginIndex = 2;
    
    for (int i = 2; i < self.view.subviews.count; i++) {
        UIView *subview = self.view.subviews[i];
        
        POPBasicAnimation *anim = [POPBasicAnimation animationWithPropertyNamed:kPOPViewCenter];
        CGFloat centerY = subview.centerY + DMSCREENHEIGTH;
        //动画执行节奏（一开始慢 后面快）
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        anim.toValue = [NSValue valueWithCGPoint:CGPointMake(subview.centerX, centerY)];
        anim.beginTime = CACurrentMediaTime() + (i - beginIndex) * DMAnimationDelay;
        [subview pop_addAnimation:anim forKey:nil];
        
        //监听最后一个动画
        if(i == self.view.subviews.count - 1){
            [anim setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
                [self dismissViewControllerAnimated:NO completion:nil];
                //执行传进来的completionBlock参数
                
                !complettionBlock ? :complettionBlock();
            }];
        }
    }

}
-(void)buttonClick:(UIButton *)button{
    [self cancelWithCompletionBlock:^{
        if(button.tag == 0){
            DXLog(@"发视频");
        }else if (button.tag == 1){
            DXLog(@"发图片");
        }else if (button.tag == 2){
//            if([DMLoginTool getUid] == nil) return;
            DMPostWordViewController *postWord = [[DMPostWordViewController alloc] init];
            postWord.view.backgroundColor = [UIColor clearColor];
            DMNavigationController *nav = [[DMNavigationController alloc]initWithRootViewController:postWord];
            //这里不能使用self来弹出其他控制器，因为self执行了dismiss操作
           UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
            [root presentViewController:nav animated:YES completion:nil];
            DXLog(@"发段子");
        }else if (button.tag == 3){
            DXLog(@"发声音");
        }else if (button.tag == 4){
            DXLog(@"审帖");
        }else if (button.tag == 5){
            DXLog(@"离线下载");
        }
    }];
}


/**
 *  pop和Core Animation的区别
 *  1.Core Animation的动画只能添加到layer上
 *  2.pop的动画能添加到任何对象上
 *  3.pop的底层并非基于Core Animation,是基于CADisplayLink
 *  4.Core Animation的动画仅仅是表象，并不会真正的修改对象的frame/size等值
 *  5.pop的动画实时修改对象的属性，真正的修改了对象的属性
 */
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self cancelWithCompletionBlock:nil];
}
@end
