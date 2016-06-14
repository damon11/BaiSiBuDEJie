//
//  DMTagButton.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/3.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTagButton.h"

@implementation DMTagButton

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleLabel.font = DMTagFont;
        self.backgroundColor = DMTagBg;
        [self setImage:[UIImage imageNamed:@"chose_tag_close_icon"] forState:UIControlStateNormal];
    }
    return self;
}

-(void)setTitle:(NSString *)title forState:(UIControlState)state{
    
    [super setTitle:title forState:state];
    
    [self sizeToFit];
    
    self.width += 3 * DMTagMargin;
    //在sizeToFit方法自动算完之后设置高度 防止高度被重新计算
    self.height = DMTagH;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.titleLabel.x = DMTagMargin;
    self.imageView.x = CGRectGetMaxX(self.titleLabel.frame) + DMTagMargin;
}
@end
