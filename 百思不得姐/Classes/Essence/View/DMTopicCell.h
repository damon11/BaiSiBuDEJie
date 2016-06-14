//
//  DMTopicCell.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMTopics;
typedef void(^headerClickBlock)(void);
typedef void(^commentBtnClickBlock)(void);
@interface DMTopicCell : UITableViewCell
//帖子数据
@property (nonatomic, strong) DMTopics *topic;
/** 头像点击block */
@property (nonatomic, copy) headerClickBlock headerBlock;
/** 评论点击block */
@property (nonatomic, copy) commentBtnClickBlock commentBtnBlock;
@end
