//
//  UIImage+LGExtension.h
//  dingdingIcon
//
//  Created by lingo on 2017/2/28.
//  Copyright © 2017年 livefor. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Extension)

/*
 * 生成一张图片
 * text  文字
 */
+ (UIImage *)imageWithText:(NSString *)name;

+ (UIImage *)circleImageWithText:(NSString *)name;

+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;

+ (UIImage *)imageByColor:(UIColor *)color size:(CGSize)size;

@end
