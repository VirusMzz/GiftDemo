//
//  GiftView.h
//  GiftDemo
//
//  Created by 孙砚戈 on 7/20/16.
//  Copyright © 2016 孙砚戈. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GiftEvent;

@interface GiftView : UIView

- (void)pushGiftEvent:(GiftEvent *)event;

@end
