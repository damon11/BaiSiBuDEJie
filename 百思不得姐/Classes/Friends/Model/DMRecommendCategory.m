//
//  DMRecommendCategory.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/23.
//  Copyright © 2016年 Damon. All rights reserved.
//  推荐关注左边模型

#import "DMRecommendCategory.h"
#import "MJExtension.h"
@implementation DMRecommendCategory
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{
             @"ID":@"id"
             };
}
//根据属性名修改名称 修改多数属性跟服务器返回字段不一样的时候 统一修改用
//+ (NSString *)mj_replacedKeyFromPropertyName121:(NSString *)propertyName{
//    if([propertyName isEqualToString:@"ID"]) return @"id";
//    return propertyName;
//}
-(NSMutableArray *)users
{
    if (!_users) {
        _users = [NSMutableArray array];
    }
    return _users;
}
@end
