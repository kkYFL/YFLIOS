//
//  PersonPasswordInCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/23.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "PersonPasswordInCell.h"

@interface PersonPasswordInCell ()

@property (nonatomic, strong) UIView *line;
@end

@implementation PersonPasswordInCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#BBBBBB"];
    self.line = line;
    [self.contentView addSubview:line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.5f);
    }];
    
    
    UITextField *cellTextfield = [[UITextField alloc]init];
    //设置边框样式，只有设置了才会显示边框样式
    cellTextfield.borderStyle = UITextBorderStyleNone;
    //设置输入框内容的字体样式和大小
    cellTextfield.font = [UIFont systemFontOfSize:17.0f];
    //设置字体颜色
    cellTextfield.textColor = [UIColor colorWithHexString:@"#9C9C9C"];
    //当输入框没有内容时，水印提示 提示内容为password
    cellTextfield.placeholder = NSLocalizedString(@"shurudangqianmima", nil);
    //内容对齐方式
    cellTextfield.textAlignment = NSTextAlignmentLeft;
    //设置键盘的样式
    cellTextfield.keyboardType = UIKeyboardTypeDefault;
    //return键变成什么键
    cellTextfield.returnKeyType =UIReturnKeyDone;
    self.textfield = cellTextfield;
    [self.contentView addSubview:self.textfield];
    [self.textfield mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.centerY.equalTo(self);
        make.height.mas_equalTo(30);
        make.right.equalTo(self.mas_right).offset(-15);
    }];
    
}

+(CGFloat)CellH{
    return 50.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
