//
//  DMStatusBarHUD.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/22.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMStatusBarHUD : NSObject
/**
 *  显示成功信息
 */
+(void)showSuccess:(NSString *)msg;
/**
 *  显示失败信息
 */
+(void)showError:(NSString *)msg;
/**
 *  显示普通信息
 */
+(void)showMessage:(NSString *)msg;
/**
 *  显示普通信息和图片
 */
+(void)showMessage:(NSString *)msg image:(UIImage *)image;
/**
 *  显示正在处理信息
 */
+(void)showLoading:(NSString *)msg;
/**
 *  隐藏
 */
+(void)hide;
@end
