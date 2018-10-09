//
//  EducationXinshegnViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/7.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationXinshegnViewCell.h"
#import "PartyMemberThinking.h"
#import "AppDelegate.h"

@interface EducationXinshegnViewCell ()
@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UILabel *cellTitle;
@property (nonatomic, strong) UILabel *addressLabel;

@property (nonatomic, strong) UILabel *cellContent;
@property (nonatomic, strong) UIImageView *rowImageView;
@property (nonatomic, strong) UIView *line;

@end

@implementation EducationXinshegnViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    UIImageView *cellIcon = [[UIImageView alloc]init];
    cellIcon.backgroundColor =[UIColor grayColor];
    [self.contentView addSubview:cellIcon];
    self.cellIcon = cellIcon;
    [cellIcon setContentMode:UIViewContentModeCenter];
    [cellIcon setImage:[UIImage imageNamed:@""]];
    cellIcon.layer.masksToBounds = YES;
    cellIcon.layer.cornerRadius = 30.0f;
    [self.cellIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0f);
        make.centerY.equalTo(self);
        make.height.width.mas_equalTo(60.0f);
    }];
    
    
    
    UILabel *cellTitle = [[UILabel alloc] init];
    cellTitle.font = [UIFont systemFontOfSize:14.0f];
    cellTitle.text = @"张三丰";
    cellTitle.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellTitle.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellTitle];
    self.cellTitle = cellTitle;
    [self.cellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellIcon.mas_right).offset(15.0f);
        make.top.equalTo(self.cellIcon).offset(0);
        make.height.mas_equalTo(14.0f);
    }];
    
    
    
    //addressLabel
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.font = [UIFont systemFontOfSize:11.0f];
    addressLabel.text = @"河南县XXX委员会委员";
    addressLabel.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    addressLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellIcon.mas_right).offset(15.0f);
        make.top.equalTo(self.cellTitle.mas_bottom).offset(4.0f);
        make.height.mas_equalTo(12.0f);
    }];
    
    
    
    UILabel *cellContent = [[UILabel alloc] init];
    cellContent.font = [UIFont systemFontOfSize:14.0f];
    cellContent.text = @"别在努力的年龄选择安逸！";
    cellContent.textColor = [UIColor colorWithHexString:@"#0C0C0C"];
    cellContent.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellContent];
    self.cellContent = cellContent;
    [self.cellContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cellIcon.mas_right).offset(15.0f);
        make.right.equalTo(self.mas_right).offset(-15.0f);
        make.bottom.equalTo(self.cellIcon.mas_bottom).offset(0);
        make.height.mas_equalTo(14.0f);
    }];
    
    
//
//    UIImageView *rowImageView = [[UIImageView alloc]init];
//    [self.contentView addSubview:rowImageView];
//    self.rowImageView = rowImageView;
//    [rowImageView setContentMode:UIViewContentModeCenter];
//    [rowImageView setImage:[UIImage imageNamed:<#imageUrl#>]];
//    
//    
//    
//    
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
    
    
}

-(void)setThindModel:(PartyMemberThinking *)thindModel{
    _thindModel = thindModel;
    if (_thindModel) {
        //    for (PartyMemberThinking *model in listArray) {
        //        NSLog(@"%@", model.pmName);
        //        NSLog(@"%@", model.headImg);
        //        NSLog(@"%@", model.ssDepartment);
        //        NSLog(@"%@", model.commentInfo);
        //        NSLog(@"%@", model.createTime);
        //    }
        
        [self.cellIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.host,_thindModel.headImg]]];
        self.cellTitle.text = _thindModel.pmName;
        self.addressLabel.text = _thindModel.ssDepartment;
        self.cellContent.text = _thindModel.commentInfo;

    }
}


+(CGFloat)CellH{
    return 60+15+15;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
