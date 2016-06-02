//
//  DMUser.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/22.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMUser : NSObject
/**
 *  用户名
 */
@property (nonatomic, copy) NSString *username;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *sex;
/**
 *  头像
 */
@property (nonatomic, copy) NSString *profile_image;
@end
