//
//  DMComment.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/22.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMUser;

@interface DMComment : NSObject
/** id */
@property (nonatomic, copy) NSString *ID;
/** 音频文件的时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 评论文字的内容 */
@property (nonatomic, copy) NSString *content;
/** 被点赞的数量 */
@property (nonatomic, assign) NSInteger like_count;
/** 声音URL */
@property (nonatomic, copy) NSString *voiceuri;
/** 用户 */
@property(nonatomic,strong) DMUser *user;
@end
