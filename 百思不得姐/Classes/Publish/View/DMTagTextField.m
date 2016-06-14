//
//  DMTagTextField.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/3.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMTagTextField.h"

@implementation DMTagTextField

-(instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.placeholder = @"多个标签用逗号或者换行";
        self.height = DMTagH;
        //设置占位文字内容以后才能通过KVC设置占位文字颜色 系统懒加载
        [self setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
        [self setValue:[UIFont systemFontOfSize:15] forKeyPath:@"_placeholderLabel.font"];
    }
    return  self;
}
-(void)deleteBackward{
    
    !self.deleteBlock? : self.deleteBlock();
    //先执行block再执行父类方法 为了防止删除最后一个文字后直接调用父类方法
    [super deleteBackward];
}
@end
