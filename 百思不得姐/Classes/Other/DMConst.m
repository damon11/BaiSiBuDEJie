//
//  DMConst.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>

//精华-所有顶部标题高度
CGFloat const DMTitleViewH = 35;
//精华-所有顶部标题Y
CGFloat const DMTitleViewY = 64;

//精华-cell-间距
CGFloat const DMTopicCellMargin = 10;
//精华-cell-底部工具条的高度
CGFloat const DMTopicCellBottomBarH = 35;
//精华-cell-文字内容的Y
CGFloat const DMTopicCellTextY = 55;
//精华-cell-图片帖子最大高度
CGFloat const DMTopicPictureMaxH = 1000;
//精华-cell-图片帖子固定高度
CGFloat const DMTopicPictureBreakH = 250;

/** DMUser模型-性别属性值 */
NSString * const DMUserSexMale = @"m";
NSString * const DMUserSexFemale = @"f";

/** 精华-cell-最热评论标题的高度 */
CGFloat const DMTopicCellCmtTitleH = 20;

/** tabBar被点击的通知名字*/
NSString *  const DMTabBarDidSelectNotification = @"DMTabBarDidSelectNotification";
/** tabBar被点击的控制器的index key*/
NSString *  const DMSelectedControllerIndexKey = @"DMSelectedControllerIndexKey";
/** tabBar被点击的控制器 key*/
NSString *  const DMSelectedControllerKey = @"DMSelectedControllerKey";