//
//  DMTopicCell.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/12.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTopicCell.h"
#import "DMTopics.h"
#import "UIImageView+WebCache.h"
#import "DMTopicPictureView.h"
#import "DMTopicVoiceView.h"
#import "DMTopicVideoView.h"
#import "DMComment.h"
#import "DMUser.h"
@interface DMTopicCell()

@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;

@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *commentButton;
@property (weak, nonatomic) IBOutlet UIImageView *sinaView;
@property (weak, nonatomic) IBOutlet UILabel *text_label;
/*图片帖子内容*//*控件weak*/
@property(nonatomic,weak) DMTopicPictureView *pictureView;
/*声音帖子内容*//*控件weak*/
@property(nonatomic,weak) DMTopicVoiceView *voiceView;
/*视频帖子内容*//*控件weak*/
@property(nonatomic,weak) DMTopicVideoView *videoView;
/* 最热评论内容*/
@property (weak, nonatomic) IBOutlet UILabel *topCmtContentLabel;
/* 最热评论整体*/
@property (weak, nonatomic) IBOutlet UIView *topCmtView;
@end
@implementation DMTopicCell

// 从队列里面复用时调用
- (void)prepareForReuse {
    
    [super prepareForReuse];
    [_videoView reset];
    [_voiceView reset];
}


+ (instancetype)cell{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}

-(DMTopicPictureView *)pictureView{
    if(!_pictureView){
        DMTopicPictureView *pictureView = [DMTopicPictureView pictureView];
        [self.contentView addSubview:pictureView];
        _pictureView = pictureView;
    }
    return _pictureView;
}
-(DMTopicVoiceView *)voiceView{
    if(!_voiceView){
        DMTopicVoiceView *voiceView = [DMTopicVoiceView voiceView];
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}
-(DMTopicVideoView *)videoView{
    if(!_videoView){
        DMTopicVideoView *videoView = [DMTopicVideoView videoView];
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}
- (void)awakeFromNib {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    
    self.backgroundView = bgView;
}

-(void)setTopic:(DMTopics *)topic{
    
    _topic = topic;
    
    //新浪加V
    self.sinaView.hidden = !topic.sina_v;
    
//    DXLog(@"%@",topic.create_time);
    
    //设置头像
    [self.profileImageView setHeader:topic.profile_image];
    

    //设置名字
    self.nameLabel.text = topic.name;
    
    //设置帖子的创建时间
    self.createTimeLabel.text = topic.create_time;
    
//    NSInteger year = [calendar component:NSCalendarUnitYear fromDate:now];
//    NSInteger month = [calendar component:NSCalendarUnitMonth fromDate:now];
//    NSInteger day = [calendar component:NSCalendarUnitDay fromDate:now];
    
//    self.createTimeLabel.text = cmps;
    
    [self setupButtonTitle:self.dingButton count:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton count:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton count:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.commentButton count:topic.comment placeholder:@"评论"];
    
    //设置帖子的文字内容
    self.text_label.text = topic.text;
    
    //根据模型类型添加对应的内容到cell上
    if(topic.type == DMTopicTypePicture){//图片帖子
       self.pictureView.hidden = NO;
       self.voiceView.hidden = YES;
       self.videoView.hidden = YES;
        
       self.pictureView.topic = self.topic;
       self.pictureView.frame = topic.pictureViewFrame;
    }else if (topic.type == DMTopicTypeVoice){//声音帖子
        self.pictureView.hidden = YES;
        self.voiceView.hidden = NO;
        self.videoView.hidden = YES;
        self.voiceView.topic = topic;
        self.voiceView.frame = topic.voiceFrame;
    }else if (topic.type == DMTopicTypeVideo){//视频帖子
        self.pictureView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
        self.videoView.frame = topic.videoFrame;
    }else{//段子帖子
        self.videoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.pictureView.hidden = YES;
    }
    
    //处理最热评论
    
   
    if(self.topic.top_cmt){
        self.topCmtView.hidden = NO;
        self.topCmtContentLabel.text = [NSString stringWithFormat:@"%@ : %@",self.topic.top_cmt.user.username, self.topic.top_cmt.content];
    }else{
        self.topCmtView.hidden = YES;
    }
    
}


/**
 *  今年
        今天
            1分钟内
                刚刚
            1小时内
                XX分钟前
            其他
                XX小时前
 
        昨天
            昨天 18:56:34
        其他
            06-23 19:56:23
    非今年
        2015-05-07 18:45:34
 */

-(void)setupButtonTitle:(UIButton *)button count:(NSInteger)count placeholder:(NSString *)placeholder{
    
    if(count >10000) {
        placeholder = [NSString stringWithFormat:@"%.1f万",count / 10000.0];
    }else if(count > 0){
        placeholder = [NSString stringWithFormat:@"%zd",count];
    }
    [button setTitle:placeholder forState:UIControlStateNormal];
}
-(void)setFrame:(CGRect)frame{
    
//    frame.origin.x = DMTopicCellMargin;
//    frame.size.width -= 2*DMTopicCellMargin;
//    frame.size.height -= DMTopicCellMargin;
//    防止下拉页面 headerview递减消失
    frame.size.height = self.topic.cellHeight - DMTopicCellMargin;
    frame.origin.y += DMTopicCellMargin;
    
    [super setFrame:frame];
}
- (IBAction)more:(id)sender {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *save = [UIAlertAction actionWithTitle:@"收藏" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *report = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:report];
    [alertController addAction:cancel];
    [alertController addAction:save];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
}

@end
