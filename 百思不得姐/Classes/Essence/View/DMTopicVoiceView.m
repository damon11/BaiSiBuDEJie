//
//  DMTopicVoiceView.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/22.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTopicVoiceView.h"
#import "DMTopics.h"
#import "UIImageView+WebCache.h"
#import "DMShowPictureController.h"
#import "XFVociePlayerController.h"
@interface DMTopicVoiceView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *voicelengthLabel;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (nonatomic,strong) XFVociePlayerController *voicePlayer;
@end
@implementation DMTopicVoiceView

+(instancetype)voiceView{
    return [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(self) owner:nil options:nil].lastObject;
}

-(void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    //给图片添加监听
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPicture)]];
}
-(IBAction)showPicture{
    DMShowPictureController *showPicture = [[DMShowPictureController alloc]init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}
-(void)setTopic:(DMTopics *)topic{
    _topic = topic;
    
    //图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image]];
    
    
    //播放次数
    self.playCountLabel.text = [NSString stringWithFormat:@"%zd播放",topic.playcount];
    self.playCountLabel.layer.cornerRadius = 5.0f;
    self.playCountLabel.layer.masksToBounds = YES;
    //时长
    NSInteger minute = topic.voicetime / 60;
    NSInteger second = topic.voicetime % 60;
    self.voicelengthLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
    self.voicelengthLabel.layer.cornerRadius = 5.0f;
    self.voicelengthLabel.layer.masksToBounds = YES;
}

//播放按钮
- (IBAction)playBtn:(UIButton *)sender {
    
    self.playBtn.hidden = YES;
    self.voicePlayer = [[XFVociePlayerController alloc]initWithNibName:@"XFVociePlayerController" bundle:nil];
    self.voicePlayer.url = self.topic.voiceuri;
    self.voicePlayer.totalTime = self.topic.voicetime;
    self.voicePlayer.view.width = self.imageView.width;
    self.voicePlayer.view.y = self.imageView.height - self.voicePlayer.view.height;
    [self addSubview:self.voicePlayer.view];
    
}
//重置
-(void)reset {
    
    [self.voicePlayer dismiss];
    [self.voicePlayer.view removeFromSuperview];
    self.voicePlayer = nil;
    self.playBtn.hidden = NO;
}
@end
