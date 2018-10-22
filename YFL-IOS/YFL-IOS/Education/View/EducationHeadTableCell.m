//
//  EducationHeadTableCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/8/22.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "EducationHeadTableCell.h"
#import "Banner.h"
#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
//#import <ZFPlayer/ZFIJKPlayerManager.h>
//#import <ZFPlayer/KSMediaPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>
#import "AppDelegate.h"


@interface EducationHeadTableCell ()
//@property (nonatomic, strong) UIImageView *topImageView;
@property (nonatomic, strong) UILabel *cellContentLabel;
@property (nonatomic, strong) UIView *line;


@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;
@end

@implementation EducationHeadTableCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    [self.contentView addSubview:self.containerView];
    [self.containerView addSubview:self.backImageView];
    [self.containerView addSubview:self.playBtn];
    CGFloat topImageViewH = 0.6*SCREEN_WIDTH;
    self.containerView.frame = CGRectMake(0, 0, SCREEN_WIDTH,topImageViewH);
    self.backImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH,topImageViewH);

    
    ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
    //    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
    //    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
    /// 播放器相关
    self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
    self.player.controlView = self.controlView;
    /// 设置退到后台继续播放
    self.player.pauseWhenAppResignActive = NO;
    //@weakify(self)
//    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
//        @strongify(self)
//        [self setNeedsStatusBarAppearanceUpdate];
//    };
    /// 播放完自动播放下一个
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        //@strongify(self)
        //[self.player.currentPlayerManager replay];
        //        [self.player playTheNext];
        //        if (!self.player.isLastAssetURL) {
        //            NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
        //            [self.controlView showTitle:title coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
        //        } else {
        //            [self.player stop];
        //        }
    };

    

    [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.containerView);
        make.centerY.equalTo(self.containerView);
        make.width.height.mas_equalTo(40);
    }];


    
    UILabel *cellContentLabel = [[UILabel alloc] init];
    cellContentLabel.font = [UIFont systemFontOfSize:14.0f];
    cellContentLabel.numberOfLines = 0;
    cellContentLabel.text = @"";
    cellContentLabel.textColor = [UIColor colorWithHexString:@"#2A333A"];
    cellContentLabel.textAlignment = NSTextAlignmentLeft;
    [self.contentView addSubview:cellContentLabel];
    self.cellContentLabel = cellContentLabel;
    
    [cellContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(12);
        make.top.equalTo(self.containerView.mas_bottom).offset(8);
        make.right.equalTo(self).offset(-12);
    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#F2F2F2"];
    self.line = line;
    [self.contentView addSubview:line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(12);
        make.bottom.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1.0);
    }];

}


+(CGFloat)CellHWithModel:(Banner *)videoModel{
    if (videoModel) {
        NSString *contentStr = videoModel.summary;
        CGFloat contentViewH = [contentStr heightWithFont:[UIFont systemFontOfSize:14.0f] constrainedToWidth:SCREEN_WIDTH-24]+0.5;
        CGFloat topImageViewH = 0.6*SCREEN_WIDTH;
        
        return topImageViewH+contentViewH+8*2;
    }
    
    CGFloat topImageViewH = 0.6*SCREEN_WIDTH;
    return topImageViewH;
}

-(void)setVideoModel:(Banner *)videoModel{
    _videoModel = videoModel;
    if (_videoModel) {
        [self.cellContentLabel setText:_videoModel.summary];
        
        if (![NSString isBlankString:_videoModel.foreignUrl]) {
            
            if ([_videoModel.foreignUrl hasPrefix:@"http"]) {
                self.assetURLs = [NSArray arrayWithObjects:[NSURL URLWithString:_videoModel.foreignUrl], nil];
                self.player.assetURLs = self.assetURLs;
            }else{
                self.assetURLs = [NSArray arrayWithObjects:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,_videoModel.foreignUrl]], nil];
                self.player.assetURLs = self.assetURLs;
            }
            
            
        }else{
            self.assetURLs = [NSArray arrayWithObject:[NSURL URLWithString:@"https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4"]];
            self.player.assetURLs = self.assetURLs;
        }
        
        
        if ([_videoModel.imgUrl hasPrefix:@"http"]) {
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:_videoModel.imgUrl]];
        }else{
            [self.backImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,_videoModel.imgUrl]]];
        }
    }
}


- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

- (void)playClick:(UIButton *)sender {
    if (!self.assetURLs.count) {
        return;
    }
    [self.player playTheIndex:0];
    NSString *coverImageStr = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,self.videoModel.imgUrl];
    [self.controlView showTitle:@"" coverURLString:coverImageStr fullScreenMode:ZFFullScreenModeLandscape];
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}


- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        //_controlView.fastViewAnimated = YES;
    }
    return _controlView;
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        UIImageView *backImageView = [[UIImageView alloc]init];
        [backImageView setBackgroundColor:[UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:0.5]];
        _backImageView = backImageView;
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
