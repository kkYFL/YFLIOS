//
//  GuideViewController.m
//  Ewt360
//
//  Created by mistong on 17/1/22.
//  Copyright © 2017年 铭师堂. All rights reserved.
//

#import "GuideViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import "RYPageControl.h"
#import "HanZhaoHua.h"

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
int lastindex = 0;


@interface GuideViewController ()<UIScrollViewDelegate>{
    
    AVPlayer        *avPlayer1;
    AVPlayer        *avPlayer2;
    AVPlayer        *avPlayer3;
    AVPlayer        *avPlayer4;
    AVPlayer        *avPlayer5;
    AVPlayerLayer   *avlayer1;
    AVPlayerLayer   *avlayer2;
    AVPlayerLayer   *avlayer3;
    AVPlayerLayer   *avlayer4;
    AVPlayerLayer   *avlayer5;
    
    RYPageControl *_pageControl;
    BOOL _isOpenGuide;
    NSInteger pageCount;
}
@property (nonatomic,strong) UIScrollView *scroll;
@property (strong,nonatomic) UIScrollView *scrollView;
@property (nonatomic, strong) NSMutableArray *remoteImageArr;

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    pageCount = 4;
    
    [self guidenViewSource];
}

-(void)setViewWithData{
    if (self.videoOrImageType == videoTpye) {
        [self videoTypeBuilding];
    } else {
        _isOpenGuide = NO;
        [self imageTypeBuilding];
    }
}

- (void)imageTypeBuilding {
    CGFloat heightScale = 0;
    switch ((NSInteger)SCREEN_HEIGHT) {
            // iPhone 4/4s
        case 480: {
            heightScale = 480.0f / 667.0f;
        }
            break;
            
            // iPhone 5/5s
        case 568: {
            heightScale = 568.0f / 667.0f;
        }
            break;
            
        case 736: {
            heightScale = 736.0f / 667.0f;
        }
            break;
            
        default: {
            heightScale = 1.0f;
        }
            break;
    }

    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self.scrollView setShowsHorizontalScrollIndicator:NO];
    [self.view addSubview:self.scrollView];
    //
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * self.remoteImageArr.count, 0);
    //
    
    for (int i = 0; i < 4; i++) {
        //主图片
        UIImageView *mainImage = [[UIImageView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH*i, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        mainImage.userInteractionEnabled = YES;
        [self.scrollView addSubview:mainImage];
        
        // 适配
        // todo 适配 iPhoneXSM
//        if (KISIphoneX) {
//            // 分辨率同：iPhoneX
//            mainImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ipx_%d", i]];
//        } else if (SCREEN_HEIGHT == 480 ) {
//            // 4:3屏幕  分辨率同 iPhone4
//            mainImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ios_5.7.0_0%d",i]];
//        } else {
//            // 16:9屏幕 分辨率同 iPhone5 iPhone6 iPhone6P
//            mainImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"ios_5.7.0_1%d",i]];
//        }
        
//        [mainImage sd_setImageWithURL:[NSURL URLWithString:self.remoteImageArr[i]] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipx_%d", i]]];
//        [mainImage sd_setImageWithURL:[NSURL URLWithString:self.remoteImageArr[i]] placeholderImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipx_%d", i]]];
        [mainImage setImage:[UIImage imageNamed:[NSString stringWithFormat:@"ipx_%d", i]]];

        
        if (i == (self.remoteImageArr.count - 1)) {
            UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(kipBtnClicked)];
            [mainImage addGestureRecognizer:gesture];
        }
    }
}

-(void)guidenViewSource{
    [self setViewWithData];
//    NSMutableDictionary *para = [NSMutableDictionary dictionary];
//    [para setValue:@"HNX_GUIDE" forKey:@"config"];
//
//    self.remoteImageArr = [NSMutableArray array];
//    [HanZhaoHua GetAPPGuidenViewImageSourceWithParaDic:para success:^(NSDictionary * _Nonnull responseObject) {
//        NSArray *arr = [responseObject objectForKey:@"data"];
//        if (arr && [arr isKindOfClass:[NSArray class]]) {
//            for (NSInteger i = 0; i<arr.count; i++) {
//                NSDictionary *objDic = arr[i];
//                NSString *imgUrl = [NSString stringWithFormat:@"%@",[objDic objectForKey:@"imgUrl"]];
//                if (![NSString isBlankString:imgUrl]) {
//                    [self.remoteImageArr addObject:imgUrl];
//                }
//            }
//        }
//
//        if (self.remoteImageArr.count) {
//            [self setViewWithData];
//        }else{
//            [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationUserSignOut object:nil];
//        }
//
//
//    } failure:^(NSError * _Nonnull error) {
//        //进入注册页面
//
//     [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationUserSignOut object:nil];
//    }];
}

