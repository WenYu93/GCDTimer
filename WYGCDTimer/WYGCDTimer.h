//
//  WYGCDTimer.h
//  WYGCDTimer
//
//  Created by Vincent Yu on 2020/3/23.
//  Copyright © 2020 wy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^WYGCDTimerBlock)(void);
@interface WYGCDTimer : NSObject

/// 初始化Timer
/// @param interval 时间间隔
/// @param repeat 重复
/// @param completion 回调
+ (WYGCDTimer *)timerWithInterval:(NSTimeInterval)interval
                           repeat:(BOOL)repeat
                       completion:(WYGCDTimerBlock)completion;

/// 开始
- (void)startTimer;

/// 结束
- (void)invalidateTimer;

/// 暂停
- (void)pauseTimer;

/// 恢复
- (void)resumeTimer;

@end

NS_ASSUME_NONNULL_END
