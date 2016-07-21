//
//  ViewController.m
//  GiftDemo
//
//  Created by 孙砚戈 on 7/18/16.
//  Copyright © 2016 孙砚戈. All rights reserved.
//

#import "ViewController.h"
#import "GiftView.h"
#import "GiftEvent.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet GiftView *GiftAreaView;
@property (nonatomic, strong)GiftEvent *event;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendGift:(UIButton *)sender {
    
    NSLog(@"send a Gift");
    
    NSDictionary *dic = @{@"senderId":@"123", @"giftId":@"1", @"giftCount":@"1"};
    self.event = [[GiftEvent alloc]init];
    [self.event setValuesForKeysWithDictionary:dic];
    
    [self.GiftAreaView pushGiftEvent:self.event];
    
}

@end
