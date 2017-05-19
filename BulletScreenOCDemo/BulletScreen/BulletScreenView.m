//
//  BulletScreenView.m
//  BulletScreenOCDemo
//
//  Created by 冯文秀 on 2017/5/18.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "BulletScreenView.h"
#define KSCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define KSCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define DURATION_TIME 6
#define BULLET_SPACE 13

@interface BulletScreenView()
@property (nonatomic, assign) BOOL hasDealloc;
@end


@implementation BulletScreenView

- (void)dealloc{
    [self stopBulletAnimation];
    self.bulletScreenSate = nil;
}

- (id)initWithContent:(NSString *)content{
    if (self = [super init]) {
        self.userInteractionEnabled = NO;
        
        NSDictionary *attributesDic = @{
                                     NSFontAttributeName:[UIFont systemFontOfSize:14]
                                     };
        float contentWidth = [content sizeWithAttributes:attributesDic].width;
        self.bounds = CGRectMake(0, 0, contentWidth + BULLET_SPACE*2, 25);
        
        // 初始化 弹幕评论label
        self.bulletContentLab = [UILabel new];
        self.bulletContentLab.frame = CGRectMake(BULLET_SPACE, 0, contentWidth, 25);
        self.bulletContentLab.backgroundColor = [UIColor clearColor];
        self.bulletContentLab.text = content;
        self.bulletContentLab.font = [UIFont systemFontOfSize:14];
        self.bulletContentLab.textColor = [UIColor blackColor];
        [self addSubview:_bulletContentLab];
    }
    return self;
}

- (void)startBulletAnimation{
    // 总宽
    CGFloat totalWidth = CGRectGetWidth(self.frame) + KSCREEN_WIDTH + 50;
    // 根据定义的间隔时限 计算弹幕的速度
    CGFloat speed = totalWidth/DURATION_TIME;
    // 以及完全进入屏幕的时间
    CGFloat duration = (CGRectGetWidth(self.frame) + 50)/speed;
    
    __block CGRect frame = self.frame;

    if (self.bulletScreenSate) {
        // 弹幕进入屏幕
        self.bulletScreenSate(BulletScreenStart);
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 避免重复 判断是否释放
        if (self.hasDealloc) {
            return;
        }
        
        // duration 后弹幕进入屏幕
        if (self.bulletScreenSate) {
            self.bulletScreenSate(BulletScreenOn);
        }
    });
    
    
    // 弹幕完全进入屏幕
    [UIView animateWithDuration:DURATION_TIME delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        frame.origin.x = - CGRectGetWidth(frame);
        self.frame = frame;
    } completion:^(BOOL finished) {
        if (self.bulletScreenSate) {
            self.bulletScreenSate(BulletScreenEnd);
        }
        [self removeFromSuperview];

    }];
}

- (void)stopBulletAnimation {
    self.hasDealloc = YES;
    [self.layer removeAllAnimations];
    [self removeFromSuperview];
}







/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
