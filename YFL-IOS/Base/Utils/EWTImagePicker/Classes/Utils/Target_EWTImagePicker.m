//
//  Target_EWTImagePicker.m
//  Pods
//
//  Created by 李天露 on 2018/5/14.
//

#import "Target_EWTImagePicker.h"
#import "EWTImagePickerTool.h"
#import "UIImage+Helper.h"

@implementation Target_EWTImagePicker

-(id)Action_GetImageFromCamera:(NSDictionary *)params {
    UIViewController* controller = params[@"controller"];
    SystemAuthority authorityType = [params[@"authorityType"] integerValue];
    BOOL allowCrop = [params[@"allowCrop"] boolValue];
    PickerCompletion completion = [params[@"completion"] copy];
    [[EWTImagePickerTool sharedInstance] getImageFromCameraWithController:controller authorityType:authorityType allowsEditing:allowCrop completion:completion];
    return nil;
}


-(id)Action_GetImageFromLibrary:(NSDictionary *)params{
    UIViewController* controller = params[@"controller"];
    NSInteger maxNum = [params[@"maxNum"] integerValue];
    BOOL allowCrop = [params[@"allowCrop"] boolValue];
    PickerCompletion completion = [params[@"completion"] copy];
    [[EWTImagePickerTool sharedInstance] getImageFromLibraryWithController:controller maxNum:maxNum allowCrop:allowCrop completion:completion];
    return nil;
}

- (NSData *)Action_CompressImage:(NSDictionary *)params {
    UIImage* imageOri = params[@"image"];
    NSInteger maxBytes = [params[@"maxBytes"] integerValue];
    return [UIImage compressImageQualityWithImage:imageOri toByte:maxBytes];
}

@end
