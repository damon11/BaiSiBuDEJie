//
//  NSDate+DMExtension.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/13.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (DMExtension)
-(NSDateComponents*)deltaFrom:(NSDate *)from;
/**
 *  是否是今年
 */
-(BOOL)isThisYear;
/**
 *  是否是今天
 */
-(BOOL)isToday;
/**
 *  是否是昨天
 */
-(BOOL)isYesterday;

@end
