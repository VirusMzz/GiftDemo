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


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        maximumStaySeconds = 5;
        self.currentCombo = 0;
        self.finalCombo = 0;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        

    }
    return self;
}

/*
 @property (weak, nonatomic) IBOutlet UILabel *SendLB;
 @property (weak, nonatomic) IBOutlet UIImageView *img;
 @property (weak, nonatomic) IBOutlet UILabel *comboLB;
 */
- (GiftEvent *)initialGiftEvent:(GiftEvent *)event{

    NSLog(@"%d", event.giftId);
    self.SendLB.text = @"Send a gift!";
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"gift-%d", event.giftId]];
                      
    self.img.image = image;
    
    NSLog(@"%@ %s",self.img.image, __func__);
    
    return event;
}

//comboLB set method
- (void)setComboLB:(UILabel *)comboLB{

    if (!_comboLB) {
        _comboLB.text = [NSString stringWithFormat:@"x%d",self.currentCombo];
    }
}

//开始循环combo动画
- (void)startAnimationCombo{

    if (!mytimer) {
        mytimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(tick:) userInfo:nil repeats:true];
        [[NSRunLoop currentRunLoop] addTimer:mytimer forMode:NSRunLoopCommonModes];
    }
}

//循环
- (void)tick:(NSTimer *)timer{

    //如果当前时间 和上次事件时间差 > maxstaySec -> 终止动画 -> dismiss 自己
    NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
    if (!((now - self.lastEventTime) < maximumStaySeconds)) {
        if (!timer) {
            [timer invalidate];
            timer = nil;
            self.needDismiss(self);
            return;
        }
    }
    //如果当前combo < finalcombo 就 ？？
    if((self.finalCombo > self.currentCombo)){
    
        return;
    }
    self.currentCombo += 1;
    
    [UIView animateWithDuration:0.1 animations:^{
        
        self.comboLB.transform = CGAffineTransformMakeScale(3, 3);
        
    }completion:^(BOOL finished) {
        
        [UIView animateWithDuration:0.1 animations:^{
            
            self.comboLB.transform = CGAffineTransformMakeScale(1, 1);
        }];
    }];
}

- (void)prepareForRuse{

    _finalCombo = 0;
    _currentCombo = 0;
}

@end
