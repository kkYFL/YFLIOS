//
//  CLInputTextView.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/11/9.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "CLInputTextView.h"

@implementation CLInputTextView


// 继承UITextView重写这个方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    if (self.canPaste) {
        // 返回NO为禁用，YES为开启
        // 粘贴
        if (action == @selector(paste:)) return NO;
    }
    
    return [super canPerformAction:action withSender:sender];
}

@end
