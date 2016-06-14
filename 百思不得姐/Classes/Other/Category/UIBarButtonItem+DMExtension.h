//
//  UIBarButtonItem+DMExtension.h
//  百思不得姐
//
//  Created by JD_Mac on 16/3/22.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (DMExtension)
+(instancetype)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
