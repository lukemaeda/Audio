//
//  ViewController.m
//  Audio
//
//  Created by kunren10 on 2014/03/03.
//  Copyright (c) 2014年 Hajime Maeda. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <QuartzCore/QuartzCore.h>
#import "ViewController.h"

@interface ViewController ()  <AVAudioPlayerDelegate> {
	
	// AVAudioPlayerオブジェクト
	AVAudioPlayer *_adp01;
}

@property (weak, nonatomic) IBOutlet UIImageView *ivImage;
@property (weak, nonatomic) IBOutlet UILabel *lbInformation;
@property (weak, nonatomic) IBOutlet UISwitch *swPlay;

@end

@implementation ViewController

#pragma mark - UIViewController Method
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	// 準備処理
	[self doReady];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Method
// [再生／停止]スイッチ変更
- (IBAction)changePlay:(UISwitch *)sender {
	
	// スイッチ値の判定
	if (sender.on == YES) {
		
		// 再生
		[_adp01 play];
		
		// アニメーション開始
		[self animateStart:self.ivImage];
		
	} else {
		
		// 一時停止
//		[_adp01 pause];
		
		// 停止
		[_adp01 stop];
		[_adp01 prepareToPlay];
		_adp01.currentTime = 0.0;
		
		// アニメーション停止
		[self animateEnd:self.ivImage];
	}
}

// [ボリューム]スライダー変更
- (IBAction)changeVolume:(UISlider *)sender {
	
	// 音量設定 (0.0-1.0)
	_adp01.volume = sender.value;
}

// [パンニング]スライダー変更
- (IBAction)changePanning:(UISlider *)sender {
	
	// パンニング設定 (-1.0-1.0)
	_adp01.pan = sender.value;
}

// [再生速度]スライダー変更
- (IBAction)changeSpeed:(UISlider *)sender {
	
	// 再生速度設定 (0.0-2.0)
	_adp01.rate = sender.value;
}

#pragma mark - AVAudioPlayerDelegate Method
// サウンド再生完了時
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
					   successfully:(BOOL)flag {
	
	// [再生／停止]スイッチOFF
	self.swPlay.on = NO;
}

#pragma mark - Own Method(自分の自作メソッド)
// 準備処理
- (void)doReady {
	
	// 音楽ファイルの参照
	NSBundle *bnd01 = [NSBundle mainBundle];
	NSString *pth01 = [bnd01 pathForResource:@"She's_a_Rainbow"
									  ofType:@"mp3"];
	NSURL *url01 = [NSURL fileURLWithPath:pth01];
	
	// AVAudioPlayerオブジェクト生成
	_adp01 = [[AVAudioPlayer alloc] initWithContentsOfURL:url01
													error:nil];
	
	// 設定（再生速度の変更許可）
	_adp01.enableRate = YES;
	
	// 設定（デリゲート）
	_adp01.delegate = self;
	
	// 設定（再生位置）
    //	_adp01.currentTime = _adp01.duration - 5.0;
	
	// 再生準備
	[_adp01 prepareToPlay];
	
	// 音楽情報の表示
	NSString *name01 = url01.lastPathComponent;
	NSTimeInterval len01 = _adp01.duration;
	
	self.lbInformation.text =
    [NSString stringWithFormat:
     @"%@\n%.f秒", name01, len01];
}

// アニメーション開始（要：QuartzCore.framework）
- (void)animateStart:(UIImageView *)imageView {
	
	// アニメーション設定
	// (種類(Z軸回転))
	CABasicAnimation *ani =
		[CABasicAnimation animationWithKeyPath:
		 @"transform.rotation.z"];
	
	// (変化値)
	ani.fromValue = [NSNumber numberWithDouble:0.0];
	ani.toValue   = [NSNumber numberWithDouble:2.0 * M_PI];
	
	// (アニメーション時間(秒))
	ani.duration = 2.0;
	
	// (繰返し回数)
	ani.repeatCount = HUGE_VALF;	// 無限
	
	// アニメーション開始
	[imageView.layer addAnimation:ani forKey:@"ANIM01"];
}

// アニメーション停止
- (void)animateEnd:(UIImageView *)imageView {
	
	// アニメーション削除
	[imageView.layer removeAnimationForKey:@"ANIM01"];
}

@end
