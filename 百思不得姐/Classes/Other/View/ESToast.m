//
//  ESToast.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/28.
//  Copyright © 2016年 Damon. All rights reserved.
//.

#import "ESToast.h"

#define new_toast_height 50.f
#define new_toast_width 270.f

#define new_wait_toast_height 98.f
#define new_wait_toast_width 140.f

@implementation ESToast

- (id)initWithText:(NSString *)text
{
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds), CGRectGetHeight([UIApplication sharedApplication].keyWindow.bounds));
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
    
        NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:14]};
        CGSize singleSize = [@"呵呵" boundingRectWithSize:CGSizeMake(new_toast_width-10, 9999)
                                                           options:NSStringDrawingUsesLineFragmentOrigin
                                                        attributes:attributes
                                                           context:nil].size ;
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(new_toast_width-10, 9999)
                                                options:NSStringDrawingUsesLineFragmentOrigin
                                             attributes:attributes
                                                context:nil].size;
        
        CGSize widthSize = [text boundingRectWithSize:CGSizeMake(9999, singleSize.height)
                                              options:NSStringDrawingUsesLineFragmentOrigin
                                           attributes:attributes
                                              context:nil].size;
        //得到要显示的toast文字 以一行显示时的宽度 一行显示不下时 宽度变为一半 以两行显示 两行显示不下时 宽度变为1/3 以此类推
        
        int totalLine=1;
        
        CGFloat newWidth = widthSize.width;
        
        if(nearbyint(textSize.height/singleSize.height) > 1){
            for(int i=1;;i++){
                if (newWidth < new_toast_width) break;
                
                newWidth = widthSize.width/(i+1);
                CGSize tempSize = [text boundingRectWithSize:CGSizeMake(newWidth, 9999)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:attributes
                                                     context:nil].size;
                
                //CGSize tempSize = [text sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(newWidth, 9999) lineBreakMode:NSLineBreakByTruncatingTail];
                totalLine = nearbyint(tempSize.height/singleSize.height);
            }
        }
        CGFloat newHeight = (singleSize.height*totalLine+10) > new_toast_height?(singleSize.height*totalLine+10):new_toast_height;
        
        _tosView = [[UIView alloc] initWithFrame:CGRectMake((self.frame.size.width-newWidth-20)/2, ([UIScreen mainScreen].bounds.size.height-newHeight)/2, newWidth+20, newHeight)];
        _tosView.alpha = 0;
        _tosView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.7];
        _tosView.layer.cornerRadius = 8.f;
        [self addSubview:_tosView];
        
        self.textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5+5, (newHeight-singleSize.height*totalLine)/2, newWidth, singleSize.height*totalLine)];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor clearColor];
        _textLabel.numberOfLines = 0;
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize:14];
        
        [_tosView addSubview:_textLabel];
    }
    return self;
}

- (void)showToast
{
    _tosView.alpha = 0;
    
    [UIView beginAnimations:@"show_toast" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    _tosView.alpha = 1;
    [UIView commitAnimations];
}

- (void)closeToast
{
    //    CGRect tosRect = _tosView.frame;
    //    tosRect.origin.x = CGRectGetWidth([UIApplication sharedApplication].keyWindow.bounds);
    
    //移动位置
    [UIView beginAnimations:@"close_toast" context:nil];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    //	_tosView.frame = tosRect;
    _tosView.alpha = 0.0;
    
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    if(animationID && [animationID compare:@"close_toast"] == NSOrderedSame)
    {
        if([self superview])
        {
            [self removeFromSuperview];
        }
    }
}


#pragma mark -
#pragma mark out use functions
//满屏的toast

+ (void)showDelayToastWithText:(NSString*)text;
{
    for (UIView* sub in kAppWindow.subviews) {
        if([sub isKindOfClass:[ESToast class]])
            [sub removeFromSuperview];
    }
    ESToast *toast = [[ESToast alloc] initWithText:text];
    toast.tag = 15265;
    toast.textLabel.text = text;
    
    toast.userInteractionEnabled = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:toast];
    [toast showToast];
    [toast performSelector:@selector(closeToast) withObject:nil afterDelay:1];
}

+ (void)showToastWithText:(NSString*)text closeAfterDelay:(NSTimeInterval)delay;
{
    for (UIView* sub in kAppWindow.subviews) {
        if([sub isKindOfClass:[ESToast class]])
            [sub removeFromSuperview];
    }
    ESToast *toast = [[ESToast alloc] initWithText:text];
    toast.tag = 15265;
    toast.textLabel.text = text;
    
    toast.userInteractionEnabled = NO;
    [[UIApplication sharedApplication].keyWindow addSubview:toast];
    [toast showToast];
    [toast performSelector:@selector(closeToast) withObject:nil afterDelay:delay];
}

@end
