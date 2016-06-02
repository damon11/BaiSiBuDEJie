//
//  DMKeyboardTool.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/28.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMKeyboardTool.h"

@implementation DMKeyboardTool

+(instancetype)tool
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] firstObject];
}
- (IBAction)previous:(id)sender {
//    if([self.delegate respondsToSelector:@selector(keyboardToolDidClickPreviousItem:)]){
//        [self.delegate keyboardToolDidClickPreviousItem:self];
//    }
    if([self.toolbarDelegate respondsToSelector:@selector(keyboardTool:didClickItem:)]){
        [self.toolbarDelegate keyboardTool:self didClickItem:DMKeyboardToolItemPrevious];
    }
}
- (IBAction)next:(id)sender {
//    if([self.delegate respondsToSelector:@selector(keyboardToolDidClickNextItem:)]){
//        [self.delegate keyboardToolDidClickNextItem:self];
//    }
    if([self.toolbarDelegate respondsToSelector:@selector(keyboardTool:didClickItem:)]){
        [self.toolbarDelegate keyboardTool:self didClickItem:DMKeyboardToolItemNext];
    }
}

- (IBAction)done:(id)sender {
//    if([self.delegate respondsToSelector:@selector(keyboardToolDidClickDoneItem:)]){
//        [self.delegate keyboardToolDidClickDoneItem:self];
//    }
    if([self.toolbarDelegate respondsToSelector:@selector(keyboardTool:didClickItem:)]){
        [self.toolbarDelegate keyboardTool:self didClickItem:DMKeyboardToolItemDone];
    }
}
@end
