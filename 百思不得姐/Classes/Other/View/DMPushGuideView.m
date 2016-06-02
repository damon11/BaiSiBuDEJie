//
//  DMPushGuideView.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/3/31.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMPushGuideView.h"

@implementation DMPushGuideView

+(void)show{
    NSString *key = @"CFBundleShortVersionString";
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    NSString *sanboxVersion = [[NSUserDefaults standardUserDefaults] stringForKey:key];
//    DXLog(@"%@",[NSBundle mainBundle].infoDictionary);
    
    if(![currentVersion isEqualToString:sanboxVersion]){
        
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        //显示推送引导界面
        DMPushGuideView *guideView = [DMPushGuideView guideView];
        guideView.frame = window.bounds;
        [window addSubview:guideView];
        
        //存储版本号
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        //马上同步进去
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


+(instancetype)guideView{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
}
- (IBAction)close:(id)sender {
    [self removeFromSuperview];
}



@end
