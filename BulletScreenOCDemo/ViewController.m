//
//  ViewController.m
//  BulletScreenOCDemo
//
//  Created by 冯文秀 on 2017/5/18.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "ViewController.h"
#import "BulletScreenManager.h"
#import "BulletScreenBgView.h"

#define KSCREEN_WIDTH  [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT  [UIScreen mainScreen].bounds.size.height

@interface ViewController ()
@property (nonatomic, strong) BulletScreenManager *bulletManager;
@property (nonatomic, strong) BulletScreenBgView *bulletBgView;


@end
@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    UIButton *clickButton = [[UIButton alloc]initWithFrame:CGRectMake(KSCREEN_WIDTH/2 - 50, KSCREEN_HEIGHT - 120, 100, 30)];
    clickButton.selected = NO;
    clickButton.backgroundColor = [UIColor cyanColor];
    clickButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [clickButton setTitle:@"打开弹幕" forState:UIControlStateNormal];
    [clickButton setTitle:@"关闭弹幕" forState:UIControlStateSelected];

    [clickButton addTarget:self action:@selector(openOrCloseBulletScreen:) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:clickButton];
    
    // 给弹幕添加手势处理
    [self addBulletTapGesture];
    
}

- (void)beganInit{
    self.bulletManager = [[BulletScreenManager alloc] init];
    self.bulletManager.totalArray = [NSMutableArray arrayWithObjects:@"哈哈，我就是一条弹幕", @"你来咬我啊", @"你是不是傻", @"心情不好，不想BB", @"快让我去找静静，我要回家", @"有病就在家歇着，我可没药", nil];
    
    __weak ViewController *myself = self;
    self.bulletManager.managerBulletScreen = ^(BulletScreenView *bulletView) {
        [myself addBulletView:bulletView];
    };
}

- (void)addBulletView:(BulletScreenView *)bulletView {
    bulletView.frame = CGRectMake(CGRectGetWidth(self.view.frame) + 50, 20 + 34 * bulletView.bulletWay, CGRectGetWidth(bulletView.bounds), CGRectGetHeight(bulletView.bounds));
    [self.bulletBgView addSubview:bulletView];
    [bulletView startBulletAnimation];
}


//点击开始按钮，弹幕开始飞入屏幕
- (void)openOrCloseBulletScreen:(UIButton *)button {
    button.selected = !button.selected;
    if (button.selected) {
        // 每次重新开始 要重新初始化 否则关闭后再打开 不会轮循
        [self beganInit];
        [self.bulletManager startManagerBullet];
    } else{
        [self.bulletManager stopManagerBullet];
    }
}

- (BulletScreenBgView *)bulletBgView {
    if (!_bulletBgView) {
        _bulletBgView = [[BulletScreenBgView alloc] init];
        _bulletBgView.frame = CGRectMake(0, 300, CGRectGetWidth(self.view.frame), 150);
        _bulletBgView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:_bulletBgView];
    }
    return _bulletBgView;
}


- (void)addBulletTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    tap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tap];
    
}

- (void)tapHandler:(UITapGestureRecognizer *)gesture {
    [self.bulletBgView dealGesture:gesture bulletBlock:^(BulletScreenView *bulletView) {
        NSLog(@"bulletView.bulletContentLab.text ------ %@", bulletView.bulletContentLab.text);
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
