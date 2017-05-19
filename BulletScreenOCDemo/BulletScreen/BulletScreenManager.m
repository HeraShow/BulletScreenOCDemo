//
//  BulletScreenManager.m
//  BulletScreenOCDemo
//
//  Created by 冯文秀 on 2017/5/18.
//  Copyright © 2017年 冯文秀. All rights reserved.
//

#import "BulletScreenManager.h"
@interface BulletScreenManager()
@property (nonatomic, strong) NSMutableArray *tempArray;
@property (nonatomic, strong) NSMutableArray *bulletQueueArr;

@property (nonatomic, assign) BOOL startState;
@property (nonatomic, assign) BOOL stopState;

@end


@implementation BulletScreenManager

- (NSMutableArray *)totalArray{
    if (!_totalArray) {
        _totalArray = [NSMutableArray array];
    }
    return _totalArray;
}

- (NSMutableArray *)tempArray{
    if (!_tempArray) {
        _tempArray = [NSMutableArray array];
    }
    return _tempArray;
}

- (NSMutableArray *)bulletQueueArr{
    if (!_bulletQueueArr) {
        _bulletQueueArr = [NSMutableArray array];
    }
    return _bulletQueueArr;
}

- (void)startManagerBullet{
    if (self.tempArray.count == 0) {
        [self.tempArray addObjectsFromArray:_totalArray];
    }
    self.startState = YES;
    self.stopState = NO;
    [self initCommentBulletScreen];
}

- (void)stopManagerBullet{
    self.stopState = YES;
    [self.bulletQueueArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        BulletScreenView *bulletView = obj;
        [bulletView stopBulletAnimation];
        bulletView = nil;
    }];
}


# pragma mark ---- Private ----

/**
 创建弹幕

 @param content 弹幕的文本内容
 @param bulletWay 弹幕的弹道
 */
- (void)createBulletScreenWithContent:(NSString *)content bulletWay:(BulletScreenWay)bulletWay{
    if (self.stopState) {
        return;
    }
    
    BulletScreenView *bulletView = [[BulletScreenView alloc]initWithContent:content];
    bulletView.bulletWay = bulletWay;
    
    __weak BulletScreenView *weakBulletView = bulletView;
    __weak BulletScreenManager *mySelef = self;
    
    
    /**
     根据弹幕的状态去判断执行

     @param state 弹幕的状态
     @return bulletScreenSate
     */
    bulletView.bulletScreenSate = ^(BulletScreenState state) {
        if (self.stopState) {
            return;
        }
        switch (state) {
            case BulletScreenStart:
                // 将开始的弹幕加入到 管理的queue
                [mySelef.bulletQueueArr addObject:weakBulletView];
                break;
                
            case BulletScreenOn:{
                // 完全进入屏幕后 判断后续是否还有内容 有则在弹道队列中创建内容
                NSString *contentStr = [mySelef nextContent];
                
                if (contentStr) {
                    [mySelef createBulletScreenWithContent:contentStr bulletWay:bulletWay];
                    
                } else{
                    // 弹幕内容到结尾了 不做操作
                }
                break;
            }
                
            case BulletScreenEnd:{
                // 弹幕从屏幕中 飞出后 从管理队列中删除
                if ([mySelef.bulletQueueArr containsObject:weakBulletView]) {
                    [mySelef.bulletQueueArr removeObject:weakBulletView];
                }
                
                // 说明屏幕上没有弹幕内容了 重新开始
                if (mySelef.bulletQueueArr.count == 0) {
                    [mySelef startManagerBullet];
                }
                break;
            }
            default:
                break;
        }
    };
    
    // 生成后，展示到 controler
    if (self.managerBulletScreen) {
        self.managerBulletScreen(bulletView);
    }

}


/**
 初始化弹幕
 */
- (void)initCommentBulletScreen{
    NSMutableArray *waysArray = [NSMutableArray arrayWithArray:@[@(1), @(2), @(3)]];
    for (NSInteger i = 3; i > 0; i--) {
        NSString *contentStr = self.tempArray.firstObject;
        if (contentStr) {
            [self.tempArray removeObjectAtIndex:0];
            
            // 此处没有数据来源 故随机生成弹幕
            NSInteger index = arc4random()%waysArray.count;
            BulletScreenWay bulletWay = [waysArray[index] integerValue];
            [waysArray removeObjectAtIndex:index];
            [self createBulletScreenWithContent:contentStr bulletWay:bulletWay];
            
        } else{
            // 弹道小于 3个 则选择跳出
            break;
        }
    }
}

- (NSString *)nextContent{
    NSString *contentStr = self.tempArray.firstObject;
    if (contentStr) {
        [self.tempArray removeObjectAtIndex:0];
    }
    return contentStr;
}



@end
