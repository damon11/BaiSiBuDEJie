//
//  DMRecommendUser.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/23.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMRecommendUser.h"
#import "MJExtension.h"
@implementation DMRecommendUser

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id"
             };
}
@end
