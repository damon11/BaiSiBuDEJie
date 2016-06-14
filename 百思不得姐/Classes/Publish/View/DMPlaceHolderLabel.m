//
//  DMPlaceHolderLabel.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/2.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMPlaceHolderLabel.h"
@interface DMPlaceHolderLabel()
/** 占位文字 */
@property(nonatomic,weak) UILabel *placeholderLabel;
@end
@implementation DMPlaceHolderLabel

-(UILabel *)placeholderLabel{
    if(!_placeholderLabel){
        //添加一个用来显示占位文字的label
        UILabel *placeholderLabel = [[UILabel alloc] init];
        
        placeholderLabel.numberOfLines = 0;
        placeholderLabel.x = 4;
        placeholderLabel.y = 7;
        [self addSubview:placeholderLabel];
        self.placeholderLabel = placeholderLabel;
    }
    return _placeholderLabel;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {   //默认字体
        self.font = [UIFont systemFontOfSize:15];
        self.alwaysBounceVertical = YES;
        //默认颜色
        self.placeholderColor = [UIColor grayColor];
        
        //监听文字改变
        [DMNotificationCenter addObserver:self selector:@selector(textDidChange) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}
//监听文字改变
-(void)textDidChange{
    //只要有文字就隐藏占位文字label
    self.placeholderLabel.hidden = self.hasText;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.placeholderLabel.width = self.frame.size.width - 2 *self.placeholderLabel.x;
//    self.placeholderLabel.height = self.height;
    [self.placeholderLabel sizeToFit];
}

-(void)dealloc
{
    [DMNotificationCenter removeObserver:self];
}
//更新占位文字尺寸
-(void)updatePlaceholderLabelSize{
//第一种    CGSize maxSize = CGSizeMake(DMSCREENWIDTH - 2*self.placeholderLabel.x, MAXFLOAT);
//    self.placeholderLabel.size = [self.placeHolder boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil].size;
//第二种
    self.placeholderLabel.width = DMSCREENWIDTH - 2*self.placeholderLabel.x;
    [self.placeholderLabel sizeToFit];
}

#pragma mark -重写setter为了别人改placeHolder可以立刻修改
-(void)setPlaceholderColor:(UIColor *)placeholderColor{
    _placeholderColor = placeholderColor;
    
    self.placeholderLabel.textColor = placeholderColor;
}
-(void)setPlaceHolder:(NSString *)placeHolder{
    _placeHolder = [placeHolder copy];
    
    self.placeholderLabel.text = placeHolder;
    [self setNeedsLayout];
    
}
-(void)setFont:(UIFont *)font{
    [super setFont:font];
    
    self.placeholderLabel.font = font;
    [self setNeedsLayout];
}
-(void)setText:(NSString *)text{
    [super setText:text];
    
    [self textDidChange];
}
-(void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
    
    [self textDidChange];
}

//setNeedsDisplay:会在恰当时刻自动调用drawRect;
//setNeedsLayout:会在恰当时刻自动调用layoutSubviews方法
@end
