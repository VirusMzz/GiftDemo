//
//  GiftDisplayView.m
//  GiftDemo
//
//  Created by 孙砚戈 on 7/20/16.
//  Copyright © 2016 孙砚戈. All rights reserved.
//

#import "GiftDisplayView.h"
#import "GiftEvent.h"

@interface GiftDisplayView ()
{
    NSTimer *mytimer;
    NSTimeInterval maximumStaySeconds;
}

@end

@implementation GiftDisplayView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置礼物持续时间
        maximumStaySeconds = 5;
        self.currentCombo = 0;
        self.finalCombo = 0;
        
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"GiftDisplayView" owner:self options:nil];
        
        for (id obj in arr) {
            [self addSubview:obj];
        }
    }
    return self;
}

- (void)addDismissHandler:(dismissHandler)handler{

    self.dismissHandler = handler;
}
/*
 @property (weak, nonatomic) IBOutlet UILabel *SendLB;
 @property (weak, nonatomic) IBOutlet UIImageView *img;
 @property (weak, nonatomic) IBOutlet UILabel *comboLB;
 */
- (void)initialGiftEvent:(GiftEvent *)event{

    self.SendLB.text = @"Send a gift ok!";
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gift-%d", event.giftId]];
                      
    self.img.image = image;
    self.event = event;
    self.comboLB.text = [NSString stringWithFormat:@"x%d", self.currentCombo];
}

//开始循环combo动画
- (void)startAnimationCombo{

    if (!mytimer) {
        mytimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(tick:) userInfo:nil repeats:true];
        [[NSRunLoop currentRunLoop] addTimer:mytimer forMode:NSRunLoopCommonModes];
    }
    else{
    
        [mytimer setFireDate:[NSDate distantPast]];
    }
}

//循环
- (void)tick:(NSTimer *)timer{

    //如果当前时间 和上次事件时间差 > maxstaySec -> 终止动画 -> dismiss 自己
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    //如果超时，就dismiss 并返回
    if (((now - self.lastEventTime) > maximumStaySeconds)) {
        
        if (timer) {
            [timer setFireDate:[NSDate distantFuture]];
            if (self.dismissHandler) {
                self.dismissHandler(self);
            }
            return;
        }
    }
    else{
        //如果当前combo < finalcombo 就return
        if((self.finalCombo <= self.currentCombo)){
            
            return;
        }
        else{
            
            //否则 combo+1
            self.currentCombo += 1;
            [UIView animateWithDuration:0.1 animations:^{
                
                self.comboLB.transform = CGAffineTransformMakeScale(2, 2);
                self.comboLB.text = [NSString stringWithFormat:@"x%d",self.currentCombo];
                
            }completion:^(BOOL finished) {
                
                [UIView animateWithDuration:0.1 animations:^{
                    
                    self.comboLB.transform = CGAffineTransformMakeScale(1, 1);
                    
                }];
            }];
        }
    }
}

- (void)prepareForRuse{

    _finalCombo = 0;
    _currentCombo = 0;
}

- (void)dealloc{

    [mytimer invalidate];
    mytimer = nil;
}

@end
