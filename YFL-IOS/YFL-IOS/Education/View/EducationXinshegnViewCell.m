//
//  EducationXinshegnViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/10/7.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationXinshegnViewCell.h"

@interface EducationXinshegnViewCell ()
@property (nonatomic, strong) UIImageView *cellIcon;
@property (nonatomic, strong) UILabel *cellTitle;
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
    
//    UIImageView *cellIcon = [[UIImageView alloc]init];
//    [self.contentView addSubview:cellIcon];
//    self.cellIcon = cellIcon;
//    [cellIcon setContentMode:UIViewContentModeCenter];
//    [cellIcon setImage:[UIImage imageNamed:@""]];
//    
//    UILabel *cellTitle = [[UILabel alloc] init];
//    cellTitle.font = [UIFont systemFontOfSize:<#size#>];
//    cellTitle.text = @"";
//    cellTitle.textColor = [UIColor colorWithHexString:<#color#>];
//    cellTitle.textAlignment = NSTextAlignmentLeft;
//    [self.contentView addSubview:cellTitle];
//    self.cellTitle = cellTitle;
//    
//    
//    UILabel *cellContent = [[UILabel alloc] init];
//    cellContent.font = [UIFont systemFontOfSize:<#fontSize#>];
//    cellContent.text = @"";
//    cellContent.textColor = [UIColor colorWithHexString:<#color#>];
//    cellContent.textAlignment = NSTextAlignmentLeft;
//    [self.contentView addSubview:cellContent];
//    self.cellContent = cellContent;
//    
//    
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
//    UIView *line = [[UIView alloc]init];
//    line.backgroundColor = [UIColor colorWithHexString:<#color#>];
//    self.line = line;
//    [self.contentView addSubview:line];
//    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.contentView).offset(12);
//        make.bottom.equalTo(self.contentView);
//        make.right.equalTo(self.contentView);
//        make.height.mas_equalTo(1.0);
//    }];
//    
    
}

+(CGFloat)CellH{
    return 44.0f;
}





- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
