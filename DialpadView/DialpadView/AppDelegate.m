//
//  AppDelegate.m
//  DialpadView
//
//  Created by 杨桂福 on 2021/3/27.
//

#import "AppDelegate.h"
#import "ViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    ViewController *controller = [[ViewController alloc] init];
    controller.navigationItem.title = @"通话记录";
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:controller];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
