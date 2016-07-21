//
//  GiftView.m
//  GiftDemo
//
//  Created by 孙砚戈 on 7/20/16.
//  Copyright © 2016 孙砚戈. All rights reserved.
//

#import "GiftView.h"
#import "GiftDisplayView.h"
#import "GiftEvent.h"
#import <CoreGraphics/CoreGraphics.h>

@interface GiftView ()

//等待中的事件Queue
@property (nonatomic, strong)NSMutableArray *eventQueue;
//位置标示
@property (nonatomic, strong)NSMutableArray *availablePositions;
//用于复用的Views
@property (nonatomic, strong)NSMutableArray *reusableViews;
//当前在屏幕上显示的Views
@property (nonatomic, strong)NSMutableArray *currentViews;

@end

@implementation GiftView

#pragma mark -- Event Reference
/**
 *  push event
 *
 *  @param event 接收到的礼物事件模型
 */
- (void)pushGiftEvent:(GiftEvent *)myevent{

    NSMutableArray *tempCombo = [NSMutableArray array];
    
    if (self.eventQueue.count > 0) {
        
        for (GiftEvent *event  in self.eventQueue) {
            
            BOOL shoulCombo = [myevent shouldComboWith:event];
            if (shoulCombo) {
                [tempCombo addObject:event];
            }
        }
        GiftEvent *queueEvent = tempCombo.firstObject;
        if (queueEvent) {
            queueEvent.giftCount += myevent.giftCount;
        }

    }
    else{
    
        [self.eventQueue insertObject:myevent atIndex:0];
    }
    
    [self handleNextEvent];
}

/**
 *  NexEvent
 */
- (void)handleNextEvent{

    //查看是否有在队列中等待处理的Event
    GiftEvent *event = (GiftEvent *)[self popLastViewWithArray:self.eventQueue];
    NSLog(@"%@ %s",event, __func__);
    if (!event) {
        //没有在等待中的就返回
        return;
    }
    //如果有等待，与当前屏幕显示view进行比对是否需要combo
    else{
    
        if (self.currentViews.firstObject) {
            
            NSMutableArray *tempCurArr = [NSMutableArray array];
            for (GiftDisplayView *view in self.currentViews) {
                if ([[view initialGiftEvent:event] shouldComboWith:event]) {
                    [tempCurArr addObject:view];
                }
            }
            
            GiftDisplayView *disView = tempCurArr.firstObject;
            disView.finalCombo += event.giftCount;
            disView.lastEventTime = [[NSDate date] timeIntervalSince1970];
            return;
        }
        
        if (self.availablePositions.count == 0) {
            [self.eventQueue addObject:event];
            return;
        }
        
        NSNumber *position = self.availablePositions.lastObject;
        [self.availablePositions removeLastObject];
        
        GiftDisplayView *displayView = [self dequeueResuableView];
        [self.currentViews addObject:displayView];
        [displayView initialGiftEvent:event];
        displayView.lastEventTime = [[NSDate date] timeIntervalSince1970];
        displayView.currentCombo = 1;
        displayView.finalCombo = event.giftCount;
        
        CGRect frame = displayView.frame;
        frame.origin.y = displayView.frame.size.height * (CGFloat)[position floatValue];
        displayView.frame = frame;
        displayView.tag = [position intValue];
        
        
        __block CGAffineTransform transform = displayView.transform;
        transform.tx = -200;
        displayView.transform = transform;
        
        [self.superview addSubview:displayView];
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
            
            transform.tx = 0;
            displayView.transform = transform;
            
        } completion:^(BOOL finished) {
            
            [displayView startAnimationCombo];
            [self handleNextEvent];
            
        }];
        
    }

}

/**
 *  dismiss self
 */
- (void)dismissView:(GiftDisplayView *)view{

    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:0 options:0 animations:^{
        
        CGAffineTransform transform = view.transform;
        transform.ty = -20;
        view.transform = transform;
        view.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        [view removeFromSuperview];
        view.alpha = 1;
        CGAffineTransform transform = view.transform;
        transform.ty = 0;
        view.transform = transform;
        //过滤掉dismiss的View
        self.currentViews = [self filterCurrentViews:self.currentViews andView:view];
        //恢复位置标记
        NSString *tagNum = [NSString stringWithFormat:@"%ld",(long)view.tag];
        [self.availablePositions addObject:tagNum];
        [view prepareForRuse];
        [self enqueueResuableView:view];
        [self handleNextEvent];
    
    }];
}

/**
 *  复用同类型的GiftDisplayView
 */
- (GiftDisplayView *)dequeueResuableView{

    GiftDisplayView *view = (GiftDisplayView *)[self popLastViewWithArray:self.reusableViews];
    NSLog(@"%@ %s",view, __func__);
    if (view) {
        return view;
    }
    else{
    
        GiftDisplayView *tempView = [[GiftDisplayView alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
        
        __weak typeof(self) weakSelf = self;
        view.needDismiss = ^(GiftDisplayView *view){
        
            [weakSelf dismissView:view];
        };
        
        return tempView;
    }
    
}

/**
 *  在第一次执行消失后，将DisplayView 添加到复用数组中
 */
- (void)enqueueResuableView:(GiftDisplayView *)view{

    [self.reusableViews addObject:view];
}

#pragma mark -- Tools
/**
 *  过滤当前显示的View
 *
 *  @param curArr 当前view的数组
 *  @param view   即将dismiss的view
 *
 *  @return 过滤后的GiftView数组
 */
- (NSMutableArray *)filterCurrentViews:(NSMutableArray *)curArr andView:(GiftDisplayView *)view{

    NSMutableArray *tempArr = [NSMutableArray array];
    for (GiftDisplayView *GView in curArr) {
        if (GView != view) {
            
            [tempArr addObject:GView];
        }
    }
    
    return tempArr;
}

/**
 *  pop last obj
 */
- (id)popLastViewWithArray:(NSMutableArray *)arr{
    
    if (arr.count > 0) {
        
        id object = arr.lastObject;
        [arr removeLastObject];
        NSLog(@"%@",object);
        return object;
    }
    else{
        
        return nil;
    }
    
}

#pragma mark -- Lazyload
- (NSMutableArray *)eventQueue{
    
    if (!_eventQueue) {
        _eventQueue = [NSMutableArray array];
    }
    return _eventQueue;
}

- (NSMutableArray *)availablePositions{
    
    if (!_availablePositions) {
        _availablePositions = [NSMutableArray arrayWithObjects:@1, @2, nil];
    }
    return _availablePositions;
}

- (NSMutableArray *)reusableViews{
    
    if (!_reusableViews) {
        _reusableViews = [NSMutableArray array];
    }
    return _reusableViews;
}

- (NSMutableArray *)currentViews{
    
    if (!_currentViews) {
        _currentViews = [NSMutableArray array];
    }
    return _currentViews;
}


@end
