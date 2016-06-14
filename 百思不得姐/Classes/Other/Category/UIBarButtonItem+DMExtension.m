//
//  UIBarButtonItem+DMExtension.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/22.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "UIBarButtonItem+DMExtension.h"

@implementation UIBarButtonItem (DMExtension)
+(instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    button.size = button.currentBackgroundImage.size;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return [[self alloc] initWithCustomView:button];
}
@end
