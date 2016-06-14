//
//  DMMeViewController.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/21.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMMeViewController.h"
#import "DMMeCell.h"
#import "DMMeFooterView.h"
#import "AFNetworking.h"
#import "DMSettingViewController.h"
#import "DMLoginRegisterController.h"
@interface DMMeViewController ()

@property (nonatomic,strong) UIButton *btnRight;
@property (nonatomic,strong) UIButton *btnLeft;
@property (nonatomic,strong) UIView *verticalLine;
@end

@implementation DMMeViewController

static NSString *DMMeId = @"me";

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self setupNav];
     [self setupTableView];
    
}
-(void)setupNav{
    //设置导航栏标题
    self.navigationItem.title = @"我的";
    
    //设置导航栏右侧的按钮
    UIBarButtonItem *settingItem = [UIBarButtonItem itemWithImage:@"mine-setting-icon" highImage:@"mine-setting-icon-click" target:self action:@selector(settingClick)];
    UIBarButtonItem *moonItem = [UIBarButtonItem itemWithImage:@"mine-moon-icon" highImage:@"mine-moon-icon-click" target:self action:@selector(nightModeClick)];
    self.navigationItem.rightBarButtonItems = @[settingItem,moonItem];
}
-(void)setupTableView{
    
    //设置背景色
    self.view.backgroundColor = DXGlobalBg;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[DMMeCell class]forCellReuseIdentifier:DMMeId];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    //设置header和footer
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = DMTopicCellMargin;
    
    
    
    //设置footerView
    self.tableView.tableFooterView = [[DMMeFooterView alloc] init];
    //调整inset

    self.tableView.contentInset = UIEdgeInsetsMake(DMTopicCellMargin - 35, 0, 850, 0);
}
-(void)settingClick
{
    DXLogFunc;
    DMSettingViewController *vc = [[DMSettingViewController alloc]initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)nightModeClick
{
    DXLogFunc;
}

#pragma mark - 数据源方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DMMeCell *cell = [tableView dequeueReusableCellWithIdentifier:DMMeId];
    if(indexPath.section == 0){
        cell.textLabel.text = @"登陆/注册";
        cell.imageView.image = [UIImage imageNamed:@"mine_icon_nearby"];
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 1){
        cell.textLabel.text = @"离线下载";
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
    }else if (indexPath.section == 2) {
        [cell addSubview:self.btnLeft];
        [cell addSubview:self.btnRight];
        [cell addSubview:self.verticalLine];
    }

   
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section == 0){
        DMLoginRegisterController *login = [[DMLoginRegisterController alloc] init];
        [self.navigationController presentViewController:login animated:YES completion:nil];
    }
}

- (UIButton *)btnLeft{
    if (_btnLeft == nil) {
        _btnLeft = [[UIButton alloc]init];
        _btnLeft.frame = CGRectMake(0, 0, DMSCREENWIDTH/2, 44);
        [_btnLeft setTitle:@"#自拍#" forState:UIControlStateNormal];
        _btnLeft.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnLeft setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        
        
    }
    return _btnLeft;
}

- (UIButton *)btnRight{
    if (_btnRight == nil) {
        _btnRight = [[UIButton alloc]init];
        _btnRight.frame = CGRectMake(DMSCREENWIDTH/2, 0,DMSCREENWIDTH/2, 44);
        [_btnRight setTitle:@"#我是段子手#" forState:UIControlStateNormal];
        _btnRight.titleLabel.font = [UIFont systemFontOfSize:15];
        [_btnRight setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
       
    }
    return _btnRight;
}

- (UIView *)verticalLine{
    if (_verticalLine == nil) {
        _verticalLine = [[UIView alloc]init];
        _verticalLine.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.3];
        _verticalLine.frame = CGRectMake(DMSCREENWIDTH/2, 2, 0.5, 40);
        
    }
    return _verticalLine;
}

@end
