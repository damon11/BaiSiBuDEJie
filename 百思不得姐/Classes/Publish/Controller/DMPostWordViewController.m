//
//  DMPostWordViewController.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/2.
//  Copyright © 2016年 Damon. All rights reserved.
//  发布文字的控制器

#import "DMPostWordViewController.h"
#import "DMPlaceHolderTextView.h"
#import "DMPlaceHolderLabel.h"
#import "DMAddTagToolbar.h"
@interface DMPostWordViewController ()<UITextViewDelegate>
/** 文本输入控件 */
@property(nonatomic,strong) DMPlaceHolderLabel *textView;
/** 工具条 */
@property(nonatomic,weak) DMAddTagToolbar *toolbar;
@end

@implementation DMPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTextView];
    
    [self setupToolbar];
}
-(void)setupNav{
    self.title = @"发表文字";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancel)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:UIBarButtonItemStyleDone target:self action:@selector(post)];
    self.navigationItem.rightBarButtonItem.enabled = NO;//默认不能点
    //强制刷新
    [self.navigationController.navigationBar layoutIfNeeded];
}

-(void)setupTextView{
    DMPlaceHolderLabel *textView = [[DMPlaceHolderLabel alloc] init];
    textView.frame = self.view.bounds;
    textView.placeHolder = @"拉伸的积分；拉三等奖；发空间了；";
    textView.delegate = self;
    textView.placeholderColor = [UIColor grayColor];
    [self.view addSubview:textView];
    self.textView = textView;
}

-(void)setupToolbar{
    //添加工具条控件
    DMAddTagToolbar *toolbar = [DMAddTagToolbar viewFromXib];
    toolbar.width = self.view.width;
    toolbar.y = self.view.height - toolbar.height;
    [self.view addSubview:toolbar];
    self.toolbar = toolbar;
    //监听通知
    [DMNotificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}


-(void)keyboardWillChangeFrame:(NSNotification *)note{
    CGRect keyboardF = [note.userInfo[UIKeyboardFrameEndUserInfoKey ] CGRectValue];
    //动画时间
    CGFloat duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        //设置工具条在键盘消失后的位置
        self.toolbar.transform = CGAffineTransformMakeTranslation(0,keyboardF.origin.y - DMSCREENHEIGTH);
    }];
    
}
//代码或者XIB创建的view从这里调整布局比较好
//-(void)viewDidLayoutSubviews{
//    [super viewDidLayoutSubviews];
//    
//    self.view.width;
//}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)post{
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //先退出之前键盘，再叫出键盘
    [self.view endEditing:YES];
    [self.textView becomeFirstResponder];
}
#pragma mark -<UITextViewDelegate>
-(void)textViewDidChange:(UITextView *)textView{
    
    self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}
@end
