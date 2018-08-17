//
//  NSData+EWT.h
//  Ewt360
//
//  Created by raojie on 2017/8/30.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - NSData (EWT)
@interface NSData (EWT)

@end

#pragma mark - NSData (Base64)
@interface NSData (Base64)

+ (NSData *)dataWithBase64EncodedString:(NSString *)string;
- (NSString *)base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;
- (NSString *)base64EncodedString;

@end
