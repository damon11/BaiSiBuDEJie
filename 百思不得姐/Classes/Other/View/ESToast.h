//
//  ESToast.h
//  百思不得姐
//
//  Created by JD_Mac on 16/3/28.
//  Copyright © 2016年 Damon. All rights reserved.
//.


@interface ESToast : UIView
{
    UIView *_tosView;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *textLabel;

+ (void)showDelayToastWithText:(NSString*)text;
+ (void)showToastWithText:(NSString*)text closeAfterDelay:(NSTimeInterval)delay;

@end
