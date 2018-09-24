//
//  EWTImagePickerTool.h
//  Ewt360
//
//  Created by 李天露 on 2018/2/23.
//  Copyright © 2018年 铭师堂. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSInteger {
    SystemAuthorityVideo = 0,             //拍照
    SystemAuthorityLibrary = 1,           //照片
}SystemAuthority;                //系统权限

/**
 *  拍照、选择完成Block
 */
typedef void(^PickerCompletion)(NSArray<UIImage *>* images);


@interface EWTImagePickerTool : NSObject

+ (EWTImagePickerTool *)sharedInstance;

/**
 调用相机

 @param controller controller
 @param authorityType SystemAuthority
 @param allowsEditing 是否允许裁剪
 @param completion completion
 */
- (void)getImageFromCameraWithController:(UIViewController *)controller authorityType:(SystemAuthority)authorityType allowsEditing:(BOOL)allowsEditing completion:(PickerCompletion)completion;

/**
 调用照片

 @param controller controller
 @param maxNum 最大张数
 @param allowCrop 是否允许裁剪
 @param completion completion
 */
- (void)getImageFromLibraryWithController:(UIViewController *)controller maxNum:(NSInteger)maxNum allowCrop:(BOOL)allowCrop completion:(PickerCompletion)completion;


@end
