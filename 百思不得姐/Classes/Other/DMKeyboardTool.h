//
//  DMKeyboardTool.h
//  百思不得姐
//
//  Created by JD_Mac on 16/3/28.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum{
    DMKeyboardToolItemPrevious,
    DMKeyboardToolItemNext,
    DMKeyboardToolItemDone
}DMKeyboardToolItem;

@class DMKeyboardTool;

@protocol DMKeyboardToolDelegate <NSObject>

@optional

//-(void)keyboardToolDidClickPreviousItem:(DMKeyboardTool *)tool;
//-(void)keyboardToolDidClickNextItem:(DMKeyboardTool *)tool;
//-(void)keyboardToolDidClickDoneItem:(DMKeyboardTool *)tool;
-(void)keyboardTool:(DMKeyboardTool *)tool didClickItem:(DMKeyboardToolItem)item;
@end


@interface DMKeyboardTool : UIToolbar
+(instancetype)tool;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextItem;

/**
 *  代理
 */
@property(nonatomic, weak) id<DMKeyboardToolDelegate> toolbarDelegate;//toolbar自己有个delegate 不能重名
@end