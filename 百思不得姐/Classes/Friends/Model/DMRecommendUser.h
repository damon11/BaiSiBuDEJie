//
//  DMRecommendUser.h
//  百思不得姐
//
//  Created by JD_Mac on 16/3/23.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DMRecommendUser : NSObject
/**
 *  头像
 */
@property (nonatomic, copy) NSString *header;
/**
 *  粉丝数（有多少人关注这个用户）
 */
@property (nonatomic, assign) NSInteger fans_count;
/**
 *  昵称
 */
@property (nonatomic, copy) NSString *screen_name;
@end
