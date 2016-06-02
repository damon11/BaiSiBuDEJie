//
//  Created by wubangjun on 15/5/11.
//  Copyright (c) 2015年 wubangjun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ESToast.h"

@interface UIViewController (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;
/**
 *  显示一个提示，默认2秒后关闭
 */
- (void)showHint:(NSString *)hint;

/**
 *  显示一个提示
 *
 *  @param hint  提示内容
 *  @param delay 显示时间 秒
 */
- (void)showHint:(NSString *)hint closeAfterDelay:(NSTimeInterval)delay;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

-(void)showToastWithText:(NSString *)text closeAfterDelay:(NSTimeInterval)delay;

@end
