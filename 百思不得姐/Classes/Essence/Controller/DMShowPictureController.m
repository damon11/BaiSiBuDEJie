//
//  DMShowPictureController.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/4/18.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMShowPictureController.h"
#import "UIImageView+WebCache.h"
#import "DMTopics.h"
#import "ESToast.h"
#import "DALabeledCircularProgressView.h"
@interface DMShowPictureController ()
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet DALabeledCircularProgressView *progressView;
@property (weak, nonatomic) UIImageView *imageView;
@end

@implementation DMShowPictureController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    
    //添加图片
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.userInteractionEnabled = YES;
    [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back)]];
    [self.scrollView addSubview:imageView];
    self.imageView = imageView;
   
    
    //显示宽度 XX
    //图片宽度 图片高度
    
    CGFloat pictureW = screenW;
    CGFloat pictureH = pictureW *self.topic.height / self.topic.width;
    
    if(pictureH > screenH){
        //图片显示高度超过一个屏幕,需要滚动查看
        imageView.frame = CGRectMake(0, 0, pictureW, pictureH);
        self.scrollView.contentSize = CGSizeMake(0, pictureH);
    }else{
        imageView.size = CGSizeMake(pictureW, pictureH);
        imageView.centerY = screenH * 0.5;
    }
    
    //马上显示当前图片的下载进度
    [self.progressView setProgress:self.topic.pictureProgress animated:NO];
    
    //下载图片
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.topic.large_image]placeholderImage:nil options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
       
        [self.progressView setProgress:self.topic.pictureProgress animated:NO];
//        self.progressView.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",(self.topic.pictureProgress *100)];
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        self.progressView.hidden = YES;
    }];
    
    
}

-(IBAction)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)save{
    if(self.imageView.image == nil){
        [ESToast showDelayToastWithText:@"图片未下载完毕!"];
        return;
    }
    //将图片写入相册
    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error){
        [ESToast showDelayToastWithText:@"保存失败"];
    }else{
        [ESToast showDelayToastWithText:@"保存成功"];
    }
    
}
@end
