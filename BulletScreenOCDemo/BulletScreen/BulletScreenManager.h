//
//  BulletScreenManager.h
//  BulletScreenOCDemo
//
//  Created by 冯文秀 on 2017/5/18.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BulletScreenView.h"

@interface BulletScreenManager : NSObject
@property (nonatomic, copy) void (^managerBulletScreen)(BulletScreenView * bulletView);
@property (nonatomic, strong) NSMutableArray *totalArray;


/**
 开始
 */
- (void)startManagerBullet;



/**
 结束
 */
- (void)stopManagerBullet;



@end
