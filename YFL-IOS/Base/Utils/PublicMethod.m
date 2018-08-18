//
//  PublicMethod.m
//  Ewt360
//
//  Created by ZengQingNian on 15/7/20.
//  Copyright (c) 2015年 铭师堂. All rights reserved.
//

#import "PublicMethod.h"
#import "SAMKeychain.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
//#import "NSData+Base64.h"
//#import "NSString+Base64.h"
#import "sys/utsname.h"
#import "YFKeychainUUID.h"
//获取IP
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>
#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"
#import "AFNetworkReachabilityManager.h"

@implementation PublicMethod

+ (NSString *)MD5Encrypt:(NSString*)string
{
    const char *str = [string UTF8String];
    unsigned char md[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), md);
    
    NSMutableString *returnStr = [NSMutableString string];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [returnStr appendFormat:@"%02x",md[i]];
    }
    
    return returnStr;
}

+ (BOOL)checkIsPhone:(NSString *)str
{
    NSString *regex = @"^1\\d{10}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:str];
}

+ (NSString *)AES128EncryptWithString:(NSString *)string key:(NSString *)key
{
    char keyPtr[kCCKeySizeAES128 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *strData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [strData length];
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesEncrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [strData bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        NSData *data = [NSMutableData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        return [data base64EncodedString];
    }
    free(buffer);
    
    return nil;
}



+ (NSString *)AES128DecryptWithString:(NSString *)string key:(NSString *)key
{
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    //    char keyPtr[kCCKeySizeAES256 + 1]; // room for terminator (unused)
    char keyPtr[kCCKeySizeAES128 + 1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSData *strData = [string base64DecodedData];
    NSUInteger dataLength = [strData length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize           = dataLength + kCCBlockSizeAES128;
    void* buffer                = malloc(bufferSize);
    
    size_t numBytesDecrypted    = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          keyPtr, kCCKeySizeAES128,
                                          NULL /* initialization vector (optional) */,
                                          [strData bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        NSData *data = [NSMutableData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
        return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    free(buffer);
    
    return nil;
}


+ (NSData *)AESEncryptWithData:(NSData *)data key:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t dataOutMovedSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [keyData bytes], kCCKeySizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &dataOutMovedSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:dataOutMovedSize];
    }
    
    free(buffer);
    return nil;
}

+ (NSData *)AESDecryptWithData:(NSData *)data key:(NSString *)key
{
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t dataOutMovedSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding|kCCOptionECBMode,
                                          [keyData bytes], kCCKeySizeAES128,
                                          NULL,
                                          [data bytes], dataLength,
                                          buffer, bufferSize,
                                          &dataOutMovedSize);
    
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:dataOutMovedSize];
    }
    
    free(buffer);
    return nil;
}


+ (NSString *)sixteenHexStringFromData:(NSData *)data
{
    Byte *bt = (Byte *)[data bytes];
    NSString *returnStr = @"";
    for (int i = 0; i < data.length; i ++) {
        NSString *str = [NSString stringWithFormat:@"%x", bt[i]&0xff]; //16进制
        if (str.length == 1) {
            returnStr = [NSString stringWithFormat:@"%@0%@",returnStr,str];
        } else {
            returnStr = [NSString stringWithFormat:@"%@%@",returnStr,str];
        }
    }
    
    return returnStr;
}


+(NSString *)serializeWithDictionary:(NSDictionary *)dict{

    if (dict) {
        
        NSMutableString* sortedString = [[NSMutableString alloc]init];
        
         NSArray* sortedKeys = [dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
            
           return [obj1 compare:obj2];
           
        }];
        
        NSLog(@"sorted = %@",sortedKeys);
        
        for (NSString* key in sortedKeys) {
            // %@&k=%@&token=%@&%@
            [sortedString appendString:[NSString stringWithFormat:@"&%@=%@",key,dict[key]]];
        }
        return sortedString;
    }

    return nil;
}

+(NSString *)serializeNoCharacterWithDictionary:(NSDictionary *)dict{
    
    if (dict) {
        
        NSMutableString* sortedString = [[NSMutableString alloc]init];
        
        NSArray* sortedKeys = [dict.allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString*  _Nonnull obj1, NSString*  _Nonnull obj2) {
            
            return [obj1 compare:obj2];
            
        }];
        
        NSLog(@"sorted = %@",sortedKeys);
        
        for (NSString* key in sortedKeys) {
            // %@&k=%@&token=%@&%@
            [sortedString appendString:[NSString stringWithFormat:@"%@",dict[key]]];
        }
        return sortedString;
    }
    
    return nil;
}

#pragma mark - /***** ***** ***** ***** ***** 系统级 ***** ***** ***** ***** *****/
+ (NSString *)documentDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    return documentsDirectory;
}


