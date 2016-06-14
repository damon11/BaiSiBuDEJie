//
//  DMLoginTool.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/6.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMLoginTool : NSObject
//检测是否登录 NSString:已经登录 nil:没有登录
+(NSString *)getUid;
+(NSString *)getUid:(BOOL)showLoginController;

@end
