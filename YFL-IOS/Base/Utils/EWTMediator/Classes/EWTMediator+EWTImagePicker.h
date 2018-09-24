//
//  EWTMediator+EWTImagePicker.h
//  EWTMediator
//
//  Created by 李天露 on 2018/5/14.
//

#import "EWTMediator.h"

typedef enum : NSInteger {
    SystemAuthorityVideo = 0,             //拍照
    SystemAuthorityLibrary = 1,           //照片
}SystemAuthority;                //系统权限

/**
 *  拍照、选择完成Block
 */
typedef void(^PickerCompletion)(NSArray<UIImage *>* images);

@interface EWTMediator (EWTImagePicker)

/**
 调用相机
 
 @param controller controller
 @param authorityType SystemAuthority
 @param allowCrop 是否允许裁剪
 @param completion completion
 */
+ (void)EWTImagePicker_getImageFromCameraWithController:(UIViewController *)controller
                                          authorityType:(SystemAuthority)authorityType
                                              allowCrop:(BOOL)allowCrop
                                             completion:(PickerCompletion)completion;

/**
 调用照片
 
 @param controller controller
 @param maxNum 最大张数
 @param allowCrop 是否允许裁剪
 @param completion completion
 */
+ (void)EWTImagePicker_getImageFromLibraryWithController:(UIViewController *)controller
                                                  maxNum:(NSInteger)maxNum
                                               allowCrop:(BOOL)allowCrop
                                              completion:(PickerCompletion)completion;

/**
 压缩图片

 @param image 原始image
 @param maxBytes 需要压缩的大小
 @return NSData
 */
+ (NSData *)EWTImagePicker_compressImageQualityWithImage:(UIImage *)image toByte:(NSInteger)maxBytes;

@end
