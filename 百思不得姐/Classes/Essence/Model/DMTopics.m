//
//  DMTopics.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/5.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTopics.h"
#import "MJExtension.h"
#import "DMComment.h"
#import "DMUser.h"
@implementation DMTopics
{//私有的 只能在本类使用
    CGFloat _cellHeight;
}
-(NSString *)create_time{
    
    //日期格式化类
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
    //设置日期格式(y:年M:月d:日H:时m:分s:秒)
    fmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    //发帖时间
    NSDate *create = [fmt dateFromString:_create_time];
    
    if(create.isThisYear){//今年
        if(create.isToday) {//今天
            NSDateComponents *cmps = [[NSDate date] deltaFrom:create];
            
            if(cmps.hour >= 1){//时间差距 >= 1小时
                return [NSString stringWithFormat:@"%zd小时前",cmps.hour];
            }else if (cmps.minute >= 1){//1小时 > 时间差距 >= 1分钟
                return [NSString stringWithFormat:@"%zd分钟前",cmps.minute];
            }else{// 1分钟 > 时间差距
                return @"刚刚";
            }
        }else if (create.isYesterday){//昨天
            fmt.dateFormat = @"昨天 HH:mm:ss";
            return [fmt stringFromDate:create];
        }else{//其他
            fmt.dateFormat = @"MM-dd HH:mm:ss";
            return [fmt stringFromDate:create];
        }
    }else{//非今年
        return _create_time;
    }
}

-(CGFloat)cellHeight{
    
    if(!_cellHeight){
        //文字的最大尺寸
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - 4*DMTopicCellMargin, MAXFLOAT);
        //    CGFloat textH = [topic.text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:maxSize].height;
        CGFloat textH = [self.text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:14]} context:nil].size.height;
        
        //cell的高度
        //文字部分的高度
        _cellHeight = DMTopicCellTextY + textH + DMTopicCellMargin;
        //根据段子的类型来计算高度
        if(self.type == DMTopicTypePicture){//图片帖子
            //图片显示出来的宽度
            CGFloat pictureW = maxSize.width+20;
            //显示出来的高度
            CGFloat pictureH = pictureW *self.height / self.width;
            
            
            if(pictureH >= DMTopicPictureMaxH){
                pictureH = DMTopicPictureBreakH;
                self.bigPicture = YES;
            }
            
            //计算图片控件的frame
            CGFloat pictureX = DMTopicCellMargin;
            CGFloat pictureY = DMTopicCellTextY + textH + DMTopicCellMargin;
            _pictureViewFrame = CGRectMake(pictureX , pictureY, pictureW, pictureH);
            
            _cellHeight += pictureH + DMTopicCellMargin;
        }else if (self.type == DMTopicTypeVoice){//声音帖子
            CGFloat voiceX = DMTopicCellMargin;
            CGFloat voiceY = DMTopicCellTextY + textH + DMTopicCellMargin;
            CGFloat voiceW = maxSize.width+20;
            CGFloat voiceH = voiceW * self.height / self.width;
            _voiceFrame = CGRectMake(voiceX, voiceY, voiceW, voiceH);
            
            _cellHeight += voiceH + DMTopicCellMargin;
        }else if (self.type == DMTopicTypeVideo){//视频帖子
            CGFloat videoX = DMTopicCellMargin;
            CGFloat videoY = DMTopicCellTextY + textH + DMTopicCellMargin;
            CGFloat videoW = maxSize.width+20;
            CGFloat videoH = videoW * self.height / self.width;
            _videoFrame = CGRectMake(videoX, videoY, videoW, videoH);
            
            _cellHeight += videoH + DMTopicCellMargin;
            
        }
        
        //如果有最热评论
       
        if(self.top_cmt){
            NSString *content = [NSString stringWithFormat:@"%@ : %@",self.top_cmt.user.username, self.top_cmt.content];
            CGFloat contentH = [content boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil].size.height;
            _cellHeight += DMTopicCellCmtTitleH + contentH + DMTopicCellMargin;
        }
        //底部工具条的高度
        _cellHeight += DMTopicCellBottomBarH + DMTopicCellMargin;
    }
    return _cellHeight;
}
+ (NSDictionary *)mj_replacedKeyFromPropertyName{//名字不一样与服务器的对应起来
    return @{
             @"small_image":@"image0",
             @"large_image":@"image1",
             @"middle_image":@"image2",
             @"ID":@"id",
             @"top_cmt":@"top_cmt[0]",
             };
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"top_cmt" : @"DMComment"};
}



@end
