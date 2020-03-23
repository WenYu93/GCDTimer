//
//  WYGCDTimer.m
//  WYGCDTimer
//
//  Created by Vincent Yu on 2020/3/23.
//  Copyright © 2020 wy. All rights reserved.
//

#import "WYGCDTimer.h"

@interface WYGCDTimer ()

@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, assign) BOOL repeat;
@property (nonatomic, copy) WYGCDTimerBlock completion;

@property (nonatomic, strong)dispatch_source_t timer;
@property (nonatomic, assign) BOOL isRunning;

@end

@implementation WYGCDTimer

+ (WYGCDTimer *)timerWithInterval:(NSTimeInterval)interval repeat:(BOOL)repeat completion:(WYGCDTimerBlock)completion {
    WYGCDTimer *timer = [[WYGCDTimer alloc] initWithInterval:interval repeat:repeat completion:completion];
    return timer;
    
}

- (instancetype)initWithInterval:(NSTimeInterval)interval repeat:(BOOL)repeat completion:(WYGCDTimerBlock)completion {
    if (self = [super init]) {
        self.interval = interval;
        self.repeat = repeat;
        self.completion = completion;
        self.isRunning = NO;
        
        // 初始化timer
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
        // 设置timer
        dispatch_source_set_timer(self.timer, DISPATCH_TIME_NOW, self.interval * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
        
        __weak typeof(self) weakSelf = self;
        // 设置回调
        dispatch_source_set_event_handler(self.timer, ^{
            [weakSelf excute];
        });
        
    }
    return self;
}

- (void)excute {
    if (self.completion) {
        self.completion();
    }
}

/// 开始
- (void)startTimer {
    if (self.timer && !self.isRunning) {
        self.isRunning = YES;
        dispatch_resume(self.timer);
    }
}

/// 结束
- (void)invalidateTimer {
    if (_timer) {
        dispatch_source_cancel(_timer);
        self.isRunning = NO;
        _timer = nil;
    }
}

/// 暂停
- (void)pauseTimer {
    if (self.timer && self.isRunning) {
        dispatch_suspend(self.timer);
    }
}

/// 恢复
- (void)resumeTimer {
    if (self.timer && !self.isRunning) {
        dispatch_resume(self.timer);
    }
}

@end
