//
//  GiftEvent.h
//  GiftDemo
//
//  Created by 孙砚戈 on 7/20/16.
//  Copyright © 2016 孙砚戈. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GiftEvent;
/*
 class GiftEvent: NSObject {
 
 var senderId: Int
 
 var giftId: Int
 
 var giftCount: Int
 
 init(dict: [String: AnyObject]) {
 senderId = dict["senderId"] as! Int
 giftId = dict["giftId"] as! Int
 giftCount = dict["giftCount"] as! Int
 }
 
 func shouldComboWith(event: GiftEvent) -> Bool {
 return senderId == event.senderId && giftId == event.giftId
 }
 
 }
*/

@interface GiftEvent : NSObject

@property (nonatomic, assign)int senderId;
@property (nonatomic, assign)int giftId;
@property (nonatomic, assign)int giftCount;

- (BOOL)shouldComboWith:(GiftEvent *)event;

@end
