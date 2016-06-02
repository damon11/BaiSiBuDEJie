//
//  DMVerticalButton.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/28.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMVerticalButton.h"

@implementation DMVerticalButton

-(void)setup{
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
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
    self.imageView.x = 0;
    self.imageView.y = 0;
    self.imageView.width = self.width;
    self.imageView.height = self.imageView.width;
    
    //调整文字
    self.titleLabel.x = 0;
    self.titleLabel.y = self.imageView.height;
    self.titleLabel.width = self.width;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
