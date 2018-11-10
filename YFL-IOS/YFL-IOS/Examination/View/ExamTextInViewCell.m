//
//  ExamTextInViewCell.m
//  YFL-IOS
//
//  Created by 杨丰林 on 2018/9/15.
//  Copyright © 2018年 杨丰林. All rights reserved.
//

#import "ExamTextInViewCell.h"
#import "AppDelegate.h"
#import "HistoryExamDetail.h"

#import <ZFPlayer/ZFPlayer.h>
#import <ZFPlayer/ZFAVPlayerManager.h>
#import <ZFPlayer/ZFPlayerControlView.h>

#define ExamTextViewH 200*HEIGHT_SCALE

static NSString *kVideoCover = @"https://upload-images.jianshu.io/upload_images/635942-14593722fe3f0695.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240";

@interface ExamTextInViewCell ()
@property (nonatomic, strong) UIImageView *examBG;

@property (nonatomic, strong) UITableView *table;

@property (nonatomic, strong) ZFPlayerController *player;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) ZFPlayerControlView *controlView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *backBtn;
@property (nonatomic, strong) NSArray <NSURL *>*assetURLs;


@property (nonatomic, strong) NSString *corverImageUrl;
//@property (nonatomic, strong) UIWebView *webView;
//@property (nonatomic, strong) UILabel *videoTitleLabel;
//@property (nonatomic, strong) UILabel *timeLabel;


@end

@implementation ExamTextInViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
    }
    return self;
}

-(void)initView{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    //
    UIImageView *examBG = [[UIImageView alloc]init];
    [examBG setBackgroundColor:[UIColor whiteColor]];
    [self.contentView addSubview:examBG];
    self.examBG = examBG;
    [examBG setContentMode:UIViewContentModeScaleAspectFill];
    [examBG setImage:[UIImage imageNamed:@"exam_bg"]];
    examBG.userInteractionEnabled = YES;
    
    
    
    [examBG mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15.0);
        make.top.equalTo(self).offset(15.0);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-15);
    }];
    
    
    
//    if ([self.newsModel.imgUrl hasPrefix:@"http"]) {
//        self.corverImageUrl = self.newsModel.imgUrl;
//    }else{
//        self.corverImageUrl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,self.newsModel.imgUrl];
//    }
//    [self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.corverImageUrl]];
    
    


}


