//
//  DMLoginTool.m
//  百思不得姐
//
//  Created by JDM_Mac on 16/6/6.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "DMLoginTool.h"
#import "DMLoginRegisterController.h"
@implementation DMLoginTool



+(void)setUid:(NSString *)uid{
    [[NSUserDefaults standardUserDefaults] setObject:uid forKey:@"uid"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(NSString *)getUid{
    
   return [self getUid:YES];
    
}

+(NSString *)getUid:(BOOL)showLoginController{
    NSString * uid = [[NSUserDefaults standardUserDefaults] stringForKey:@"uid"];
    if(showLoginController){
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            DMLoginRegisterController *login = [[DMLoginRegisterController alloc] init];
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:login animated:YES completion:nil];
        });
    }
   
    return uid;
}
@end
