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
/**
 *  是否关注
 */
@property (nonatomic, assign) BOOL is_follow;
/**
 *  用户id
 */
@property (nonatomic, assign) NSInteger ID;
/**
 *  推荐的用户id
 */
@property (nonatomic, assign) NSInteger uid;
/**
 *  性别
 */
@property (nonatomic, copy) NSString *gender;
/**
 *  个性描述
 */
@property (nonatomic, copy) NSString *introduction;
/**
 *  帖子总数
 */
@property (nonatomic, assign) NSInteger tiezi_count;
/**
 *  是否vip
 */
@property (nonatomic, assign) BOOL is_vip;

@end
