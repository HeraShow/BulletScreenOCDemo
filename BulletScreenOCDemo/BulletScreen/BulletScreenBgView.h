//
//  BulletScreenBgView.h
//  BulletScreenOCDemo
//
//  Created by 冯文秀 on 2017/5/18.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BulletScreenView.h"

@interface BulletScreenBgView : UIView

/**
 用于直接处理弹幕

 @param gesture 屏幕上捕捉到的手势
 @param bulletBlock 弹幕block
 */
- (void)dealGesture:(UIGestureRecognizer *)gesture bulletBlock:(void (^)(BulletScreenView *bulletView))bulletBlock;

@end
