//
//  UIImage+DMExtension.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/1.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "UIImage+DMExtension.h"

@implementation UIImage (DMExtension)
-(UIImage *)circleImage{
    //NO代表透明
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0);
    
    //获得上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    //添加一个圆
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(ctx, rect);
    
    //裁剪
    CGContextClip(ctx);
    
    //将图片画上去
    [self drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

//换肤思路
+(UIImage *)imageWithName:(NSString *)name{
    NSString *dir = [[NSUserDefaults standardUserDefaults] stringForKey:@"SkinDirName"];
    NSString *path = [NSString stringWithFormat:@"Skins/%@/%@",dir,name];
    return [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:path ofType:nil]];
}
@end
