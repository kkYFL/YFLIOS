//
//  EWTImagePickerTool.m
//  Ewt360
//
//  Created by 李天露 on 2018/2/23.
//  Copyright © 2018年 铭师堂. All rights reserved.
//

#import "EWTImagePickerTool.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/ALAsset.h>
#import "YSHYClipViewController.h"
#import "DNImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "DNAsset.h"
#import "NSURL+DNIMagePickerUrlEqual.h"
#import "NSBundle+EWTImagePicker.h"

#define WEAKSELF typeof(self) __weak weakSelf = self;

@interface EWTImagePickerTool ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate,ClipViewControllerDelegate,UIAlertViewDelegate,DNImagePickerControllerDelegate>

@property (nonatomic, assign) BOOL allowsEditing;               ///照片是否可编辑
@property (nonatomic, weak) UIViewController *viewController;   ///操作拍照、选择照片的controller
@property (nonatomic, copy) PickerCompletion completion;
@property (nonatomic, strong) NSMutableArray* pickImageArray;          ///选中的照片

@end

@implementation EWTImagePickerTool

+ (EWTImagePickerTool *)sharedInstance {
    static EWTImagePickerTool *sharedInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.pickImageArray = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}

#pragma mark 调用相机
- (void)getImageFromCameraWithController:(UIViewController *)controller authorityType:(SystemAuthority)authorityType allowsEditing:(BOOL)allowsEditing completion:(PickerCompletion)completion {
    self.allowsEditing = allowsEditing;
    self.completion = [completion copy];
    self.viewController = controller;
    
    if ([self getSystemAuthorityWithType:authorityType]) {
        [self initImagePickerWithSourceType:authorityType controller:controller];
    }
}

- (void)initImagePickerWithSourceType:(SystemAuthority)authorityType controller:(UIViewController *)controller {
    switch (authorityType) {
        case SystemAuthorityVideo: {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                picker.delegate = self;
                picker.allowsEditing = NO;
                picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.viewController presentViewController:picker animated:YES completion:nil];
            } else {
#if TARGET_IPHONE_SIMULATOR
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"模拟器中无法打开相机，您可以选择跳转到相册!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
#endif
            }
        }
            break;

        case SystemAuthorityLibrary: {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = self.allowsEditing;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.viewController presentViewController:picker animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    NSString *key = UIImagePickerControllerOriginalImage;
    UIImage *editImage = [info objectForKey:key];
    if (editImage && picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        //保存照片到系统相册
//        UIImageWriteToSavedPhotosAlbum(editImage, nil, nil, nil);
    }
    
    WEAKSELF
    if (self.allowsEditing) {
        YSHYClipViewController * clipView = [[YSHYClipViewController alloc]initWithImage:editImage];
        clipView.delegate = self;
        clipView.clipType = SQUARECLIP;
        clipView.radius = MAXFLOAT;//支持圆形:CIRCULARCLIP 方形裁剪:SQUARECLIP   默认:圆形裁剪
        [self.viewController.navigationController pushViewController:clipView animated:NO];
        [picker dismissViewControllerAnimated:YES completion:nil];
    }else {
        [picker dismissViewControllerAnimated:YES completion:^{
            if (weakSelf.completion && editImage) {
                weakSelf.completion(@[editImage]);
                weakSelf.completion = nil;
            }
            
        }];
    }
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        if (self.completion) {
            self.completion(nil);
            self.completion = nil;
        }
    }];
}

#pragma mark - 调用相册

- (void)getImageFromLibraryWithController:(UIViewController *)controller maxNum:(NSInteger)maxNum allowCrop:(BOOL)allowCrop completion:(PickerCompletion)completion {
    self.allowsEditing = maxNum > 1 ? NO : allowCrop;
    self.completion = [completion copy];
    self.viewController = controller;
    
    if ([self getSystemAuthorityWithType:SystemAuthorityLibrary]) {
        [self initPickerWithMaxNum:maxNum allowCrop:allowCrop];
    }
}

