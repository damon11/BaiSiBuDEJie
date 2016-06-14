//
//  DMTopicVoiceView.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/22.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMTopics;
@interface DMTopicVoiceView : UIView
//帖子数据
@property (nonatomic, strong) DMTopics *topic;


- (void)reset;
@end
