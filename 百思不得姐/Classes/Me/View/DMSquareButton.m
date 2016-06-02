//
//  DMSquareButton.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/1.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMSquareButton.h"
#import "DMSquare.h"
#import "UIButton+WebCache.h"
@implementation DMSquareButton

-(void)setup{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont systemFontOfSize:15];
    [self setBackgroundImage:[UIImage imageNamed:@"mainCellBackground"] forState:UIControlStateNormal];
}

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

-(void)awakeFromNib{
    [self setup];
}

/*
 -(void)layoutSubviews
 {
 [super layoutSubviews];
 //调整图片
 self.imageView.x = 0;
 self.imageView.y = 0;
 
 //调整文字
 self.titleLabel.x = 0;
 self.titleLabel.y = self.imageView.height;
 self.titleLabel.width = self.width;
 }
 */
//建议用下面这种 上面那种只适合用Xib或者确认好图片的button
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    //调整图片
    self.imageView.y = self.height * 0.2;
    self.imageView.width = self.width * 0.5;
    self.imageView.height = self.imageView.width;
    self.imageView.centerX = self.width * 0.5;
    
    //调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}
-(void)setSquare:(DMSquare *)square{
    _square = square;
    [self setTitle:square.name forState:UIControlStateNormal];
    [self sd_setImageWithURL:[NSURL URLWithString:square.icon] forState:UIControlStateNormal];
}
@end
