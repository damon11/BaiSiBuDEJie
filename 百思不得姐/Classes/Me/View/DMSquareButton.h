//
//  DMSquareButton.h
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/1.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DMSquare;
@interface DMSquareButton : UIButton
/** 方块模型 */
@property(nonatomic,strong) DMSquare *square;
@end
