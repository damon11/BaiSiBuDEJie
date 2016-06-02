//
//  DMRecommendCategory.h
//  百思不得姐
//
//  Created by JD_Mac on 16/3/23.
//  Copyright © 2016年 Damon. All rights reserved.
//  推荐关注左边模型

#import <Foundation/Foundation.h>

@interface DMRecommendCategory : NSObject

@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, copy) NSString *name;

//这个类对应的用户数据
@property (nonatomic, strong) NSMutableArray *users;

@property (nonatomic, assign) NSInteger total_page;
@property (nonatomic, assign) NSInteger total;
@property (nonatomic, assign) NSInteger next_page;
/**
 *  当前页码
 */
@property (nonatomic, assign) NSInteger currentPage;
@end