- (void)videoTypeBuilding {
    _scroll = [[UIScrollView alloc]init];
    _scroll.backgroundColor = [UIColor whiteColor];
    _scroll.delegate = self;
    _scroll.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _scroll.backgroundColor = [UIColor clearColor];
    _scroll.showsHorizontalScrollIndicator = NO;
    _scroll.showsVerticalScrollIndicator = NO;
    _scroll.pagingEnabled = YES;
    _scroll.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _scroll.contentSize = CGSizeMake((self.view.frame.size.width)*2, _scroll.frame.size.height);
    _scroll.bounces = NO;
    [self.view addSubview:_scroll];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback withOptions:AVAudioSessionCategoryOptionMixWithOthers error:nil];
    NSURL *urlMovie1 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"guide_11" ofType:@"mp4"]];
    AVURLAsset *asset1 = [AVURLAsset URLAssetWithURL:urlMovie1 options:nil];
    AVPlayerItem *playerItem1 = [AVPlayerItem playerItemWithAsset:asset1];
    avPlayer1 = [AVPlayer playerWithPlayerItem: playerItem1];
    avlayer1 = [AVPlayerLayer playerLayerWithPlayer:avPlayer1];
    avlayer1.frame = (CGRect){0, 0, self.view.frame.size.width, self.view.frame.size.height};
    avlayer1.videoGravity = AVLayerVideoGravityResize;
    [_scroll.layer addSublayer:avlayer1];
    
    NSURL *urlMovie2 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"guide_12" ofType:@"mp4"]];
    AVURLAsset *asset2 = [AVURLAsset URLAssetWithURL:urlMovie2 options:nil];
    AVPlayerItem *playerItem2 = [AVPlayerItem playerItemWithAsset:asset2];
    avPlayer2 = [AVPlayer playerWithPlayerItem: playerItem2];
    avlayer2 = [AVPlayerLayer playerLayerWithPlayer:avPlayer2];
    avlayer2.frame = (CGRect){self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height};
    //视频充满
    avlayer2.videoGravity = AVLayerVideoGravityResize;
    [_scroll.layer addSublayer:avlayer2];
    
    NSURL *urlMovie3 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"guide_13" ofType:@"mp4"]];
    AVURLAsset *asset3 = [AVURLAsset URLAssetWithURL:urlMovie3 options:nil];
    AVPlayerItem *playerItem3 = [AVPlayerItem playerItemWithAsset:asset3];
    avPlayer3  = [AVPlayer playerWithPlayerItem: playerItem3];
    avlayer3 = [AVPlayerLayer playerLayerWithPlayer:avPlayer3];
    avlayer3.frame = (CGRect){self.view.frame.size.width*2, 0, self.view.frame.size.width, self.view.frame.size.height};
    avlayer3.videoGravity = AVLayerVideoGravityResize;
    [_scroll.layer addSublayer:avlayer3];
    
    NSURL *urlMovie4 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"guide_14" ofType:@"mp4"]];
    AVURLAsset *asset4 = [AVURLAsset URLAssetWithURL:urlMovie4 options:nil];
    AVPlayerItem *playerItem4 = [AVPlayerItem playerItemWithAsset:asset4];
    avPlayer4  = [AVPlayer playerWithPlayerItem: playerItem4];
    avlayer4 = [AVPlayerLayer playerLayerWithPlayer:avPlayer4];
    avlayer4.frame = (CGRect){self.view.frame.size.width*3, 0, self.view.frame.size.width, self.view.frame.size.height};
    avlayer4.videoGravity = AVLayerVideoGravityResize;
    [_scroll.layer addSublayer:avlayer4];
    
    
    NSURL *urlMovie5 = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"guide_15" ofType:@"mp4"]];
    AVURLAsset *asset5 = [AVURLAsset URLAssetWithURL:urlMovie5 options:nil];
    AVPlayerItem *playerItem5 = [AVPlayerItem playerItemWithAsset:asset5];
    avPlayer5  = [AVPlayer playerWithPlayerItem: playerItem5];
    avlayer5 = [AVPlayerLayer playerLayerWithPlayer:avPlayer5];
    avlayer5.frame = (CGRect){self.view.frame.size.width*4, 0, self.view.frame.size.width, self.view.frame.size.height};
    avlayer5.videoGravity = AVLayerVideoGravityResize;
    [_scroll.layer addSublayer:avlayer5];
    
    [avPlayer1 play];
    
    _pageControl=[[RYPageControl alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-30, self.view.frame.size.width, 30) currentColor:[UIColor blackColor] nextColor:[UIColor colorWithRed:255 green:245 blue:0 alpha:1.0f] rsize:5];
    [_pageControl setBackgroundColor:[UIColor clearColor]];
    _pageControl.userInteractionEnabled=NO;
    _pageControl.numberOfPages = 5;
    [self.view addSubview:_pageControl];
    
    
    self.kipBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    self.kipBtn.frame = (CGRect){self.view.frame.size.width*4, 0, self.view.frame.size.width, self.view.frame.size.height};
    [self.kipBtn addTarget:self action:@selector(kipBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [_scroll addSubview:self.kipBtn];

}

- (void)dealloc {
    self.scrollView.delegate = nil;
}
- (void)kipBtnClicked
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *intro = [NSString stringWithFormat:@"guidePage_%@", APP_VERSION];
    [defaults setObject:@"YES" forKey:@"hasGuiden"];
    [defaults synchronize];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNotificationUserSignOut object:nil];
    
    //[EWTStartTool chooseContentView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.scrollView.contentOffset.x > SCREEN_WIDTH * (self.remoteImageArr.count - 1) + 10) {
        if (!_isOpenGuide) {
            _isOpenGuide = YES;
            [self kipBtnClicked];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    int Offset = _scroll.contentOffset.x/_scroll.frame.size.width;
    
    if (Offset == lastindex)
    {
        return;
    }
    if (Offset == 0)
    {
        [avPlayer1 seekToTime:kCMTimeZero];
        [avPlayer1 play];
        [avPlayer2 seekToTime:kCMTimeZero];
        [avPlayer2 pause];
        [avPlayer3 seekToTime:kCMTimeZero];
        [avPlayer3 pause];
        [avPlayer4 seekToTime:kCMTimeZero];
        [avPlayer4 pause];
        [avPlayer5 seekToTime:kCMTimeZero];
        [avPlayer5 pause];
        _pageControl.currentPage = 0;
    }
    else if (Offset == 1)
    {
        [avPlayer2 seekToTime:kCMTimeZero];
        [avPlayer2 play];
        [avPlayer1 seekToTime:kCMTimeZero];
        [avPlayer1 pause];
        [avPlayer3 seekToTime:kCMTimeZero];
        [avPlayer3 pause];
        [avPlayer4 seekToTime:kCMTimeZero];
        [avPlayer4 pause];
        [avPlayer5 seekToTime:kCMTimeZero];
        [avPlayer5 pause];
        _pageControl.currentPage = 1;
    }
    else if (Offset == 2)
    {
        [avPlayer3 seekToTime:kCMTimeZero];
        [avPlayer3 play];
        [avPlayer1 seekToTime:kCMTimeZero];
        [avPlayer1 pause];
        [avPlayer2 seekToTime:kCMTimeZero];
        [avPlayer2 pause];
        [avPlayer4 seekToTime:kCMTimeZero];
        [avPlayer4 pause];
        [avPlayer5 seekToTime:kCMTimeZero];
        [avPlayer5 pause];
        _pageControl.currentPage = 2;
    }
    else if (Offset == 3)
    {
        [avPlayer4 seekToTime:kCMTimeZero];
        [avPlayer4 play];
        [avPlayer1 seekToTime:kCMTimeZero];
        [avPlayer1 pause];
        [avPlayer2 seekToTime:kCMTimeZero];
        [avPlayer2 pause];
        [avPlayer3 seekToTime:kCMTimeZero];
        [avPlayer3 pause];
        [avPlayer5 seekToTime:kCMTimeZero];
        [avPlayer5 pause];
        _pageControl.currentPage = 3;
    }
    else if (Offset == 4)
    {
        [avPlayer5 seekToTime:kCMTimeZero];
        [avPlayer5 play];
        [avPlayer1 seekToTime:kCMTimeZero];
        [avPlayer1 pause];
        [avPlayer2 seekToTime:kCMTimeZero];
        [avPlayer2 pause];
        [avPlayer3 seekToTime:kCMTimeZero];
        [avPlayer3 pause];
        [avPlayer4 seekToTime:kCMTimeZero];
        [avPlayer4 pause];
        _pageControl.currentPage = 4;
    }
    lastindex = Offset;
}


//- (void)player1ItemDidReachEnd
//{
//    [avPlayer1 seekToTime:kCMTimeZero];
//    [avPlayer1 play];
//
//}
//- (void)player2ItemDidReachEnd
//{
//    [avPlayer2 seekToTime:kCMTimeZero];
//    [avPlayer2 play];
//    
//}
//
//
//- (void)player3ItemDidReachEnd
//{
//    [avPlayer3 seekToTime:kCMTimeZero];
//    [avPlayer3 play];
//    
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
