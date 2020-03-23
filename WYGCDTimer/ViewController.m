//
//  ViewController.m
//  WYGCDTimer
//
//  Created by Vincent Yu on 2020/3/23.
//  Copyright © 2020 wy. All rights reserved.
//

#import "ViewController.h"
#import "WYGCDTimer.h"
@interface ViewController ()

@property (nonatomic, strong) WYGCDTimer *timer;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;

@property (nonatomic, strong) dispatch_source_t source;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    dispatch_queue_t progressQueue = dispatch_queue_create("com.wy>gcdtimer", DISPATCH_QUEUE_CONCURRENT);
    self.source = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, progressQueue);
    
    __weak typeof(self) weakself = self;
    dispatch_source_set_event_handler(self.source, ^{
        NSUInteger progress = dispatch_source_get_data(self.source);
        if (progress >= 100) {
            progress = 100;
            dispatch_source_cancel(weakself.source);
            weakself.source = nil;
        }
        NSLog(@"percent: %@", [NSString stringWithFormat:@"%ld",progress]);
    });
    
    dispatch_resume(self.source);
    
}
- (IBAction)buttonClicked:(id)sender {
    [self.timer startTimer];
    
}

- (WYGCDTimer *)timer {
    if (!_timer) {
        __weak typeof(self) weakself = self;
        _timer = [WYGCDTimer timerWithInterval:1 repeat:YES completion:^{
           static NSUInteger _progress = 0;
            _progress += 10;
            if (_progress > 100) {
                _progress = 100;
                [weakself.timer invalidateTimer];
                weakself.timer = nil;
            }
            if (weakself.source) {
                dispatch_source_merge_data(weakself.source, _progress);
            }
        }];
    }
    return _timer;
}

@end
