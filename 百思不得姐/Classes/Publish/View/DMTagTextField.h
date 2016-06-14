//
//  DMTagTextField.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/3.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^DeleteBlock)(void);
@interface DMTagTextField : UITextField
/** 按删除键后回调 */
@property (nonatomic, copy) DeleteBlock deleteBlock;
@end
