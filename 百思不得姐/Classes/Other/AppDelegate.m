//
//  AppDelegate.m
//  百思不得姐
//
//  Created by JD_Mac on 16/3/21.
//  Copyright © 2016年 Damon. All rights reserved.
//

#import "AppDelegate.h"
#import "DMTabBarViewController.h"
#import "DMPushGuideView.h"
#import "DMTopWindow.h"
#import "SDWebImageManager.h"
@interface AppDelegate ()<UITabBarControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //设置窗口的跟控制器
    DMTabBarViewController *tabBarController = [[DMTabBarViewController alloc] init];
    tabBarController.delegate = self;
    self.window.rootViewController = tabBarController;
    
    //显示窗口
    [self.window makeKeyAndVisible];
    
//    [DMPushGuideView show];
    
    
    return YES;
}


#pragma mark -<UITabBarControllerDelegate>
-(void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
    //发出一个通知//这里可以不传
//    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
//    userInfo[DMSelectedControllerKey] = viewController;

    [DMNotificationCenter postNotificationName:DMTabBarDidSelectNotification object:nil userInfo:nil];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    dispatch_async(dispatch_get_main_queue(), ^{
        //添加一个window，点击这个window，可以让屏幕上的scrollview滚到顶部
        [DMTopWindow show];
        
    });
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


//当收到Received memory warning.会调用次方法
-(void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    SDWebImageManager *mgr = [SDWebImageManager sharedManager];
    //取消下载
    [mgr cancelAll];
    //清空缓存
    [mgr.imageCache clearMemory];
    
}
@end
