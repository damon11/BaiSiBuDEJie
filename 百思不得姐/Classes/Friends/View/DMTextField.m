//
//  DMTextField.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/28.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTextField.h"
#import <objc/runtime.h>

static NSString *const DMPlaceholderColorKeyPath = @"_placeholderLabel.textColor";
@implementation DMTextField

//-(void)drawPlaceholderInRect:(CGRect)rect{
//    [self.placeholder drawInRect:CGRectMake(0, 14, rect.size.width, 25) withAttributes:@{NSForegroundColorAttributeName:[UIColor grayColor],
//                                                       NSFontAttributeName: self.font}];
//}
+ (void)initialize{
//    [self getIvar];
    [self getProperties];
}
/**
 *运行时
 */
+(void)getProperties{
    unsigned int count = 0;
    
    objc_property_t *preperties = class_copyPropertyList([UIButton class], &count);
    
    for(int i = 0; i < count; i++){
        //取出属性
        objc_property_t property = preperties[i];
        
        //打印属性名字
        DXLog(@"%s %s",property_getName(property),property_getAttributes(property));
        
    }
    free(preperties);
}
+(void)getIvar{
    
    unsigned int count = 0;
    
    //拷贝出所有的成员变量列表
    Ivar *ivars = class_copyIvarList([UITextField class], &count);
    
    for(int i = 0; i < count; i++){
//        Ivar ivar = *(ivars + i);//与下面方法等价
        Ivar ivar = ivars[i];
        //打印成员变量名字
        DXLog(@"%s %s",ivar_getName(ivar),ivar_getTypeEncoding(ivar));
    }
    
    //释放
    free(ivars);
}

- (void)awakeFromNib{
//    UILabel *placeholderLabel = [self valueForKeyPath:@"_placeholderLabel"];
//    placeholderLabel.textColor = [UIColor orangeColor];
    
   //修改占位文字颜色
//    [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    //设置光标颜色和文字颜色一致
    self.tintColor = self.textColor;
    
    //不成为第一响应者
    [self resignFirstResponder];
}
/**
 *  当前文本框聚焦时
 */
-(BOOL)becomeFirstResponder{
    //修改占位文字颜色
    [self setValue:[UIColor whiteColor] forKeyPath:DMPlaceholderColorKeyPath];
    return [super becomeFirstResponder];
}
/**
 *  失去焦点时
 */
-(BOOL)resignFirstResponder{
    //修改占位文字颜色
    [self setValue:[UIColor grayColor] forKeyPath:DMPlaceholderColorKeyPath];
    return [super resignFirstResponder];
}

/**
 *  运行时(Runtime):
 *  苹果官方一套C语言库
 *  能做很多底层操作(比如访问隐藏的一些成员变量\成员方法...)
 */
@end
