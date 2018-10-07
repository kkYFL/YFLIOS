//
//  Banner.h
//  YFL-IOS
//
//  Created by 韩兆华 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Banner : NSObject

//图片地址
@property(nonatomic, copy) NSString *imgUrl;
//位置编号
@property(nonatomic, copy) NSString *positionNo;
//简介
@property(nonatomic, copy) NSString *summary;
//链接类型 1:外链接 2：内链接
@property(nonatomic, copy) NSString *foreignType;
//链接地址
@property(nonatomic, copy) NSString *foreignUrl;

@property (nonatomic, copy) NSString *positionName;

@property (nonatomic, copy) NSString *positionType;

@property (nonatomic, copy) NSString *viewOrder;


-(id)initWithDic:(NSDictionary *)dic;

/*
 foreignType = 1;
 foreignUrl = "https://ugcsjy.qq.com/uwMRJfz-r5jAYaQXGdGnC2_ppdhgmrDlPaRvaV7F2Ic/n07129svhj2.mp4?sdtfrom=v1010&guid=b1e11f978a295d1e30b34433d1371d2d&vkey=39A1869ED8E97DF345C6C644DAA33E213292B578E13B68A8AD27A824420BF5D7FCDA67A895E4F68DAFA11809B8630D2A532D82EB8032BF5D82FEF5FC56CB1B2420278ABDAECB15EC1F0CB5FB07A024FD5FA15C843E505AEDF737558E77D054DC1DAE7000984494D4EF0884B4E4C22903CEBF6B3385F512BF";
 imgUrl = "/20180922163903_85ea1e50-dc30-4f82-ae21-324d0355a255.jpg";
 positionName = "\U6559\U80b2\U89c6\U9891";
 positionNo = "SPOS_3";
 positionType = "\U6559\U80b2\U83dc\U5355";
 summary = "";
 viewOrder = "";
 */

@end

NS_ASSUME_NONNULL_END
