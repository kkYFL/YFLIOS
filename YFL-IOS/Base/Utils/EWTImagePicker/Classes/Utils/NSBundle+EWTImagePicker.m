//
//  NSBundle+EWTImagePicker.m
//  EWTImagePicker
//
//  Created by 李天露 on 2018/5/15.
//

#import "NSBundle+EWTImagePicker.h"
#import "EWTImagePickerTool.h"

@implementation NSBundle (EWTImagePicker)

+ (instancetype)EWTImagePickerBundle
{
    static NSBundle *ImagePickerBundle = nil;
    if (ImagePickerBundle == nil) {
        // 这里不使用mainBundle是为了适配pod 1.x和0.x
        NSBundle *bundle = [NSBundle bundleForClass:[EWTImagePickerTool class]];
        NSString* filePath = [bundle pathForResource:@"EWTImagePicker" ofType:@"bundle"];
        NSBundle *fileBundle = [NSBundle bundleWithPath:filePath];
        filePath = [fileBundle pathForResource:@"EWTImagePicker" ofType:@"bundle"];
        ImagePickerBundle = [NSBundle bundleWithPath:filePath];
    }
    return ImagePickerBundle;
}

@end
