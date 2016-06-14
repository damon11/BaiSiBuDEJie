//
//  DMCommentCell.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/5/30.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMCommentCell.h"
#import "DMComment.h"
#import "DMUser.h"
#import "UIImageView+WebCache.h"
@interface DMCommentCell()
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sexView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
//播放器
@property (nonatomic,strong)MPMoviePlayerController *player;
/** 进度的Timer */
@property (nonatomic, strong) NSTimer *progressTimer;
/** 存音频时间 */
@property(nonatomic,assign) NSInteger tempvoiceTime;
@end
@implementation DMCommentCell


- (void)awakeFromNib {
    UIImageView *bgView = [[UIImageView alloc] init];
    bgView.image = [UIImage imageNamed:@"mainCellBackground"];
    
    self.backgroundView = bgView;
    
}

-(BOOL)canBecomeFirstResponder{
    return YES;
}
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    return NO;
}


-(void)setComment:(DMComment *)comment{
    _comment = comment;
    
    //设置圆角图片
    [self.profileImageView setHeader:comment.user.profile_image];
    
    self.sexView.image = [comment.user.sex isEqualToString:DMUserSexMale] ? [UIImage imageNamed:@"Profile_manIcon"] :[UIImage imageNamed:@"Profile_womanIcon"];
    self.contentLabel.text = comment.content;
    self.usernameLabel.text = comment.user.username;
    self.likeCountLabel.text = [NSString stringWithFormat:@"%zd",comment.like_count];
    
    if(comment.voiceuri.length){
        self.voiceBtn.hidden = NO;
        [self.voiceBtn setTitle:[NSString stringWithFormat:@"%zd",comment.voicetime] forState:UIControlStateNormal];
    }else{
        self.voiceBtn.hidden = YES;
    }
}

- (IBAction)voiceBtnClick:(id)sender {
    [self startPlayingMusic];
    _player = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:_comment.voiceuri]];
    
    self.voiceBtn.selected = !self.voiceBtn.selected;
    
    if (self.voiceBtn.selected) {
        [self.player play];
        
        [self addProgressTimer];
        
    } else {
       
        [self.player stop];
        
        [self removeProgressTimer];
    }
    
   
    
}

//开始播放音乐
- (void)startPlayingMusic {
    
    [self removeProgressTimer];
    [self addProgressTimer];
    
}

//添加定时器
- (void)addProgressTimer
{
    
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSDefaultRunLoopMode];
    [self updateProgressInfo];
}
#pragma mark - 更新进度的界面
- (void)updateProgressInfo
{
    _tempvoiceTime = _comment.voicetime;
    _tempvoiceTime--;
    [self.voiceBtn setTitle:[NSString stringWithFormat:@"%zd''",_tempvoiceTime] forState:UIControlStateNormal];
    if(_tempvoiceTime == 0){
        [self dismiss];
         [self.voiceBtn setTitle:[NSString stringWithFormat:@"%zd''",_comment.voicetime] forState:UIControlStateNormal];
    }
}

////暂停
//- (IBAction)pause {
//    self.voiceBtn.selected = !self.voiceBtn.selected;
//    
//    if (self.voiceBtn.selected) {
//        [self.player pause];
//        
//        [self removeProgressTimer];
//        
//    } else {
//        [self.player play];
//        
//        [self addProgressTimer];
//        
//    }
//}

//移除定时器
- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

-(void)dismiss {
    [self removeProgressTimer];
    [self.player stop];
}

-(void)setFrame:(CGRect)frame{
//    frame.origin.x = DMTopicCellMargin;
//    frame.size.width -= 2 * DMTopicCellMargin;
    
    [super setFrame:frame];
}
@end
