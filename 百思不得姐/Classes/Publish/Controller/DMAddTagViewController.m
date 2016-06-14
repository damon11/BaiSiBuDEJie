//
//  DMAddTagViewController.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/2.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMAddTagViewController.h"
#import "DMTagButton.h"
#import "DMTagTextField.h"
@interface DMAddTagViewController ()<UITextFieldDelegate>
/** 内容 */
@property(nonatomic,weak) UIView *contentView;
/** 文本输入框 */
@property(nonatomic,weak) DMTagTextField *textField;
/** 添加按钮 */
@property(nonatomic,weak) UIButton *addButton;
/** 所有的标签按钮 */
@property(nonatomic,strong) NSMutableArray *tagButtons;
@end

@implementation DMAddTagViewController

#pragma mark -懒加载
-(NSMutableArray *)tagButtons{
    if(!_tagButtons){
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

-(UIButton *)addButton{
    if(!_addButton){
       UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        addButton.height = 35;
        addButton.backgroundColor = DMTagBg;
        [addButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        addButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [addButton addTarget:self action:@selector(addButtonClick) forControlEvents:UIControlEventTouchUpInside];
        addButton.contentEdgeInsets = UIEdgeInsetsMake(0, DMTagMargin, 0, DMTagMargin);
        addButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [self.contentView addSubview:addButton];
        _addButton = addButton;
    }
    return _addButton;
}

-(UIView *)contentView{
    if(!_contentView){
        UIView *contentView = [[UIView alloc] init];
        [self.view addSubview:contentView];
        self.contentView = contentView;
    }
    return _contentView;
}

-(DMTagTextField *)textField{
    if(!_textField){
        DMTagTextField *textField = [[DMTagTextField alloc] init];
        textField.delegate = self;
        
        WEAK_SELF;
        textField.deleteBlock = ^{
            if(weakSelf.textField.hasText) return ;
            
            [weakSelf tagButtonClick:[weakSelf.tagButtons lastObject]];
        };
        
        [textField addTarget:self action:@selector(textDidChange) forControlEvents:UIControlEventEditingChanged];
        [textField becomeFirstResponder];
        [self.contentView addSubview:textField];
        self.textField = textField;
    }
    return _textField;
}

#pragma mark -初始化
-(void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    
}

-(void)setupNav{
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加标签";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(done)];
    
}

-(void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    self.contentView.x = DMTagMargin;
    self.contentView.width = self.view.width - 2 * self.contentView.x;
    self.contentView.y = 64 + DMTagMargin;
    self.contentView.height = DMSCREENHEIGTH;
    
    self.textField.width = self.contentView.width;
    self.addButton.width = self.contentView.width;
    
    [self setupTags];
}

-(void)setupTags{
    
    if(self.tags.count){
        [self.tags enumerateObjectsUsingBlock:^(NSString *tag, NSUInteger idx, BOOL * _Nonnull stop) {
            self.textField.text = tag;
            [self addButtonClick];
        }];
    }else{
         self.tags = nil;
         self.addButton.hidden = YES;
    }
    
   
    
}

-(void)done{
    
    //传递数据给上一个控制器
    NSArray *tags = [self.tagButtons valueForKeyPath:@"currentTitle"];
    
    !self.tagsBlock ? :self.tagsBlock(tags);
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -监听文字改变
-(void)textDidChange{
    //根据文字实时更新
    //更新文本框的frame
    [self updateTextFieldFrame];
    
    if(self.textField.hasText){//有文字
        
        //显示添加标签按钮
        self.addButton.hidden = NO;
        self.addButton.y = CGRectGetMaxY(self.textField.frame) + DMTagMargin;
        [self.addButton setTitle:[NSString stringWithFormat:@"添加标签:%@",self.textField.text] forState:UIControlStateNormal];
        
        //获取最后一个输入字符
        NSString *text = self.textField.text;
        NSUInteger len = text.length;
        NSString *lastLetter = [text substringFromIndex:len -1];
//        DXLog(@"%@",lastLetter);
        if(([lastLetter isEqualToString:@","]||[lastLetter isEqualToString:@"，"]) && len>1){
            //去除逗号
            self.textField.text = [text substringToIndex:len - 1];
            
            [self addButtonClick];
        }
    }else{//没有文字
        //隐藏添加标签按钮
        self.addButton.hidden = YES;
    }
    
    
}

#pragma mark -监听按钮点击
//监听添加标签按钮点击
-(void)addButtonClick{
    if(self.tagButtons.count == 5){
        [self showHint:@"最多添加5个标签"];
        return;
    }
    //添加一个“标签按钮”
    DMTagButton *tagButton = [DMTagButton buttonWithType:UIButtonTypeCustom];
    [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [tagButton setTitle:self.textField.text forState:UIControlStateNormal];
    tagButton.height = self.textField.height;
    [self.contentView addSubview:tagButton];
    [self.tagButtons addObject:tagButton];
    
    //更新标签按钮的frame
    [self updateTagButtonFrame];
    [self updateTextFieldFrame];
    //清空textField文字
    self.textField.text = nil;
    self.addButton.hidden = YES;
}

-(void)tagButtonClick:(DMTagButton *)tagButton{
    [tagButton removeFromSuperview];
    [self.tagButtons removeObject:tagButton];
    
    
    //动画
    [UIView animateWithDuration:0.2 animations:^{
        //重新更新所有标签的frame
        [self updateTagButtonFrame];
        [self updateTextFieldFrame];
    }];
    
}

#pragma mark -子控件的frame处理
/**
 *  专门用来更新标签按钮的frame
 */
-(void)updateTagButtonFrame{
    
    for (int i = 0; i <self.tagButtons.count; i++) {
        DMTagButton *tagButton = self.tagButtons[i];
        
        if(i == 0){//最前面的标签按钮
            tagButton.x = 0;
            tagButton.y = 0;
        }else{//其他标签按钮
            DMTagButton *lastTagButton = self.tagButtons[i - 1];
            //计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame)+DMTagMargin;
            //计算当前行右边的宽度
            CGFloat rightWidth = self.contentView.width - leftWidth;
            
            if(rightWidth >= tagButton.width){//按钮显示在当前行
                tagButton.y = lastTagButton.y;
                tagButton.x = CGRectGetMaxX(lastTagButton.frame) + DMTagMargin;
            }else{//按钮显示在下一行
                tagButton.x = 0;
                tagButton.y = CGRectGetMaxY(lastTagButton.frame) + DMTagMargin;
            }
        }
    }
    
    [self updateTextFieldFrame];
}
/**
 *  更新textfield的frame
 */
-(void)updateTextFieldFrame{
    //最后一个标签按钮
    DMTagButton *lastTagButton = [self.tagButtons lastObject];
    CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + DMTagMargin;
    //更新textfield的frame
    if(self.contentView.width - leftWidth >=[self textFieldTextWidth]){
        self.textField.y = lastTagButton.y;
        self.textField.x = leftWidth;
    }else{
        self.textField.x = 0;
        self.textField.y = CGRectGetMaxY([[self.tagButtons lastObject] frame]);
    }
    
    //更新“添加标签"的frame
    self.addButton.y = CGRectGetMaxY(self.textField.frame) + DMTagMargin;

}
/**
 *  textField的文字宽度
 */
-(CGFloat)textFieldTextWidth{
    CGFloat textW = [self.textField.text sizeWithAttributes:@{NSFontAttributeName : self.textField.font}].width;
    return MAX(100, textW);
}

#pragma mark -<UITextFieldDelegate>
/**
 *  监听键盘右下角按钮的点击(return key,比如“换行”，“完成”等等)
 */
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField.hasText){
        [self addButtonClick];
    }
    return YES;
}

@end
