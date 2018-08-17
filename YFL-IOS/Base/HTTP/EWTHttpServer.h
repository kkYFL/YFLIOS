//
//  EWTHttpServer.h
//  EWTBase_Example
//
//  Created by Tony on 2018/3/23.
//  Copyright © 2018年 Huangbaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpConfig.h"

@protocol HttpServerDelegate <NSObject>

+(NSString*)serverHost;

+(BOOL)sslEnabled;

@end

@interface EWTHttpServer : NSObject<HttpServerDelegate>

@end
