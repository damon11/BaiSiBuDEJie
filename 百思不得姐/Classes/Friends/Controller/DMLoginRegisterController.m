//
//  DMLoginRegisterController.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/28.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMLoginRegisterController.h"
#import "DMTextField.h"
#import "DMKeyboardTool.h"
@interface DMLoginRegisterController ()<DMKeyboardToolDelegate,UITextFieldDelegate>
/**
 *  用户名field
 */
@property (weak, nonatomic) IBOutlet DMTextField *phoneField;
/**
 *  密码field
 */
@property (weak, nonatomic) IBOutlet DMTextField *snField;
/**
 *  注册用户名field
 */
@property (weak, nonatomic) IBOutlet DMTextField *zcPhoneField;
/**
 *  注册密码field
 */
@property (weak, nonatomic) IBOutlet DMTextField *zcSnField;
/**
 *  field数组
 */
@property (nonatomic, strong) NSArray *fields;
/**
 *  feild父控件
 */
@property (weak, nonatomic) IBOutlet UIView *fieldBackView;
/**
 *  注册背景
 */
@property (weak, nonatomic) IBOutlet UIView *zcFieldBackView;
/**
 *  登录框距离控制器左边的距离
 */
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewLeftMargin;
@property (nonatomic, assign) BOOL isLogin;
/**
 *  自定义toolBar
 */
@property (nonatomic,weak) DMKeyboardTool *toolBar;
@end

@implementation DMLoginRegisterController

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _fields = (_isLogin ? @[self.zcPhoneField,self.zcSnField]:@[self.phoneField,self.snField]);

    
    DMKeyboardTool *toolBar = [DMKeyboardTool tool];
    toolBar.toolbarDelegate = self;
    self.toolBar = toolBar;
    //设置键盘弹出后显示自定义的toolBar控件
     self.phoneField.inputAccessoryView = toolBar;
     self.snField.inputAccessoryView = toolBar;
     self.zcPhoneField.inputAccessoryView = toolBar;
     self.zcSnField.inputAccessoryView = toolBar;
    //设置textfield代理
     self.phoneField.delegate = self;
     self.snField.delegate = self;
     self.zcPhoneField.delegate = self;
     self.zcSnField.delegate = self;
//   //文字属性
//    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
//    attrs[NSForegroundColorAttributeName] = [UIColor grayColor];
//    
//    
//    NSAttributedString *placeholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:attrs];
//    self.phoneField.attributedPlaceholder = placeholder;
    
}

#pragma mark -<DMKeyboardToolDelegate>-
-(void)keyboardTool:(DMKeyboardTool *)tool didClickItem:(DMKeyboardToolItem)item{
    if(item == DMKeyboardToolItemPrevious){//上一项
        NSUInteger currentIndex = 0;
        for(UIView *view in (_isLogin ? self.zcFieldBackView.subviews : self.fieldBackView.subviews)){
            if([view isFirstResponder]){
                currentIndex = [self.fields indexOfObject:view];
            }
        }
        currentIndex--;
        [self.fields[currentIndex] becomeFirstResponder];
        DXLog(@"%lu",(unsigned long)currentIndex);
        self.toolBar.previousItem.enabled = (currentIndex != 0);
        self.toolBar.nextItem.enabled = YES;
    }else if (item == DMKeyboardToolItemNext){//下一项
        NSUInteger currentIndex = 0;
        for(UIView *view in (_isLogin ? self.zcFieldBackView.subviews : self.fieldBackView.subviews)){
            if([view isFirstResponder]){
                currentIndex = [self.fields indexOfObject:view];
            }
        }
        currentIndex++;
        [self.fields[currentIndex] becomeFirstResponder];
        DXLog(@"%lu",currentIndex);
        self.toolBar.previousItem.enabled = YES;
        self.toolBar.nextItem.enabled = (currentIndex != self.fields.count - 1);
    }else if (item == DMKeyboardToolItemDone){//完成
        [self.view endEditing:YES];
    }
    
}

/**
 *  让当前控制器状态栏为白色
 */
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
- (IBAction)showloginOrRegister:(UIButton *)button {
        [self.view endEditing:YES];
    if(self.loginViewLeftMargin.constant == 0){//显示注册界面
        _isLogin = YES;
        self.loginViewLeftMargin.constant = - self.view.width;
        [button setTitle:@"已有账号?" forState:UIControlStateNormal];
    }else{
        _isLogin = NO;
        self.loginViewLeftMargin.constant = 0;
        [button setTitle:@"注册账号" forState:UIControlStateNormal];
    }
    _fields = _isLogin ? @[self.zcPhoneField,self.zcSnField] : @[self.phoneField,self.snField];
    [UIView animateWithDuration:0.25 animations:^{
        [self.view layoutIfNeeded];
    }];
}


#pragma mark -<UITextFieldDelegate>-
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField == (_isLogin ? self.zcPhoneField:self.phoneField)) {
        // 让snField成为第一响应者
        [(_isLogin ? self.zcSnField :self.snField )becomeFirstResponder];
    } else if (textField == (_isLogin ? self.zcSnField:self.snField)) {
        
        [self.view endEditing:YES];
    }
    return YES;
}
- (IBAction)back:(id)sender {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    NSUInteger currentIndex = [self.fields indexOfObject:textField];
    self.toolBar.previousItem.enabled = (currentIndex != 0);
    self.toolBar.nextItem.enabled = (currentIndex != self.fields.count - 1);
}
@end
