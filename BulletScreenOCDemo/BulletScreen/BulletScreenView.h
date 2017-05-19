//
//  BulletScreenView.h
//  BulletScreenOCDemo
//
//  Created by 冯文秀 on 2017/5/18.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 弹幕状态

 - BulletScreenStart: 开始进入屏幕
 - BulletScreenOn: 完全进入屏幕
 - BulletScreenEnd: 完全离开屏幕
 */
typedef NS_ENUM(NSInteger, BulletScreenState) {
    BulletScreenStart,
    BulletScreenOn,
    BulletScreenEnd
};


/**
 弹幕道

 - BulletScreenOne: 弹道1
 - BulletScreenTwo: 弹道2
 - BulletScreenThree: 弹道3
 - BulletScreenFour: 弹道4
 */
typedef NS_ENUM(NSInteger, BulletScreenWay) {
    BulletScreenOne,
    BulletScreenTwo,
    BulletScreenThree,
};


@interface BulletScreenView : UIView
@property (nonatomic, copy) void(^bulletScreenSate)(BulletScreenState state);
@property (nonatomic, assign) BulletScreenWay bulletWay;
@property (nonatomic, strong) UILabel *bulletContentLab;


/**
 初始化 BulletScreenView

 @param content 弹幕文本内容
 @return BulletScreenView
 */
- (id)initWithContent:(NSString *)content;

/**
 打开弹幕动画
 */
- (void)startBulletAnimation;


/**
 关闭弹幕动画
 */
- (void)stopBulletAnimation;

@end
