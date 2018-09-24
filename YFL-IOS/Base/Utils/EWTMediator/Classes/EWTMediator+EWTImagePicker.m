//
//  EWTMediator+EWTImagePicker.m
//  EWTMediator
//
//  Created by 李天露 on 2018/5/14.
//

#import "EWTMediator+EWTImagePicker.h"


@implementation EWTMediator (EWTImagePicker)

+ (void)EWTImagePicker_getImageFromCameraWithController:(UIViewController *)controller
                                          authorityType:(SystemAuthority)authorityType
                                              allowCrop:(BOOL)allowCrop
                                             completion:(PickerCompletion)completion {
    NSDictionary* para = @{@"controller":controller,
                           @"authorityType":@(authorityType),
                           @"allowCrop":@(allowCrop),
                           @"completion":completion
                           };
    [[EWTMediator sharedInstance] performTarget:@"EWTImagePicker" action:@"GetImageFromCamera" params:para];
}


+ (void)EWTImagePicker_getImageFromLibraryWithController:(UIViewController *)controller
                                                  maxNum:(NSInteger)maxNum
                                               allowCrop:(BOOL)allowCrop
                                              completion:(PickerCompletion)completion {
    NSDictionary* para = @{@"controller":controller,
                           @"maxNum":@(maxNum),
                           @"allowCrop":@(allowCrop),
                           @"completion":completion
                           };
    [[EWTMediator sharedInstance] performTarget:@"EWTImagePicker" action:@"GetImageFromLibrary" params:para];
}

+ (NSData *)EWTImagePicker_compressImageQualityWithImage:(UIImage *)image toByte:(NSInteger)maxBytes {
    NSDictionary* para = @{@"image":image,
                           @"maxBytes":@(maxBytes)
                           };
    return [[EWTMediator sharedInstance] performTarget:@"EWTImagePicker" action:@"CompressImage" params:para];
}

@end
