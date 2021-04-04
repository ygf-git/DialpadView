//
//  DialPadTextField.m
//  Linkus
//
//  Created by 杨桂福 on 2021/1/11.
//  Copyright © 2021 Yeastar Technology Co., Ltd. All rights reserved.
//

#import "DialPadTextField.h"

@implementation DialPadTextField

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return [super canPerformAction:action withSender:sender];
}

- (void)paste:(id)sender {
    NSString *string = [UIPasteboard generalPasteboard].string;
    NSString *number = [DialPadTextField smartTranslation:string];
    [self ys_updateText:number];
}

+ (NSString *)smartTranslation:(NSString *)string {
    NSString *filter =  [[string componentsSeparatedByCharactersInSet:
                          [[NSCharacterSet characterSetWithCharactersInString:@"0123456789*+#abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet]]
                         componentsJoinedByString:@""];
    NSMutableString *mapper = [NSMutableString string];
    for (int i = 0; i < [filter length]; i++) {
        unichar curChar = [filter characterAtIndex:i];
        if ( curChar >= '0' && curChar <= '9') {
            [mapper appendString:[NSString stringWithFormat:@"%C",curChar]];
        }else if (curChar == '*' || curChar == '+'|| curChar == '#'){
            [mapper appendString:[NSString stringWithFormat:@"%C",curChar]];
        }else{
            int distance = 0;
            if (curChar >= 'A' && curChar <= 'Z'){
                distance = curChar - 'A';
                
            }else if (curChar >= 'a' && curChar <= 'z'){
                distance = curChar - 'a';
            }else
            continue;//protect
            int map = distance / 3;
            if (distance == 18 || distance == 21) {
                map += 1;
            }else{
                map += 2;
            }
            if (map > 9) {
                map = 9;
            }
            [mapper appendString:[NSString stringWithFormat:@"%d",map]];
        }
    }
    return mapper;
}

@end
