//
//  GiftDisplayView.h
//  GiftDemo
//
//  Created by 孙砚戈 on 7/20/16.
//  Copyright © 2016 孙砚戈. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiftDisplayView;

typedef void(^dismissHandler)(GiftDisplayView *view);

@class GiftEvent;

@interface GiftDisplayView : UIView
@property (strong, nonatomic) IBOutlet UIView *selfView;

@property (weak, nonatomic) IBOutlet UILabel *SendLB;
@property (weak, nonatomic) IBOutlet UIImageView *img;
@property (weak, nonatomic) IBOutlet UILabel *comboLB;

@property (nonatomic, assign)int currentCombo;
@property (nonatomic, assign)int finalCombo;
@property (nonatomic, assign)NSTimeInterval lastEventTime;

@property (nonatomic, strong)GiftEvent *event;
//结束回调消失
@property (nonatomic, copy)dismissHandler dismissHandler;


- (void)prepareForRuse;
- (void)startAnimationCombo;
- (void)initialGiftEvent:(GiftEvent *)event;
- (void)addDismissHandler:(dismissHandler)handler;

@end
