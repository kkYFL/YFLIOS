//
//  Target_EWTImagePicker.h
//  Pods
//
//  Created by 李天露 on 2018/5/14.
//

#import <Foundation/Foundation.h>

@interface Target_EWTImagePicker : NSObject

-(id)Action_GetImageFromCamera:(NSDictionary *)params;

-(id)Action_GetImageFromLibrary:(NSDictionary *)params;

- (NSData *)Action_CompressImage:(NSDictionary *)params;

@end