+ (NSString *)getCurrentDeviceModel
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    // iPhone
    if ([platform isEqualToString:@"iPhone1,1"]) return @"iPhone 2G (A1203)";
    if ([platform isEqualToString:@"iPhone1,2"]) return @"iPhone 3G (A1241/A1324)";
    if ([platform isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS (A1303/A1325)";
    if ([platform isEqualToString:@"iPhone3,1"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,2"]) return @"iPhone 4 (A1332)";
    if ([platform isEqualToString:@"iPhone3,3"]) return @"iPhone 4 (A1349)";
    if ([platform isEqualToString:@"iPhone4,1"]) return @"iPhone 4S (A1387/A1431)";
    if ([platform isEqualToString:@"iPhone5,1"]) return @"iPhone 5 (A1428)";
    if ([platform isEqualToString:@"iPhone5,2"]) return @"iPhone 5 (A1429/A1442)";
    if ([platform isEqualToString:@"iPhone5,3"]) return @"iPhone 5c (A1456/A1532)";
    if ([platform isEqualToString:@"iPhone5,4"]) return @"iPhone 5c (A1507/A1516/A1526/A1529)";
    if ([platform isEqualToString:@"iPhone6,1"]) return @"iPhone 5s (A1453/A1533)";
    if ([platform isEqualToString:@"iPhone6,2"]) return @"iPhone 5s (A1457/A1518/A1528/A1530)";
    if ([platform isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus (A1522/A1524)";
    if ([platform isEqualToString:@"iPhone7,2"]) return @"iPhone 6 (A1549/A1586)";
    if ([platform isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    if ([platform isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    if ([platform isEqualToString:@"iPhone9,1"]) return @"iPhone 7 (CDMA)";
    if ([platform isEqualToString:@"iPhone9,3"]) return @"iPhone 7 (GSM)";
    if ([platform isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus (CDMA)";
    if ([platform isEqualToString:@"iPhone9,4"]) return @"iPhone 7 Plus (GSM)";
    
    
    // iPod
    if ([platform isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G (A1213)";
    if ([platform isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G (A1288)";
    if ([platform isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G (A1318)";
    if ([platform isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G (A1367)";
    if ([platform isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G (A1421/A1509)";
    
    
    // iPad
    if ([platform isEqualToString:@"iPad1,1"])   return @"iPad 1G (A1219/A1337)";
    if ([platform isEqualToString:@"iPad2,1"])   return @"iPad 2 (A1395)";
    if ([platform isEqualToString:@"iPad2,2"])   return @"iPad 2 (A1396)";
    if ([platform isEqualToString:@"iPad2,3"])   return @"iPad 2 (A1397)";
    if ([platform isEqualToString:@"iPad2,4"])   return @"iPad 2 (A1395+New Chip)";
    if ([platform isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G (A1432)";
    if ([platform isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G (A1454)";
    if ([platform isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G (A1455)";
    
    if ([platform isEqualToString:@"iPad3,1"])   return @"iPad 3 (A1416)";
    if ([platform isEqualToString:@"iPad3,2"])   return @"iPad 3 (A1403)";
    if ([platform isEqualToString:@"iPad3,3"])   return @"iPad 3 (A1430)";
    if ([platform isEqualToString:@"iPad3,4"])   return @"iPad 4 (A1458)";
    if ([platform isEqualToString:@"iPad3,5"])   return @"iPad 4 (A1459)";
    if ([platform isEqualToString:@"iPad3,6"])   return @"iPad 4 (A1460)";
    
    if ([platform isEqualToString:@"iPad4,1"])   return @"iPad Air (A1474)";
    if ([platform isEqualToString:@"iPad4,2"])   return @"iPad Air (A1475)";
    if ([platform isEqualToString:@"iPad4,3"])   return @"iPad Air (A1476)";
    if ([platform isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G (A1489)";
    if ([platform isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G (A1490)";
    if ([platform isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G (A1491)";
    
    
    // Simulator
    if ([platform isEqualToString:@"i386"])      return @"iPhone Simulator";
    if ([platform isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return platform;
}

//获取设备当前网络IP地址
+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ /*IOS_VPN @"/" IP_ADDR_IPv4, IOS_VPN @"/" IP_ADDR_IPv6,*/ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ /*IOS_VPN @"/" IP_ADDR_IPv6, IOS_VPN @"/" IP_ADDR_IPv4,*/ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    NSDictionary *addresses = [self getIPAddresses];
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    
    return address ? address : @"0.0.0.0";
}

//获取所有相关IP信息
+ (NSDictionary *)getIPAddresses
{
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}


//获取设备型号
+(NSString *)getDeveiceVersion{
    
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceModel = [NSString stringWithCString:systemInfo.machine
                                               encoding:NSUTF8StringEncoding];
    
    // 模拟器
    if ([deviceModel isEqualToString:@"i386"])         return @"Simulator";
    if ([deviceModel isEqualToString:@"x86_64"])       return @"Simulator";
    
    // iPhone 系列
    if ([deviceModel isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([deviceModel isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([deviceModel isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([deviceModel isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone3,2"])    return @"Verizon iPhone 4";
    if ([deviceModel isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA/Verizon/Sprint)";
    if ([deviceModel isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([deviceModel isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([deviceModel isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([deviceModel isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    if ([deviceModel isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([deviceModel isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    if ([deviceModel isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    if ([deviceModel isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    if ([deviceModel isEqualToString:@"iPhone8,4"])    return @"iPhone SE";
    if ([deviceModel isEqualToString:@"iPhone9,1"])    return @"iPhone 7 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,3"])    return @"iPhone 7 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone9,2"])    return @"iPhone 7 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone9,4"])    return @"iPhone 7 Plus (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,1"])    return @"iPhone 8 (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone10,4"])    return @"iPhone 8 (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,2"])    return @"iPhone 8 Plus (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone10,5"])    return @"iPhone 8 Plus (GSM)";
    if ([deviceModel isEqualToString:@"iPhone10,3"])    return @"iPhone X (CDMA)";
    if ([deviceModel isEqualToString:@"iPhone10,6"])    return @"iPhone X (GSM)";
    
    // iPod 系列
    if ([deviceModel isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([deviceModel isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([deviceModel isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([deviceModel isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([deviceModel isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([deviceModel isEqualToString:@"iPod7,1"])      return @"iPod Touch 6G";
    
    // iPad 系列
    if ([deviceModel isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([deviceModel isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    
    if ([deviceModel isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([deviceModel isEqualToString:@"iPad2,4"])      return @"iPad 2 (32nm)";
    if ([deviceModel isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([deviceModel isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([deviceModel isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad3,1"])      return @"iPad 3(WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,2"])      return @"iPad 3(CDMA)";
    if ([deviceModel isEqualToString:@"iPad3,3"])      return @"iPad 3(4G)";
    if ([deviceModel isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([deviceModel isEqualToString:@"iPad3,5"])      return @"iPad 4 (4G)";
    if ([deviceModel isEqualToString:@"iPad3,6"])      return @"iPad 4 (CDMA)";
    
    if ([deviceModel isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([deviceModel isEqualToString:@"iPad4,4"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,5"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,6"])      return @"iPad Mini 2";
    if ([deviceModel isEqualToString:@"iPad4,7"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,8"])      return @"iPad Mini 3";
    if ([deviceModel isEqualToString:@"iPad4,9"])      return @"iPad Mini 3";
    
    if ([deviceModel isEqualToString:@"iPad5,1"])      return @"iPad Mini 4";
    if ([deviceModel isEqualToString:@"iPad5,2"])      return @"iPad Mini 4";
    if ([deviceModel isEqualToString:@"iPad5,3"])      return @"iPad Air 2";
    if ([deviceModel isEqualToString:@"iPad5,4"])      return @"iPad Air 2";
    
    if ([deviceModel isEqualToString:@"iPad6,3"])      return @"iPad PRO (12.9)";
    if ([deviceModel isEqualToString:@"iPad6,4"])      return @"iPad PRO (12.9)";
    if ([deviceModel isEqualToString:@"iPad6,7"])      return @"iPad PRO (9.7)";
    if ([deviceModel isEqualToString:@"iPad6,8"])      return @"iPad PRO (9.7)";
    if ([deviceModel isEqualToString:@"iPad6,11"])      return @"iPad 5";
    if ([deviceModel isEqualToString:@"iPad6,12"])      return @"iPad 5";
    
    if ([deviceModel isEqualToString:@"iPad7,1"])      return @"iPad PRO 2 (12.9)";
    if ([deviceModel isEqualToString:@"iPad7,2"])      return @"iPad PRO 2 (12.9)";
    if ([deviceModel isEqualToString:@"iPad7,3"])      return @"iPad PRO (10.5)";
    if ([deviceModel isEqualToString:@"iPad7,4"])      return @"iPad PRO (10.5)";
    
    return deviceModel;

}


+(void)getNetStatusHasNet:(void (^)(BOOL hasNet))hasNet{
    //1.创建网络状态监测管理者
    __weak AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    //开启监听，记得开启，不然不走block
    [manger startMonitoring];
    //2.监听改变
    
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        /*
         AFNetworkReachabilityStatusUnknown = -1,
         AFNetworkReachabilityStatusNotReachable = 0,
         AFNetworkReachabilityStatusReachableViaWWAN = 1,
         AFNetworkReachabilityStatusReachableViaWiFi = 2,
         */
     
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                hasNet(YES);
                [manger stopMonitoring];
                break;
            case AFNetworkReachabilityStatusNotReachable:
                hasNet(NO);
                [manger stopMonitoring];
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                hasNet(YES);
                [manger stopMonitoring];
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                hasNet(YES);
                [manger stopMonitoring];
                break;
            default:
                break;
        }
    }];
}

#pragma mark - /***** ***** ***** ***** ***** 公共接口 ***** ***** ***** ***** *****/
+ (NSString *)currentDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy/MM/dd HH:mm"];
    NSString *time = [formatter stringFromDate:[NSDate date]];
    return time;
}

+ (NSString *)serverDateformatWithSecond:(NSString *)second
{
    return [PublicMethod serverDateformatWithSecond:second byFormat:@"yy/MM/dd HH:mm"];
}

+(NSString *)serverDateformatWithSecond:(NSString *)second byFormat:(NSString *)format{
    
    if (second.length >= 10) {
        NSString *sc = [second substringWithRange:NSMakeRange(0,10)];
        NSTimeInterval time = [sc doubleValue];
        NSDate *detaildate=[NSDate dateWithTimeIntervalSince1970:time];
        //实例化一个NSDateFormatter对象
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //设定时间格式,这里可以设置成自己需要的格式
        [dateFormatter setDateFormat:format];
        NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
        [dateFormatter setTimeZone:timeZone];
        NSString *returnStr = [dateFormatter stringFromDate: detaildate];
        return returnStr;
    } else {
        //如果服务器时间返回为空返回系统时间
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        NSString *time = [formatter stringFromDate:[NSDate date]];
        return time;
    }
}

+ (NSString *)currentDateWithFormat:(NSString *)format
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    NSString *dateStr = [formatter stringFromDate:[NSDate date]];
    
    return dateStr;
}

+ (NSString *)currentTimeInterval
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSince1970]*1000;
    NSString *intervalStr = [NSString stringWithFormat:@"%.0f", interval];
    return intervalStr;
}

+ (NSInteger)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
    return timeSp;
}


+(NSString *)readDeviceUUIDFromKeychain{
    NSString * deviceUUIDStr = [SAMKeychain passwordForService:@"ewt"account:@"uuid"];
    if (deviceUUIDStr == nil || [deviceUUIDStr isEqualToString:@""])
    {
        NSUUID * deviceUUID  = [UIDevice currentDevice].identifierForVendor;
        deviceUUIDStr = deviceUUID.UUIDString;
        [SAMKeychain setPassword: deviceUUIDStr forService:@"ewt"account:@"uuid"];
    }
    return deviceUUIDStr;
}


+ (NSString *)getSubjectTypeWithId:(NSString *)string
{
    NSString *subStr = @"";
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"SubjectType" ofType:@"plist"];
    NSArray *arr = [[NSArray alloc] initWithContentsOfFile:plistPath];
    for (NSDictionary *dic in arr) {
        if ([[dic valueForKey:@"id"] isEqualToString:string]) {
            subStr = [dic valueForKey:@"name"];
            break;
        }else{
            subStr = @"其他";

        }
    }
    return subStr;
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

+ (NSString *)getTheNetworkStateText{
    NSString *state = [[NSString alloc]init];
    switch ([PublicMethod getNetWorkStates]) {
        case NotReachable:
            state = @"无网络";
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            state = @"WIFI";
            break;
//        case kReachableVia4G:
//            state = @"4G";
//            break;
//        case kReachableVia3G:
//            state = @"3G";
//            break;
//        case kReachableVia2G:
//            state = @"2G";
//            break;
        default:
            state = @"未知网络";
            break;
    }
    //根据状态选择
    return state;
}

+ (NetworkStatus)getNetWorkStates {

    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus status = [reachability currentReachabilityStatus];
    return status;
}

//获取时间
+ (NSString *)returnTime {
    
    NSDate *senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"dd"];
    NSString *morelocationString = [dateformatter stringFromDate:senddate];
    return morelocationString;
}

// 获取文件夹的大小
+ (CGFloat )folderSizeAtPath:(NSString *)folderPath {
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString *fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        float singleFileSize = 0.0;
        if ([manager fileExistsAtPath:fileAbsolutePath]) {
            singleFileSize = [[manager attributesOfItemAtPath:fileAbsolutePath error:nil] fileSize];
        }
        folderSize += singleFileSize;
    }
    return folderSize/1024.;
}

+ (NSString *)freeDiskSpace{
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] ;
    NSFileManager *fileManager = [[NSFileManager alloc ]init];
    NSDictionary *fileSysAttributes = [fileManager attributesOfFileSystemForPath:path error:nil];
    NSNumber *freeSpace = [fileSysAttributes objectForKey:NSFileSystemFreeSize];
    NSString *str= [NSString stringWithFormat:@"%0.2f",[freeSpace longLongValue]/1024.0/1024.0/1024.0];
    return str;
}

+ (CGFloat)getTheWidthOfTheLabelWithContent:(NSString *)content font:(CGFloat)font {
    UIFont *fnt = [UIFont fontWithName:@"HelveticaNeue" size:font];
    CGSize size = [content sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
    return size.width;
}

+ (NSMutableAttributedString *)accordingToStringGetDicColorNSString:(NSString *)contentStr color:(UIColor *)color startingPoint:(NSInteger)point width:(NSInteger)width {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
    //设置：在0-3个单位长度内的内容显示成红色
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(point, width)];
    return str;
}

// 注意: 请无修改 ~。
+ (void)videoDecryptWithURL:(NSURL *)location
                   fileName:(NSString *)fileName
              fileExtension:(NSString *)fileExtension
                     result:(void (^)(BOOL isMemorySpace, NSURL *urlPath))result
{
    
    BOOL isMemorySpace = YES;
    NSString *decryptKey = @"FVF8CL^cvkt4w23$";
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths firstObject];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *videoDirectoryPath = [documentsDirectory stringByAppendingPathComponent:@"videos"];

    if (![fm fileExistsAtPath:videoDirectoryPath]) [fm createDirectoryAtPath:videoDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    NSString *videoPath = [videoDirectoryPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",fileName,fileExtension]];
    if ([fm fileExistsAtPath:videoPath]) [fm removeItemAtPath:videoPath error:nil];
    [fm createFileAtPath:videoPath contents:nil attributes:nil];
    
    NSFileHandle *fileHandle = [NSFileHandle fileHandleForWritingAtPath:videoPath];
    [fileHandle truncateFileAtOffset:0];
    
    CGFloat freeDiskSpace = [[PublicMethod freeDiskSpace] floatValue] * 1024 * 1024 * 1024;

    //NSData *data = [NSData dataWithContentsOfURL:location];
    NSData *data = [NSData dataWithContentsOfURL:location options:NSDataReadingMappedIfSafe error:nil];
    
    // 增加 内存空间是否足够 zwz
    if (data.length > freeDiskSpace) {
        isMemorySpace = NO;
    }
    
    //[fm removeItemAtURL:location error:nil]; // 删除临时文件（不执行tmp也会清除，时间不确定。）

    if (isMemorySpace) {
        NSMutableData *decryptData;
        if (data.length >= 1000000) {
            NSMutableData *encryptData = [NSMutableData dataWithData:[data subdataWithRange:NSMakeRange(0, 1000000)]];
            
            NSData *lastData = [data subdataWithRange:NSMakeRange(data.length-1, 1)];
            NSString *sixteenHexStr = [PublicMethod sixteenHexStringFromData:lastData];
            int tenHexInt = [[NSString stringWithFormat:@"%lu",strtoul([sixteenHexStr UTF8String],0,16)] intValue];
            
            NSData *extraData = [data subdataWithRange:NSMakeRange((data.length-1-tenHexInt), tenHexInt)];
            [encryptData appendData:extraData];
            
            
            decryptData = [NSMutableData dataWithData:[PublicMethod AESDecryptWithData:encryptData key:decryptKey]];
            [fileHandle writeData:decryptData];
            
            NSData *unencryptedData = [data subdataWithRange:NSMakeRange(1000000, (data.length-1-tenHexInt-1000000))];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:unencryptedData];
        } else {
            decryptData = [NSMutableData dataWithData:[PublicMethod AESDecryptWithData:data key:decryptKey]];
            [fileHandle writeData:decryptData];
        }
    }
    
    [fileHandle closeFile];
    NSURL *videoURLPath = [[NSURL alloc] initFileURLWithPath:videoPath];
    if (result) result(isMemorySpace, videoURLPath);
}


+ (NSString *)emoticonAnalyzeWithServerCode:(NSString *)code
{
    NSString *returnStr = code;
    [returnStr stringByReplacingOccurrencesOfString:@"{:7_221:}" withString:@"biggrin.PNG"];
    [returnStr stringByReplacingOccurrencesOfString:@"" withString:@""];
    return returnStr;
}

+ (NSMutableArray *)faceKey {
    NSMutableArray *key = [NSMutableArray arrayWithCapacity:0];
    
    //一下四个for循环式四套表情,均用于发帖和回帖
    
    for (int i = 330; i <= 345; i++) {
        NSString *xtz = [NSString stringWithFormat:@"{:9_%d:}", i];
        [key addObject:xtz];
    }
    
    for (int i = 221; i <= 258; i++) {
        NSString *xtz = [NSString stringWithFormat:@"{:7_%d:}", i];
        [key addObject:xtz];
    }
    
    for (int i = 259; i <= 323; i++) {
        NSString *xtz = [NSString stringWithFormat:@"{:8_%d:}", i];
        [key addObject:xtz];
    }
    
    for (int i = 115; i <= 144; i++) {
        NSString *xtz = [NSString stringWithFormat:@"{:5_%d:}", i];
        [key addObject:xtz];
    }
    
    for (int i = 145; i <= 220; i++) {
        NSString *xtz = [NSString stringWithFormat:@"{:6_%d:}", i];
        [key addObject:xtz];
    }
    
    
    //以下是第五套表情,用于回复楼中楼
    [key addObject:@":)"];  [key addObject:@":("];   [key addObject:@":D"];[key addObject:@":@"];
    [key addObject:@":o"];[key addObject:@":P"];[key addObject:@":$"];    [key addObject:@";P"];
    [key addObject:@":L"];  [key addObject:@":Q"];   [key addObject:@":lol"];    [key addObject:@":loveliness:"];
    [key addObject:@":funk:"];   [key addObject:@":curse:"]; [key addObject:@":dizzy:"];  [key addObject:@":shutup:"];
    [key addObject:@":sleepy:"]; [key addObject:@":hug:"];   [key addObject:@":victory:"];[key addObject:@":time:"];
    [key addObject:@":kiss:"];   [key addObject:@":handshake"];[key addObject:@":call:"];
    
    [key addObject:@"{:2_25:}"];[key addObject:@"{:2_26:}"];[key addObject:@"{:2_27:}"];
    [key addObject:@"{:2_28:}"];[key addObject:@"{:2_29:}"];[key addObject:@"{:2_30:}"];
    [key addObject:@"{:2_31:}"];[key addObject:@"{:2_32:}"];[key addObject:@"{:2_33:}"];
    [key addObject:@"{:2_34:}"];[key addObject:@"{:2_35:}"];[key addObject:@"{:2_36:}"];
    [key addObject:@"{:2_37:}"];[key addObject:@"{:2_38:}"];[key addObject:@"{:2_39:}"];
    [key addObject:@"{:2_40:}"];
    
    [key addObject:@"{:3_41:}"];[key addObject:@"{:3_42:}"];[key addObject:@"{:3_43:}"];
    [key addObject:@"{:3_44:}"];[key addObject:@"{:3_45:}"];[key addObject:@"{:3_46:}"];
    [key addObject:@"{:3_47:}"];[key addObject:@"{:3_48:}"];[key addObject:@"{:3_49:}"];
    [key addObject:@"{:3_50:}"];[key addObject:@"{:3_51:}"];[key addObject:@"{:3_52:}"];
    [key addObject:@"{:3_53:}"];[key addObject:@"{:3_54:}"];[key addObject:@"{:3_55:}"];
    [key addObject:@"{:3_56:}"];[key addObject:@"{:3_57:}"];[key addObject:@"{:3_58:}"];
    [key addObject:@"{:3_59:}"];[key addObject:@"{:3_60:}"];[key addObject:@"{:3_61:}"];
    [key addObject:@"{:3_62:}"];[key addObject:@"{:3_63:}"];[key addObject:@"{:3_64:}"];
    return key;
}

+ (NSMutableArray *)faceValue {

    NSMutableArray *value = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 330; i <= 345; i++) {
        NSString *xtz = [NSString stringWithFormat:@"new_9_%d", i];
        [value addObject:xtz];
    }

    for (int i = 221; i <= 258; i++) {
        NSString *xtz = [NSString stringWithFormat:@"xtz_7_%d", i];
        [value addObject:xtz];
    }
    
    for (int i = 259; i <= 323; i++) {
        NSString *xtz = [NSString stringWithFormat:@"yc_8_%d", i];
        [value addObject:xtz];
    }
    
    for (int i = 115; i <= 144; i++) {
        NSString *xtz = [NSString stringWithFormat:@"qq_5_%d", i];
        [value addObject:xtz];
    }
    
    for (int i = 145; i <= 220; i++) {
        NSString *xtz = [NSString stringWithFormat:@"wjx_6_%d", i];
        [value addObject:xtz];
    }
    
    
    
    [value addObject:@"smile"];[value addObject:@"sad"];[value addObject:@"biggrin"];[value addObject:@"huffy"];
    [value addObject:@"shocked"];[value addObject:@"tongue"];[value addObject:@"shy"];[value addObject:@"titter"];
    [value addObject:@"sweat"];[value addObject:@"mad"];[value addObject:@"lol"];[value addObject:@"loveliness"];
    [value addObject:@"funk"];[value addObject:@"curse"];[value addObject:@"dizzy"];[value addObject:@"shutup"];
    [value addObject:@"sleepy"];[value addObject:@"hug"];[value addObject:@"victory"];[value addObject:@"time"];
    [value addObject:@"kiss"];[value addObject:@"handshake"];[value addObject:@"call"];
    
    [value addObject:@"wjx_6_146"];[value addObject:@"wjx_6_157"];[value addObject:@"wjx_6_161"];
    [value addObject:@"wjx_6_174"];[value addObject:@"wjx_6_160"];[value addObject:@"wjx_6_172"];
    [value addObject:@"wjx_6_195"];[value addObject:@"wjx_6_179"];[value addObject:@"wjx_6_176"];
    [value addObject:@"wjx_6_188"];[value addObject:@"wjx_6_187"];[value addObject:@"wjx_6_215"];
    [value addObject:@"wjx_6_207"];[value addObject:@"wjx_6_208"];[value addObject:@"wjx_6_209"];
    [value addObject:@"wjx_6_213"];
    
    [value addObject:@"yc_8_259"];[value addObject:@"yc_8_260"];[value addObject:@"yc_8_261"];
    [value addObject:@"yc_8_262"];[value addObject:@"yc_8_263"];[value addObject:@"yc_8_264"];
    [value addObject:@"yc_8_265"];[value addObject:@"yc_8_267"];[value addObject:@"yc_8_269"];
    [value addObject:@"yc_8_270"];[value addObject:@"yc_8_272"];[value addObject:@"yc_8_273"];
    [value addObject:@"yc_8_276"];[value addObject:@"yc_8_278"];[value addObject:@"yc_8_284"];
    [value addObject:@"yc_8_279"];[value addObject:@"yc_8_289"];[value addObject:@"yc_8_299"];
    [value addObject:@"yc_8_296"];[value addObject:@"yc_8_307"];[value addObject:@"yc_8_319"];
    [value addObject:@"yc_8_317"];[value addObject:@"yc_8_281"];[value addObject:@"yc_8_301"];
    
    return value;
}

+ (NSDictionary *)faceDic
{    
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:[self faceValue] forKeys:[self faceKey]];
    return dic;
}


+ (NSDictionary *)expressionServerToLocal
{
    NSDictionary *dic = [[NSDictionary alloc] initWithObjects:[self faceKey] forKeys:[self faceValue]];
    return dic;
}


+ (NSString *)stringEscapes:(NSString *)string
{
    if (string.length <= 0) return @"";
    
    NSString *returnString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)string, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    return returnString;
}

+ (NSString *)stringEscapesDecode:(NSString *)string
{
    NSString *returnString = [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return returnString;
}

+ (BOOL)findEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
                                const unichar hs = [substring characterAtIndex:0];
                                if (0xd800 <= hs && hs <= 0xdbff) {
                                    if (substring.length > 1) {
                                        const unichar ls = [substring characterAtIndex:1];
                                        const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                                        if (0x1d000 <= uc && uc <= 0x1f77f) {
                                            returnValue = YES;
                                        }
                                    }
                                } else if (substring.length > 1) {
                                    const unichar ls = [substring characterAtIndex:1];
                                    if (ls == 0x20e3) {
                                        returnValue = YES;
                                    }
                                } else {
                                    if (0x2100 <= hs && hs <= 0x27ff) {
                                        returnValue = YES;
                                    } else if (0x2B05 <= hs && hs <= 0x2b07) {
                                        returnValue = YES;
                                    } else if (0x2934 <= hs && hs <= 0x2935) {
                                        returnValue = YES;
                                    } else if (0x3297 <= hs && hs <= 0x3299) {
                                        returnValue = YES;
                                    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
                                        returnValue = YES;
                                    }
                                }
                            }];
    
    return returnValue;
}

//根据积分获取头衔
+ (NSString *)accordingToTheIntegralForTheTitle:(NSInteger)credits {
    NSString *string = [NSString string];
    if (credits<0) {
        string = @"娘胎生物";
    } else if (credits >= 0 && credits < 100) {
        string = @"幼儿园";
    } else if (credits >= 100 && credits < 200) {
        string = @"学前班";
    } else if (credits >= 200 && credits < 300) {
        string = @"小一年级";
    } else if (credits >= 300 && credits < 400) {
        string = @"小二年级";
    } else if (credits >= 400 && credits < 500) {
        string = @"小三年级";
    } else if (credits >= 500 && credits < 600) {
        string = @"小四年级";
    } else if (credits >= 600 && credits < 700) {
        string = @"小五年级";
    } else if (credits >= 700 && credits < 1000) {
        string = @"小升初";
    } else if (credits >= 1000 && credits < 1300) {
        string = @"初一";
    } else if (credits >= 1300 && credits < 1600) {
        string = @"初二";
    } else if (credits >= 1600 && credits < 2000) {
        string = @"中考牛人";
    }else if (credits >= 2000 && credits < 2400) {
        string = @"高一";
    }else if (credits >= 2400 && credits < 2800) {
        string = @"高二";
    } else if (credits >= 2800 && credits < 3300) {
        string = @"高考传说";
    } else if (credits >= 3300 && credits < 3800) {
        string = @"奇葩大专僧";
    } else if (credits >= 3800 && credits < 4300) {
        string = @"本科大学僧";
    } else if (credits >= 4300 && credits < 5000) {
        string = @"硕士研究僧";
    } else if (credits >= 5000 && credits < 6000) {
        string = @"博士扫地僧";
    } else if (credits >= 6000 && credits < 8300) {
        string = @"博士后";
    } else if (credits >= 8000 && credits < 15000) {
        string = @"博士生导师";
    } else if (credits >= 15000) {
        string = @"霸学天下";
    }
    return string;
}






+ (CGFloat)getSpaceLabelHeight:(NSString *)str withWidh:(CGFloat)width font:(NSInteger)font {
    
    NSMutableParagraphStyle *paragphStyle=[[NSMutableParagraphStyle alloc]init];
    
    paragphStyle.lineSpacing=0;//设置行距为0
    paragphStyle.firstLineHeadIndent=0.0;
    paragphStyle.hyphenationFactor=0.0;
    paragphStyle.paragraphSpacingBefore=0.0;
    
    NSDictionary *dic=@{ NSFontAttributeName:[UIFont systemFontOfSize:font], NSParagraphStyleAttributeName:paragphStyle, NSKernAttributeName:@1.0f};
    CGSize size=[str boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height;
}

+ (BOOL)isBlankString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    
    return NO;
} 

+ (BOOL)isPureInt:(NSString *)string ignoreZore:(BOOL)ignoreZore{
    
    if (ignoreZore) {
        if (string.length !=0) {
            NSString *st = [string substringWithRange:NSMakeRange(0,1)];
            if (![PublicMethod isNumText:st]) {
                return NO;
            } else {
                NSScanner *scan = [NSScanner scannerWithString:string];
                int val;
                return [scan scanInt:&val]&&[scan isAtEnd];
            }
        } else {
            return nil;
        }
    }else{
        return [self isPureInt:string];
    }
    
}
+ (BOOL)isPureInt:(NSString *)string{
    if (string.length !=0) {
        NSString *st = [string substringWithRange:NSMakeRange(0,1)];
        if (![PublicMethod isNumText:st]) {
            return NO;
        } else if ([string integerValue] == 0) {
            return NO;
        } else {
            NSScanner *scan = [NSScanner scannerWithString:string];
            int val;
            return [scan scanInt:&val]&&[scan isAtEnd];
        }
    } else {
        return nil;
    }
}

//通过时间戳判断是否大于1天
+ (BOOL)intervalSinceNow:(NSString *)stringTimeT lastTime:(NSString *)lastTime
{
    
    if ([lastTime isEqualToString:@"1753-01-01"]) {
        return YES;
    } else {
        NSRange range = NSMakeRange(0,(stringTimeT.length-3));
        NSString* prefix = [stringTimeT substringWithRange:range];
        
        NSInteger t = [prefix integerValue];
        NSInteger i = [PublicMethod timeSwitchTimestamp:lastTime andFormatter:@"YYYY-MM-dd"];//[self accurateInTime:lastTime];//1451145600;//
        int y = (int)(t-i)/24/60/60;
        if (y>=1) {
            return YES;
        } else {
            return NO;
        }
    }
}

+ (BOOL)isNumText:(NSString *)str{
    NSString * regex        = @"^[0-9]*$";
    NSPredicate * pred      = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch            = [pred evaluateWithObject:str];
    if (isMatch) {
        return YES;
    }else{
        return NO;
    }
}


+ (NSMutableAttributedString *)textFieldAttributedPlaceholderWithText:(NSString *)holderText hexColor:(NSString *)hexColor font:(CGFloat)font
{
    NSMutableAttributedString *holderAttributedStr = [[NSMutableAttributedString alloc] initWithString:holderText];
    [holderAttributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:hexColor] range:NSMakeRange(0, holderText.length)];
    [holderAttributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:font] range:NSMakeRange(0, holderText.length)];
    return holderAttributedStr;
}


@end
