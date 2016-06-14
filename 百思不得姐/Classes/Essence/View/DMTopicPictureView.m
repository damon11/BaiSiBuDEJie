//
//  DMTopicPictureView.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/18.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTopicPictureView.h"
#import "DMTopics.h"
#import "UIImageView+WebCache.h"
#import "DALabeledCircularProgressView.h"
#import "DMShowPictureController.h"
@interface DMTopicPictureView()
/**
 *  图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
/**
 *  gif标
 */
@property (weak, nonatomic) IBOutlet UIImageView *gifView;
/**
 *  底部查看大图BUTTON
 */
@property (weak, nonatomic) IBOutlet UIButton *seeBigButton;
/**
 *  进度条控件
 */
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;

@end
@implementation DMTopicPictureView



-(void)awakeFromNib{
    self.autoresizingMask = UIViewAutoresizingNone;
    self.progressView.roundedCorners = 2;
    self.progressView.progressLabel.textColor = [UIColor whiteColor];
    
    //给图片添加监听
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showPicture)]];
}
-(IBAction)showPicture{
    DMShowPictureController *showPicture = [[DMShowPictureController alloc]init];
    showPicture.topic = self.topic;
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:showPicture animated:YES completion:nil];
}

- (void)setTopic:(DMTopics *)topic{
    _topic = topic;
    
    /**
     *  在不知道图片扩展名的情况下，如何知道图片的真实类型?
     *  取出图片的第一个字节，就可以判断出图片的真实类型
     */
    
    //马上显示最新的进度值
    [self.progressView setProgress:topic.pictureProgress animated:NO];
    
    //设置图片
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:topic.large_image] placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        self.progressView.hidden = NO;
        topic.pictureProgress = 1.0 * receivedSize/ expectedSize;
        topic.pictureProgress = (topic.pictureProgress < 0 ? 0:topic.pictureProgress);
        [self.progressView setProgress:topic.pictureProgress animated:NO];
        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",(topic.pictureProgress *100)];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
        
        //如果是大图片才进行图形处理
        if(topic.isBigPicure == NO) return ;
        
        //开启图形上下文
        UIGraphicsBeginImageContextWithOptions(topic.pictureViewFrame.size, YES, 0.0);
        //将下载完的image对象绘制到图形上下文
        CGFloat width = topic.pictureViewFrame.size.width;
        CGFloat height = width *image.size.height / image.size.width;
        [image drawInRect:CGRectMake(0, 0, width, height)];
        
        //获得图片
        self.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        
        //结束图形上下文
        UIGraphicsEndImageContext();
        
    }];
    //判断是否为gif
    NSString *extension = topic.large_image.pathExtension;//扩展名获取
    self.gifView.hidden = ![extension.lowercaseString isEqualToString:@"gif"];//忽略大小写
    
    //判断是否显示"点击查看全图"
    if(topic.isBigPicure){//大图
        self.seeBigButton.hidden = NO;
//        self.imageView.contentMode = UIViewContentModeTop;//由于进行了图片处理，这里不需要设置模式了
    }else{//非大图
        self.seeBigButton.hidden = YES;
//        self.imageView.contentMode = UIViewContentModeScaleToFill;//由于进行了图片处理，这里不需要设置模式了
    }
//    self.seeBigButton.hidden = topic.isBigPicure;
}
@end
