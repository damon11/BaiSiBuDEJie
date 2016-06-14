//
//  DMAddTagViewController.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/2.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^tagsBlock)(NSArray *tags);
@interface DMAddTagViewController : UIViewController
/** 获取tags的block */
@property (nonatomic, copy) tagsBlock tagsBlock;

/** 所有的标签 */
@property(nonatomic,strong) NSArray *tags;
@end
