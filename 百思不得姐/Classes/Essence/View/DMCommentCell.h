//
//  DMCommentCell.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/5/30.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
@class DMComment;
@interface DMCommentCell : UITableViewCell
/** 评论 */
@property(nonatomic,strong) DMComment *comment;
@end
