//
//  DMAddTagToolbar.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/2.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMAddTagToolbar.h"
#import "DMAddTagViewController.h"
@interface DMAddTagToolbar()
//顶部控件
@property (weak, nonatomic) IBOutlet UIView *topView;
//添加按钮
@property (weak, nonatomic) UIButton *addButton;
/** 存放所有标签label */
@property(nonatomic,strong) NSMutableArray *tagLabels;

@end
@implementation DMAddTagToolbar

-(NSMutableArray *)tagLabels{
    if(!_tagLabels){
        _tagLabels = [NSMutableArray array];
    }
    return _tagLabels;
}

-(void)awakeFromNib{
    //添加一个加号按钮
    UIButton *addButton = [[UIButton alloc ] init];
    [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [addButton setImage:[UIImage imageNamed:@"tag_add_icon"] forState:UIControlStateNormal];
    addButton.size = addButton.currentImage.size;
    addButton.x = DMTopicCellMargin;
    [self.topView addSubview:addButton];
    self.addButton = addButton;
    
    //默认就拥有2个标签
    [self createTagLabels:@[@"吐槽",@"糗事"]];
}

//处理子控件布局的事情
-(void)layoutSubviews{
    [super layoutSubviews];
    [self.tagLabels enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *tagLabel = self.tagLabels[idx];
        //设置位置
        if(idx == 0){//最前面的标签按钮
            tagLabel.x = 0;
            tagLabel.y = 0;
        }else{//其他标签按钮
            UILabel *lastTagLabel = self.tagLabels[idx - 1];
            //计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame)+DMTagMargin;
            //计算当前行右边的宽度
            CGFloat rightWidth = self.topView.width - leftWidth;
            
            if(rightWidth >= tagLabel.width){//按钮显示在当前行
                tagLabel.y = lastTagLabel.y;
                tagLabel.x = CGRectGetMaxX(lastTagLabel.frame) + DMTagMargin;
            }else{//按钮显示在下一行
                tagLabel.x = 0;
                tagLabel.y = CGRectGetMaxY(lastTagLabel.frame) + DMTagMargin;
            }
        }
        
        //最后一个标签
        //最后一个标签按钮
        UILabel *lastTagLabel = [self.tagLabels lastObject];
        CGFloat leftWidth = CGRectGetMaxX(lastTagLabel.frame) + DMTagMargin;
        //更新textfield的frame
        if(self.topView.width - leftWidth >=self.addButton.width){
            self.addButton.y = lastTagLabel.y;
            self.addButton.x = leftWidth;
        }else{
            self.addButton.x = 0;
            self.addButton.y = CGRectGetMaxY([[self.tagLabels lastObject] frame]);
        }
        
    }];
    
    //整体的高度
    CGFloat oldH = self.height;
    self.height = CGRectGetMaxY(self.addButton.frame) + 45;
    self.y -= self.height - oldH;
}

-(void)addButtonClick{
    DMAddTagViewController *vc = [[DMAddTagViewController alloc] init];
    WEAK_SELF;
    [vc setTagsBlock:^(NSArray *tags){
        [weakSelf createTagLabels:tags];
    }];
    vc.tags = [self.tagLabels valueForKeyPath:@"text"];
    UIViewController *root = [UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController *)root.presentedViewController;
    [nav pushViewController:vc animated:YES];
    
    //a modal 出 b
//    [a presentViewController:b antmaited:YES completion:nil];
//    a.presentedViewController -> b
//    b.presentingViewController -> a
}

/**
 *  创建标签
 */
-(void)createTagLabels:(NSArray *)tags{
    //移除原来的标签label
    [self.tagLabels makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.tagLabels removeAllObjects];
    
    [tags enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *tagLabel = [[UILabel alloc] init];
        [self.tagLabels addObject:tagLabel];
        tagLabel.backgroundColor = DMTagBg;
        tagLabel.textAlignment = NSTextAlignmentCenter;
        tagLabel.text = obj;
        tagLabel.font = DMTagFont;
        //先设置文字和字体后，再进行计算
        [tagLabel sizeToFit];
        tagLabel.width += 2 * DMTagMargin;
        tagLabel.height = DMTagH;
        tagLabel.textColor = [UIColor whiteColor];
        [self.topView addSubview:tagLabel];
        
    }];
    if(tags.count == 0){
        self.addButton.x = DMTopicCellMargin;
    }
    //重新布局子控件
    [self setNeedsLayout];
}

@end

