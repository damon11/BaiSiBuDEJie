//
//  DMMeFooterView.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/1.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMMeFooterView.h"
#import "AFNetworking.h"
#import "DMSquare.h"
#import "MJExtension.h"
#import "DMSquareButton.h"
#import "DMWebViewController.h"
@interface DMMeFooterView()

@end
@implementation DMMeFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame]){
        self.backgroundColor = [UIColor clearColor];
        //参数
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        params[@"a"] = @"square";
        params[@"c"] = @"topic";
       
        //发送请求
        [[AFHTTPSessionManager manager] GET:@"http://api.budejie.com/api/api_open.php" parameters:params success:^(NSURLSessionDataTask * task, id responseObject) {
            NSArray *square = [DMSquare mj_objectArrayWithKeyValuesArray:responseObject[@"square_list"]];
            
            //创建方块
            [self creatSquares:square];
            } failure:^(NSURLSessionDataTask *  task, NSError *  error) {
            
        }];

    }
       return self;
}

-(void)creatSquares:(NSArray *)squares{
    
    //一行最多4列
    int maxCols = 4;
    
    //宽度和高度
    CGFloat buttonW = DMSCREENWIDTH /maxCols;
    CGFloat buttonH = buttonW;
    
    for (int i= 0; i<squares.count; i++) {
        DMSquare *square = squares[i];
        //创建按钮
        DMSquareButton *button = [DMSquareButton buttonWithType:UIButtonTypeCustom];
        //监听点击
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        //传值模型
        button.square = squares[i];
        [button setTitle:square.name forState:UIControlStateNormal];
        
        [self addSubview:button];
        
        //计算frame
        int col = i % maxCols;
        int row = i / maxCols;
        
        button.x = col * buttonW;
        button.y = row * buttonH;
        button.width = buttonW;
        button.height = buttonH;
        
        //第一种方法：计算footerView的高度
        self.height = CGRectGetMaxY(button.frame);
      
        //第二种方法：另外根据行数算高度
//        NSUInteger rows = squares.count /maxCols;
//        if(squares.count % maxCols){//不能整除,+1
//            rows++;
//        }
        //第二种分方法：万能分页公式 总页数 == （总个数 + 每页的最大数 - 1）/ 每页最大数
//        NSUInteger rows = (squares.count + maxCols -1) /maxCols;
//        self.height = rows * buttonH;
    }
    
    //重绘
    [self setNeedsDisplay];
}

//设置背景图片
//-(void)drawRect:(CGRect)rect{
//    [[UIImage imageNamed:@"mainCellBackground"] drawInRect:rect];
//}

-(void)buttonClick:(DMSquareButton *)button{
    if(![button.square.url hasPrefix:@"http"]) return;
    
    DMWebViewController *web = [[DMWebViewController alloc] init];
    web.url = button.square.url;
    web.title = button.square.name;
    
    //取出当前的导航控制器
    UITabBarController *tabBarVc = (UITabBarController*)[UIApplication sharedApplication].keyWindow.rootViewController;
    UINavigationController *nav = (UINavigationController*)tabBarVc.selectedViewController;
    [nav pushViewController:web animated:YES];
}
@end
