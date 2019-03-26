//
//  VideoRecordViewController.m
//  iShow
//
//  Created by 胡阳阳 on 17/3/8.
//
//

#import "VideoRecordViewController.h"
#import "VideoCameraView.h"
#import "RTRootNavigationController.h"
#import "Masonry.h"
@interface VideoRecordViewController ()<VideoCameraDelegate>


@property (nonatomic ,strong) UITextField* configWidth;
@property (nonatomic ,strong) UITextField* configHight;
@property (nonatomic ,strong) UITextField* configBit;
@property (nonatomic ,strong) UITextField* configFrameRate;
@property (nonatomic ,strong) UIButton* okBtn;

@end

@implementation VideoRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self clickOKBtn];
    
}
-(void)clickBackHome
{
//    [[NSNotificationCenter defaultCenter] postNotificationName:kTabBarHiddenNONotification object:self];
    [self.navigationController popViewControllerAnimated:YES];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
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
  [self.rt_navigationController pushViewController:cor animated:YES complete:nil];
}

- (BOOL)prefersStatusBarHidden {
  return YES;
}
-(void)dealloc
{
    [[GPUImageContext sharedImageProcessingContext].framebufferCache purgeAllUnassignedFramebuffers];
    NSLog(@"%@释放了",self.class);
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
