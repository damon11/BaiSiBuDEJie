//
//  DMHomeButton.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/7.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMHomeButton.h"

#define DMRed 0.6
#define DMGreen 0.6
#define DMBlue 0.6
@interface DMHomeButton()

@end
@implementation DMHomeButton
- (instancetype)initWithFrame:(CGRect)frame
{
    
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textColor = [UIColor colorWithRed:DMRed green:DMGreen blue:DMBlue alpha:1.0];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor redColor] forState:UIControlStateDisabled];
        self.titleLabel.font = [UIFont systemFontOfSize:15];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)setScale:(CGFloat)scale{
    
        _scale = scale;
        
        CGFloat red = DMRed + (1 - DMRed) * scale;
        CGFloat green = DMGreen + (0 - DMGreen) * scale;
        CGFloat blue = DMBlue + (0 -  DMBlue) * scale;
        
        [self setTitleColor:[UIColor colorWithRed:red green:green blue:blue alpha:1.0] forState:UIControlStateDisabled];
        
        //大小缩放比例
        CGFloat transformScale = 1 + scale * 0.3;
        self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
    
    
}
@end
