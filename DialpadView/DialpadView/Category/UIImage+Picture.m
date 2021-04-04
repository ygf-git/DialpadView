//
//  UIImage+LGExtension.m
//  dingdingIcon
//
//  Created by lingo on 2017/2/28.
//  Copyright © 2017年 livefor. All rights reserved.
//

#import "UIImage+Picture.h"

@implementation UIImage (Extension)

+ (UIImage *)imageWithText:(NSString *)name {
    
    name=[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *text = name.length > 0 ? [name.uppercaseString substringToIndex:1] : name.uppercaseString;
    
    NSDictionary *fontAttributes = @{NSFontAttributeName: FontsizeMedium4, NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    CGSize textSize = [text sizeWithAttributes:fontAttributes];
    
    CGPoint drawPoint = CGPointMake((36 - textSize.width)/2, (36 - textSize.height)/2);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(36, 36), NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 36, 36) cornerRadius:4];
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRGB:0x45A5D9].CGColor);
    
    [path fill];
    
    [text drawAtPoint:drawPoint withAttributes:fontAttributes];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return resultImg;
}

+ (UIImage *)circleImageWithText:(NSString *)name {
    
    name=[name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSString *text = name.length > 0 ? [name.uppercaseString substringToIndex:1] : name.uppercaseString;
    
    NSDictionary *fontAttributes = @{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    CGSize textSize = [text sizeWithAttributes:fontAttributes];
    
    CGPoint drawPoint = CGPointMake((8 - textSize.width)/2, (8 - textSize.height)/2);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(8, 8), NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, 8, 8)];
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithRGB:0x1f82d3].CGColor);
    
    [path fill];
    
    [text drawAtPoint:drawPoint withAttributes:fontAttributes];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return resultImg;
}

+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)imageByColor:(UIColor *)color size:(CGSize)size {
    
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:5];
    
    CGContextSetFillColorWithColor(ctx, color.CGColor);
    
    [path fill];
    
    UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();

    return resultImg;
}


@end
