//
//  ViewController.m
//  JYVideoPicker
//
//  Created by Joblee on 2019/3/20.
//  Copyright © 2019年 jiuyu. All rights reserved.
//

#import "ViewController.h"
#import "VideoCameraView.h"
#import "RTRootNavigationController.h"
#import "Masonry.h"
@interface ViewController ()<VideoCameraDelegate>


@property (nonatomic ,strong) UITextField* configWidth;
@property (nonatomic ,strong) UITextField* configHight;
@property (nonatomic ,strong) UITextField* configBit;
@property (nonatomic ,strong) UITextField* configFrameRate;
@property (nonatomic ,strong) UIButton* okBtn;

@end


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];

}

-(void)clickBackHome
{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarHiddenNONotification object:self];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self clickOKBtn];
}
-(void)clickOKBtn
{
    [_configBit resignFirstResponder];
    [_configWidth resignFirstResponder];
    [_configHight resignFirstResponder];
    int width,hight,bit,framRate;
    if (_configWidth.text.length>0&&_configHight.text.length>0) {
        [NSNumber numberWithInt:5];
        width = [_configWidth.text intValue];
        hight = [_configHight.text intValue];
    }
    else
    {
        width = 720;
        hight = 1280;
    }
    if (_configBit.text.length>0) {
        bit = [_configBit.text intValue];
    }
    else
    {
        bit = 2500000;
    }
    if (_configFrameRate.text.length>0) {
        framRate = [_configFrameRate.text intValue];
    }
    else
    {
        framRate = 30;
    }
    bool needNewVideoCamera = YES;
    for (UIView* subView in self.view.subviews) {
        if ([subView isKindOfClass:[VideoCameraView class]]) {
            needNewVideoCamera = NO;
            VideoCameraView *view = (VideoCameraView *)subView;
            [view resetToVideo];
        }
    }
    if (needNewVideoCamera) {
        [[UIApplication sharedApplication] setStatusBarHidden:YES];
        CGRect frame = [[UIScreen mainScreen] bounds];
        VideoCameraView* videoCameraView = [[VideoCameraView alloc] initWithFrame:frame];
        videoCameraView.delegate = self;
        NSLog(@"new VideoCameraView");
        videoCameraView.width = [NSNumber numberWithInteger:width];
        videoCameraView.hight = [NSNumber numberWithInteger:hight];
        videoCameraView.bit = [NSNumber numberWithInteger:bit];
        videoCameraView.frameRate = [NSNumber numberWithInteger:framRate];
        
        typeof(self) __weak weakself = self;
        videoCameraView.backToHomeBlock = ^(){
            //            [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarHiddenNONotification object:self];
            //            [weakself.navigationController popViewControllerAnimated:NO];
            [weakself.navigationController dismissViewControllerAnimated:YES completion:nil];
            
            [[UIApplication sharedApplication] setStatusBarHidden:NO];
            NSLog(@"clickBackToHomg2");
        };
        [self.view addSubview:videoCameraView];
    }
}

//-(void)viewDidDisappear:(BOOL)animated
//{
//    [super viewDidDisappear:animated];
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)presentCor:(UIViewController *)cor
{
    [self presentViewController:cor animated:YES completion:nil];
}

-(void)pushCor:(UIViewController *)cor
{
    [self.navigationController pushViewController:cor animated:YES];
//    [self.navigationController pushViewController:cor animated:YES complete:nil];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}
-(void)dealloc
{
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
    NSLog(@"%@释放了",self.class);
}

@end
