//
//  GiftEvent.m
//  GiftDemo
//
//  Created by 孙砚戈 on 7/20/16.
//  Copyright © 2016 孙砚戈. All rights reserved.
//

#import "GiftEvent.h"

@implementation GiftEvent

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{

    
}

- (BOOL)shouldComboWith:(GiftEvent *)event{

    return (_senderId == event.senderId) && (_giftId == event.giftId);
}



@end
