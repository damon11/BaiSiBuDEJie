//
//  DMPostWordViewController.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/2.
//  Copyright © 2016年 Damon. All rights reserved.
//  发布文字的控制器

#import "DMPostWordViewController.h"
#import "DMPlaceHolderTextView.h"
@interface DMPostWordViewController ()
/** 文本输入控件 */
@property(nonatomic,strong) DMPlaceHolderTextView *textView;
@end

@implementation DMPostWordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupTextView];
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
    DMPlaceHolderTextView *textView = [[DMPlaceHolderTextView alloc] init];
    textView.frame = self.view.bounds;
    textView.placeHolder = @"拉伸的积分；拉三等奖；发空间了；";
    textView.placeholderColor = [UIColor grayColor];
    [self.view addSubview:textView];
}

-(void)cancel{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)post{
    
}
@end
