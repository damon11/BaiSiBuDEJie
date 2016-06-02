//
//  DMConst.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    DMTopicTypeAll = 1,
    DMTopicTypeWord = 29,
    DMTopicTypeVoice = 31,
    DMTopicTypeVideo = 41,
    DMTopicTypePicture = 10
}DMTopicType;
//精华-所有顶部标题高度
UIKIT_EXTERN CGFloat const DMTitleViewH;
//精华-所有顶部标题Y
UIKIT_EXTERN CGFloat const DMTitleViewY;

//精华-cell-间距
UIKIT_EXTERN CGFloat const DMTopicCellMargin;
//精华-cell-底部工具条的高度
UIKIT_EXTERN CGFloat const DMTopicCellBottomBarH;
//精华-cell-文字内容的Y
UIKIT_EXTERN CGFloat const DMTopicCellTextY;
//精华-cell-图片帖子最大高度
UIKIT_EXTERN CGFloat const DMTopicPictureMaxH;
//精华-cell-图片帖子固定高度
UIKIT_EXTERN CGFloat const DMTopicPictureBreakH;

/** DMUser模型-性别属性值 */
UIKIT_EXTERN NSString *  const DMUserSexMale;
UIKIT_EXTERN NSString *  const DMUserSexFemale;

/** 精华-cell-最热评论标题的高度 */
UIKIT_EXTERN CGFloat const DMTopicCellCmtTitleH;
/** tabBar被点击的通知名字*/
UIKIT_EXTERN NSString *  const DMTabBarDidSelectNotification;
/** tabBar被点击的控制器的index key*/
UIKIT_EXTERN NSString *  const DMSelectedControllerIndexKey;
/** tabBar被点击的控制器 key*/
UIKIT_EXTERN NSString *  const DMSelectedControllerKey;