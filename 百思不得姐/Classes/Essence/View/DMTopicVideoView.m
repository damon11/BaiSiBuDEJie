//
//  DMTopicVideoView.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/22.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTopicVideoView.h"
#import "DMTopics.h"
#import "UIImageView+WebCache.h"
#import "DMShowPictureController.h"
#import "KRVideoPlayerController.h"
@interface DMTopicVideoView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *playCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *videoTimeLabel;
@property (nonatomic, strong) KRVideoPlayerController *videoController;
@end
@implementation DMTopicVideoView


-(void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    //给图片添加监听
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPicture)]];
    [DMNotificationCenter addObserver:self selector:@selector(pause) name:@"videoPause" object:nil];
   
    [DMNotificationCenter addObserver:self selector:@selector(reset) name:@"videoReset" object:nil];
}
-(IBAction)showPicture{

    [self playVideo];
    
}

- (void)playVideo{
    NSURL *url = [NSURL URLWithString:self.topic.videouri];
    [self addVideoPlayerWithURL:url];
    [self addSubview:self.videoController.view];
}

- (void)addVideoPlayerWithURL:(NSURL *)url{
    if (!self.videoController) {
        self.videoController = [[KRVideoPlayerController alloc] initWithFrame:self.imageView.bounds];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
    }
    self.videoController.contentURL = url;
}


//停止视频的播放
- (void)reset {
    [self.videoController dismiss];
    self.videoController = nil;
}

-(void)pause{
    
    [self.videoController pause];
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
    NSInteger minute = topic.videotime / 60;
    NSInteger second = topic.videotime % 60;
    self.videoTimeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd",minute,second];
    self.videoTimeLabel.layer.cornerRadius = 5.0f;
    self.videoTimeLabel.layer.masksToBounds = YES;
}

-(void)dealloc{
    [DMNotificationCenter removeObserver:self];
}

@end