- (void)initPickerWithMaxNum:(NSInteger)maxNum allowCrop:(BOOL)allowCrop {
    DNImagePickerController *imagePicker = [[DNImagePickerController alloc] init];
    imagePicker.maxImagesCount = maxNum;
    imagePicker.imagePickerDelegate = self;
    [self.viewController presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark - DNImagePickerControllerDelegate

- (void)dnImagePickerController:(DNImagePickerController *)imagePickerController sendImages:(NSArray *)imageAssets isFullImage:(BOOL)fullImage
{
    [self.pickImageArray removeAllObjects];
    ALAssetsLibrary *lib = [ALAssetsLibrary new];
    WEAKSELF
    //大于一张图，无法裁剪
    if (imageAssets.count > 1) {
        dispatch_group_t group = dispatch_group_create();
        
        for (NSInteger i = 0; i < imageAssets.count; i++) {
            dispatch_group_enter(group);
            DNAsset *dnasset = imageAssets[i];
            [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset){
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (asset) {
                    UIImage* image = [strongSelf getImageWithDNAsset:asset isFullImage:fullImage];
                    [self.pickImageArray addObject:image];
                    dispatch_group_leave(group);
                } else {
                    // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                    [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                       usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
                         [group enumerateAssetsWithOptions:NSEnumerationReverse
                                                usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                    dispatch_group_leave(group);
                                                    if([[result valueForProperty:ALAssetPropertyAssetURL] isEqual:dnasset.url])
                                                    {
                                                        UIImage* image = [strongSelf getImageWithDNAsset:result isFullImage:fullImage];
                                                        [self.pickImageArray addObject:image];
                                                        *stop = YES;
                                                    }
                                                    
                                                }];
                     }
                     failureBlock:^(NSError *error) {
                         dispatch_group_leave(group);
                     }];
                }
                
            } failureBlock:^(NSError *error){
                dispatch_group_leave(group);
            }];
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            //回传图片
            if (self.completion) {
                self.completion(self.pickImageArray.copy);
                self.completion = nil;
            }
            [imagePickerController dismissViewControllerAnimated:YES completion:^{
                
            }];
        });
        
    }else if (imageAssets.count == 1) {//只有一张图
        
        DNAsset *dnasset = [imageAssets firstObject];
        [lib assetForURL:dnasset.url resultBlock:^(ALAsset *asset){
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (asset) {
                UIImage* image = [strongSelf getImageWithDNAsset:asset isFullImage:fullImage];
                if (self.allowsEditing) {
                    YSHYClipViewController * clipView = [[YSHYClipViewController alloc]initWithImage:image];
                    clipView.delegate = self;
                    clipView.clipType = SQUARECLIP;
                    clipView.radius = MAXFLOAT;//支持圆形:CIRCULARCLIP 方形裁剪:SQUARECLIP   默认:圆形裁剪
                    [self.viewController.navigationController pushViewController:clipView animated:NO];
                }else {
                    if (self.completion) {
                        self.completion(@[image]);
                        self.completion = nil;
                    }
                    [imagePickerController dismissViewControllerAnimated:YES completion:^{
                        
                    }];
                }
            } else {
                // On iOS 8.1 [library assetForUrl] Photo Streams always returns nil. Try to obtain it in an alternative way
                [lib enumerateGroupsWithTypes:ALAssetsGroupPhotoStream
                                   usingBlock:^(ALAssetsGroup *group, BOOL *stop)
                 {
                     [group enumerateAssetsWithOptions:NSEnumerationReverse
                                            usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
                                                
                                                if([[result valueForProperty:ALAssetPropertyAssetURL] isEqual:dnasset.url])
                                                {
                                                    UIImage* image = [strongSelf getImageWithDNAsset:result isFullImage:fullImage];
                                                    if (self.allowsEditing) {
                                                        YSHYClipViewController * clipView = [[YSHYClipViewController alloc]initWithImage:image];
                                                        clipView.delegate = self;
                                                        clipView.clipType = SQUARECLIP;
                                                        clipView.radius = MAXFLOAT;//支持圆形:CIRCULARCLIP 方形裁剪:SQUARECLIP   默认:圆形裁剪
                                                        [self.viewController.navigationController pushViewController:clipView animated:NO];
                                                    }else {
                                                        if (self.completion) {
                                                            self.completion(@[image]);
                                                            self.completion = nil;
                                                        }
                                                        [imagePickerController dismissViewControllerAnimated:YES completion:^{
                                                            
                                                        }];
                                                    }
                                                    *stop = YES;
                                                }
                                            }];
                 }
                                 failureBlock:^(NSError *error)
                 {
                     if (self.completion) {
                         self.completion(nil);
                         self.completion = nil;
                     }
                     [imagePickerController dismissViewControllerAnimated:YES completion:^{
                         
                     }];
                     
                 }];
            }
            
        } failureBlock:^(NSError *error){
            if (self.completion) {
                self.completion(nil);
                self.completion = nil;
            }
            [imagePickerController dismissViewControllerAnimated:YES completion:^{
                
            }];
        }];
    }
}

