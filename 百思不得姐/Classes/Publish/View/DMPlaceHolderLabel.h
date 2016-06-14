//
//  DMPlaceHolderLabel.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/2.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DMPlaceHolderLabel : UITextView
/** 占位文字 */
@property (nonatomic, copy) NSString *placeHolder;
/** 占位文字的颜色 */
@property(nonatomic,strong) UIColor *placeholderColor;
@end
