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

static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

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
    CGFloat topImageViewH = 0.5*SCREEN_WIDTH;
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
//    self.assetURLs = @[[NSURL URLWithString:@"https://www.apple.com/105/media/us/iphone-x/2017/01df5b43-28e4-4848-bf20-490c34a926a7/films/feature/iphone-x-feature-tpl-cc-us-20170912_1280x720h.mp4"],
//                       [NSURL URLWithString:@"https://www.apple.com/105/media/cn/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/bruce/mac-bruce-tpl-cn-2018_1280x720h.mp4"],
//                       [NSURL URLWithString:@"https://www.apple.com/105/media/us/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/peter/mac-peter-tpl-cc-us-2018_1280x720h.mp4"],
//                       [NSURL URLWithString:@"https://www.apple.com/105/media/us/mac/family/2018/46c4b917_abfd_45a3_9b51_4e3054191797/films/grimes/mac-grimes-tpl-cc-us-2018_1280x720h.mp4"],
//                       [NSURL URLWithString:@"http://flv3.bn.netease.com/tvmrepo/2018/6/H/9/EDJTRBEH9/SD/EDJTRBEH9-mobile.mp4"],
//                       [NSURL URLWithString:@"http://flv3.bn.netease.com/tvmrepo/2018/6/9/R/EDJTRAD9R/SD/EDJTRAD9R-mobile.mp4"],
//                       [NSURL URLWithString:@"http://dlhls.cdn.zhanqi.tv/zqlive/34338_PVMT5.m3u8"],
//                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-video/7_517c8948b166655ad5cfb563cc7fbd8e.mp4"],
//                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/68_20df3a646ab5357464cd819ea987763a.mp4"],
//                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/118_570ed13707b2ccee1057099185b115bf.mp4"],
//                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/15_ad895ac5fb21e5e7655556abee3775f8.mp4"],
//                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/12_cc75b3fb04b8a23546d62e3f56619e85.mp4"],
//                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-smallvideo/5_6d3243c354755b781f6cc80f60756ee5.mp4"],
//                       [NSURL URLWithString:@"http://tb-video.bdstatic.com/tieba-movideo/11233547_ac127ce9e993877dce0eebceaa04d6c2_593d93a619b0.mp4"]];
    
    //self.player.assetURLs = self.assetURLs;
    
    
    
    
    
    
//    UIImageView *topImageView = [[UIImageView alloc]init];
//    [topImageView setBackgroundColor:[UIColor whiteColor]];
//    [self.contentView addSubview:topImageView];
//    self.topImageView = topImageView;
//    [topImageView setContentMode:UIViewContentModeScaleToFill];
//    [topImageView setImage:[UIImage imageNamed:@"login-bg"]];
//    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureAction:)];
//    topImageView.userInteractionEnabled = YES;
//    [topImageView addGestureRecognizer:tap1];
//
//    [topImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.top.right.equalTo(self).offset(0);
//        make.height.mas_equalTo(topImageViewH);
//    }];
    
    
    
//    UIImageView *iconImageView = [[UIImageView alloc]init];
//    [self.containerView addSubview:iconImageView];
//    [iconImageView setContentMode:UIViewContentModeScaleToFill];
//    [iconImageView setImage:[UIImage imageNamed:@"Education_play"]];
//    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.containerView);
//        make.centerY.equalTo(self.containerView);
//        make.width.height.mas_equalTo(40);
//    }];
    

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
        CGFloat topImageViewH = 0.5*SCREEN_WIDTH;
        
        return topImageViewH+contentViewH+8*2;
    }
    
    CGFloat topImageViewH = 0.5*SCREEN_WIDTH;
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
                self.assetURLs = [NSArray arrayWithObjects:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.host,_videoModel.foreignUrl]], nil];
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
    [self.controlView showTitle:@"" coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
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
