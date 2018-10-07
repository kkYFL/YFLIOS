//
//  SignMoel.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/7.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "SignMoel.h"

@implementation SignMoel
-(id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        if ([dic objectForKey:@"signInList"] && [[dic objectForKey:@"signInList"] isKindOfClass:[NSArray class]]) {
            NSArray *List = [dic objectForKey:@"signInList"];
            if (List.count) {
                NSDictionary *signInList = [List objectAtIndex:0];
                self.ID = [NSString stringWithFormat:@"%@",[signInList objectForKey:@"id"]];
                self.pmId = [NSString stringWithFormat:@"%@",[signInList objectForKey:@"pmId"]];
                self.year = [NSString stringWithFormat:@"%@",[signInList objectForKey:@"year"]];
                self.month = [NSString stringWithFormat:@"%@",[signInList objectForKey:@"month"]];
                
                self.signDatArr = [NSMutableArray array];
                NSArray *monthKeyArr = [NSArray arrayWithObjects:@"one",@"two",@"three",@"four",@"five",@"six",@"seven",@"eight",@"nine",@"ten",@"eleven",@"twelve",@"thirteen",@"fourteen",@"fifteen",@"sixteen",@"seveteen",@"eighteen",@"nineteen",@"twenty",@"twentyOne",@"twentyTwo",@"twentyThree",@"twentyFour",@"twentyFive",@"twentySix",@"twentySeven",@"twentyEight",@"twentyNine",@"thirty",@"thirtyOne", nil];
                NSArray *keyArr = [signInList allKeys];
                for (NSInteger i = 0; i<keyArr.count; i++) {
                    NSString *keyStr = [NSString stringWithFormat:@"%@",keyArr[i]];
                    if ([monthKeyArr containsObject:keyStr]) {
                        if ([[NSString stringWithFormat:@"%@",[signInList objectForKey:keyStr]] integerValue] > 0) {
                            NSInteger month = [monthKeyArr indexOfObject:keyStr]+1;
                            [self.signDatArr addObject:@(month)];
                        }
                    }
                }
                
            }

            
        }
        
        if ([dic objectForKey:@"signInfo"]) {
            NSDictionary *signInfo = [dic objectForKey:@"signInfo"];
            self.continueSignIn = [NSString stringWithFormat:@"%@",[signInfo objectForKey:@"continueSignIn"]];
            self.todayTotalNum = [NSString stringWithFormat:@"%@",[signInfo objectForKey:@"todayTotalNum"]];
            self.totalSignIn = [NSString stringWithFormat:@"%@",[signInfo objectForKey:@"totalSignIn"]];
        }
    }
    return self;
}


@end
