//
//  DMPlaceHolderTextView.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/2.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMPlaceHolderTextView.h"

@implementation DMPlaceHolderTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {   //默认字体
        self.font = [UIFont systemFontOfSize:15];
        //默认颜色
        self.placeholderColor = [UIColor grayColor];
        
        //监听文字改变
        [DMNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
//监听文字改变
-(void)textDidChange{
    [self setNeedsDisplay];
}


//绘制占位文字(每次drawRect之前，会自动擦掉之前绘制的内容)
-(void)drawRect:(CGRect)rect{
    //如果有文字，直接返回，不绘制占位文字
//    if(self.text.length || self.attributedText.length) return;
    if(self.hasText) return;
    
    //处理rect
    rect.origin.x = 4;
    rect.origin.y = 7;
    rect.size.width -= 2 * rect.origin.x;
    
    
    //文字属性
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSForegroundColorAttributeName] = self.placeholderColor;
    attrs[NSFontAttributeName] = self.font;
    [self.placeHolder drawInRect:rect withAttributes:attrs];
}

-(void)dealloc
{
    [DMNotificationCenter removeObserver:self];
}

#pragma mark -重写setter为了别人改placeHolder可以立刻修改
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    [self setNeedsDisplay];
}
-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = placeHolder;
    
    [self setNeedsDisplay];
}
-(void)setFont:(UIFont *)font{
    [super setFont:font];
    
    [self setNeedsDisplay];
}
-(void)setText:(NSString *)text{
    [super setText:text];
    
    [self setNeedsDisplay];
}
-(void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    
    [self setNeedsDisplay];
}
@end
