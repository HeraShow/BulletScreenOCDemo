//
//  BulletScreenBgView.m
//  BulletScreenOCDemo
//
//  Created by 冯文秀 on 2017/5/18.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "BulletScreenBgView.h"

@implementation BulletScreenBgView
- (id)init{
    if (self = [super init]) {
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    if ([self findClickBulletView:point]) {
        return self;
    }
    return nil;
}


- (BulletScreenView *)findClickBulletView:(CGPoint)point{
    BulletScreenView *bulletView = nil;
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[BulletScreenView class]]) {
            if ([view.layer.presentationLayer hitTest:point]) {
                bulletView = (BulletScreenView *)view;
                break;
            }
        }
    }
    return bulletView;
}

- (void)dealGesture:(UIGestureRecognizer *)gesture bulletBlock:(void (^)(BulletScreenView *))bulletBlock{
    CGPoint clickPoint =  [gesture locationInView:self];
    BulletScreenView *bulletView = [self findClickBulletView:clickPoint];
    if (bulletView) {
        bulletView.backgroundColor = [UIColor cyanColor];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            bulletView.backgroundColor = [UIColor redColor];
        });
        if (bulletBlock) {
            bulletBlock(bulletView);
        }
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
