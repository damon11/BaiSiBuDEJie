//
//  DMShareView.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/7.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMShareView.h"
@interface DMShareView()
/** 分享视图 */
@property(nonatomic,weak) UIView *shareBackView;
/** 分享视图背景 */
@property(nonatomic,weak) UIView *backView;
@end
@implementation DMShareView


- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        UIView *shareBackView = [[UIView alloc] init];
        shareBackView.backgroundColor = [UIColor whiteColor];
        
        UIView *backView = [[UIView alloc] init];
        backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        self.backView = backView;
        [self.backView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeShareView)]];
        [self.backView addSubview:shareBackView];
        [self addSubview:self.backView];
        self.shareBackView = shareBackView;
        [DMNotificationCenter addObserver:self selector:@selector(removeShareView) name:@"removeShareView" object:nil];
    }
    return self;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.shareBackView.width = DMSCREENWIDTH;
    self.shareBackView.height = 300;
    self.shareBackView.x = 0;
    self.shareBackView.y = DMSCREENHEIGTH;
    self.backView.width = DMSCREENWIDTH;
    self.backView.height = DMSCREENHEIGTH;
    self.backView.x = 0;
    self.backView.y = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.shareBackView.y = DMSCREENHEIGTH - self.shareBackView.height;
        self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    }];
   
    
}

-(void)removeShareView{
    [UIView animateWithDuration:0.2 animations:^{
        self.shareBackView.y = DMSCREENHEIGTH;
        self.backView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    } completion:^(BOOL finished) {
        self.hidden = YES;
        [self removeFromSuperview];
    }];
}

-(void)creatShareButton{
    
}


-(void)dealloc{
    [DMNotificationCenter removeObserver:self];
}

@end