-(void)setExamModel:(HistoryExamDetail *)examModel{
    _examModel = examModel;
    
    if (_examModel) {
        [self.examBG addSubview:self.containerView];
        [self.containerView addSubview:self.backImageView];
        [self.containerView addSubview:self.playBtn];
        [self.examBG addSubview:self.backBtn];
        
        
        ZFAVPlayerManager *playerManager = [[ZFAVPlayerManager alloc] init];
        //    KSMediaPlayerManager *playerManager = [[KSMediaPlayerManager alloc] init];
        //    ZFIJKPlayerManager *playerManager = [[ZFIJKPlayerManager alloc] init];
        /// 播放器相关
        self.player = [ZFPlayerController playerWithPlayerManager:playerManager containerView:self.containerView];
        self.player.controlView = self.controlView;
        /// 设置退到后台继续播放
        self.player.pauseWhenAppResignActive = NO;
        @weakify(self)
        self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
            //@strongify(self)
            //[self setNeedsStatusBarAppearanceUpdate];
        };
        
        /// 播放完自动播放下一个
        self.player.playerDidToEnd = ^(id  _Nonnull asset) {
            @strongify(self)
            [self.player.currentPlayerManager replay];
            //        [self.player playTheNext];
            //        if (!self.player.isLastAssetURL) {
            //            NSString *title = [NSString stringWithFormat:@"视频标题%zd",self.player.currentPlayIndex];
            //            [self.controlView showTitle:title coverURLString:kVideoCover fullScreenMode:ZFFullScreenModeLandscape];
            //        } else {
            //            [self.player stop];
            //        }
        };
        
        
        
        
//        if ([_examModel.ex hasPrefix:@"http"]) {
//            self.corverImageUrl = self.newsModel.imgUrl;
//        }else{
//            self.corverImageUrl = [NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,self.newsModel.imgUrl];
//        }
        //[self.backImageView sd_setImageWithURL:[NSURL URLWithString:self.corverImageUrl]];
        
        /*
         //1 文字  2 视频  3 音频  4 图片
         @property(nonatomic, copy) NSString *titleType;
         */
        
        
        if ([_examModel.titleType integerValue] == 2 || [_examModel.titleType integerValue] == 3) {
            self.examBG.hidden = NO;
            self.containerView.hidden = NO;
            self.backBtn.hidden = NO;
            
            
            if ([_examModel.examUrl hasPrefix:@"http"]) {
                self.assetURLs = [NSArray arrayWithObject:[NSURL URLWithString:_examModel.examUrl]];
            }else{
                self.assetURLs = [NSArray arrayWithObject:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,_examModel.examUrl]]];
            }
            
            self.player.assetURLs = self.assetURLs;

        }else if([_examModel.titleType integerValue] == 4){
            self.examBG.hidden = NO;
            self.containerView.hidden = YES;
            self.backBtn.hidden = YES;
            
            if ([_examModel.examUrl hasPrefix:@"http"]) {
                [self.examBG sd_setImageWithURL:[NSURL URLWithString:_examModel.examUrl]];
            }else{
                [self.examBG sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APP_DELEGATE.sourceHost,_examModel.examUrl]]];
            }
        }else if ([_examModel.titleType integerValue] == 1){
            self.examBG.hidden = YES;
            self.containerView.hidden = YES;
            self.backBtn.hidden = YES;
        }

    }
}


+(CGFloat)CellHWithExamModel:(HistoryExamDetail *)examModel{
    if ([examModel.titleType integerValue] == 1){
        return 0.01f;
    }
    return ExamTextViewH;
}



-(void)layoutSubviews{
    [super layoutSubviews];
    
    CGFloat x1 = 0;
    CGFloat y1 = 0;
    CGFloat w1 = SCREEN_WIDTH-30;
    CGFloat h1 = ExamTextViewH;
    self.containerView.frame = CGRectMake(x1, y1, w1, h1);
    
    self.backImageView.frame = CGRectMake(x1, y1, w1, h1);
    
    CGFloat w2 = 44;
    CGFloat h2 = 44;
    CGFloat x2 = (CGRectGetWidth(self.containerView.frame)-w2)/2;
    CGFloat y2 = (CGRectGetHeight(self.containerView.frame)-h2)/2;
    self.playBtn.frame = CGRectMake(x2, y2, w2, h2);
    
    
    CGFloat X3 = 10.0f;
    CGFloat Y3 = 35.0f;
    CGFloat H3 = 25.0f;
    CGFloat W3 = 25.0f;
    self.backBtn.frame = CGRectMake(X3, Y3, W3, H3);
    
}


- (void)playClick:(UIButton *)sender {
    if (!self.assetURLs.count) {
        return;
    }
    
    [self.player playTheIndex:0];
    [self.controlView showTitle:@"" coverURLString:nil fullScreenMode:ZFFullScreenModeLandscape];
}


- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
    return self.player.isStatusBarHidden;
}


- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.player.currentPlayerManager.muted = !self.player.currentPlayerManager.muted;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
        //_controlView.fastViewAnimated = YES;
    }
    return _controlView;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor whiteColor];
    }
    return _containerView;
}

- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"new_allPlay_44x44_"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}

-(UIImageView *)backImageView{
    if (!_backImageView) {
        UIImageView *backImageView = [[UIImageView alloc]init];
        [backImageView setBackgroundColor:[UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:0.5]];
        _backImageView = backImageView;
        [_backImageView setImage:[UIImage imageNamed:@"exam_bg"]];
        _backImageView.userInteractionEnabled = YES;
    }
    return _backImageView;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