- (UIImage*)getImageWithDNAsset:(ALAsset *)asset isFullImage:(BOOL)isFullImage {
    if (!asset) {
        
        return [[UIImage imageWithContentsOfFile:[[NSBundle EWTImagePickerBundle] pathForResource:@"assets_placeholder_picture" ofType:@"png"]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }
    
    UIImage *image;
    if (isFullImage) {
        NSNumber *orientationValue = [asset valueForProperty:ALAssetPropertyOrientation];
        UIImageOrientation orientation = UIImageOrientationUp;
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
        
        image = [UIImage imageWithCGImage:asset.thumbnail];
        //        image = [UIImage imageWithCGImage:asset.thumbnail scale:0.1 orientation:orientation];
        NSLog(@"%@",[NSString stringWithFormat:@"fileSize:%lld k\nwidth:%.0f\nheiht:%.0f",asset.defaultRepresentation.size/1000,[[asset defaultRepresentation] dimensions].width, [[asset defaultRepresentation] dimensions].height]);
        
    } else {
        image = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
        NSLog(@"%@",[NSString stringWithFormat:@"fileSize:%lld k\nwidth:%.0f\nheiht:%.0f",asset.defaultRepresentation.size/1000,image.size.width,image.size.height]);
    }
    return image;
}

- (void)dnImagePickerControllerDidCancel:(DNImagePickerController *)imagePicker
{
    [imagePicker dismissViewControllerAnimated:YES completion:^{
        if (self.completion) {
            self.completion(nil);
            self.completion = nil;
        }
    }];
}

#pragma mark 判断系统权限

- (BOOL)getSystemAuthorityWithType:(SystemAuthority)type {
    if (type == SystemAuthorityVideo) {
        AVAuthorizationStatus authorStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if(authorStatus == AVAuthorizationStatusRestricted || authorStatus == AVAuthorizationStatusDenied){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您暂未对相机进行授权，无法获取到您的相机。请到【设置】中打开" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"去设置", nil];
            alertView.tag = 1001;
            [alertView show];
            return NO;
        }
    } else if (type == SystemAuthorityLibrary) {
        ALAuthorizationStatus authorStatus = [ALAssetsLibrary authorizationStatus];
        if (authorStatus == ALAuthorizationStatusRestricted || authorStatus == ALAuthorizationStatusDenied){
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"您暂未对相册进行授权，无法获取到您的照片。请到【设置】中打开" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"去设置", nil];
            alertView.tag = 1002;
            [alertView show];
            return NO;
        }
    }
    return YES;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if([[UIDevice currentDevice].systemVersion floatValue] >= 8.0){
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }else{
            [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"prefs:General&path=Reset"]];
        }
    }
}

#pragma mark - ClipViewControllerDelegate
-(void)ClipViewController:(YSHYClipViewController *)clipViewController FinishClipImage:(UIImage *)editImage {
    if (self.completion && editImage) {
        self.completion(@[editImage]);
        self.completion = nil;
    }
    [clipViewController.navigationController popViewControllerAnimated:YES];
}

-(void)ClipViewController:(YSHYClipViewController *)clipViewController CancelClipImage:(UIImage *)editImage {
    if (self.completion) {
        self.completion(nil);
        self.completion = nil;
    }
    [clipViewController.navigationController popViewControllerAnimated:YES];
}

@end
