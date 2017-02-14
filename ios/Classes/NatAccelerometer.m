//
//  NatAccelerometer.m
//
//  Created by huangyake on 17/1/7.
//  Copyright © 2017 Nat. All rights reserved.
//

#import "NatAccelerometer.h"
#import <CoreMotion/CoreMotion.h>
#import <UIKit/UIKit.h>

@interface NatAccelerometer ()
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (nonatomic, strong)NSDate *lastDate;
@property (nonatomic, assign)NSInteger interval;

@end

@implementation NatAccelerometer

#define kGravitationalConstant -9.81

+ (NatAccelerometer *)singletonManger{
    static id manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


- (void)get:(NatCallback)back{
    // 1. 判断是否支持加速计硬件
//    BOOL available = [self.motionManager isAccelerometerAvailable];
//    if (available == NO) {
//        NSLog(@"加速计不能用");
//        return;
//    }
    // 获取硬件数据的更新间隙
     self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.5;
    if (self.motionManager.isAccelerometerActive == NO) {
        
        // 开始更新硬件数据
        [self.motionManager startAccelerometerUpdates];
    }

    //  Push(按照accelerometerUpdateInterval定时推送回来)
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        
        // CMAcceleration 是表示加速计数据的结构体
        if (error) {
            back(@{@"error":@{@"code":@1,@"msg":@"ACCELEROMETER_INTERNAL_ERROR"}},nil);
        }else{
            CMAcceleration acceleration = accelerometerData.acceleration;
            [self.motionManager stopAccelerometerUpdates];
            back(nil,@{@"x":@(acceleration.x * kGravitationalConstant),@"y":@(acceleration.y * kGravitationalConstant),@"z":@(acceleration.z * kGravitationalConstant)});
        }
    }];
    
    // 结束获取硬件数据
    

   
    
}

- (void)watch:(NSDictionary *)options :(NatCallback)back{
        // 获取硬件数据的更新间隙
     self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.5;
    
    if (self.motionManager.isAccelerometerActive == NO) {
        
        // 开始更新硬件数据
        [self.motionManager startAccelerometerUpdates];
    }
    if (options) {
        if (options[@"interval"] && [options[@"interval"] isKindOfClass:[NSNumber class]] && [options[@"interval"] integerValue]) {
            self.interval  = [options[@"interval"] integerValue];
        }
    }
    //  Push(按照accelerometerUpdateInterval定时推送回来)
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        
        // CMAcceleration 是表示加速计数据的结构体
//        CMAcceleration acceleration = accelerometerData.acceleration;
//        NSLog(@"%f, %f, %f", acceleration.x, acceleration.y, acceleration.z);
        if (error) {
            back(@{@"error":@{@"code":@1,@"msg":@"ACCELEROMETER_INTERNAL_ERROR"}},nil);
        }else{
            
                if (self.interval && self.lastDate && [self.lastDate timeIntervalSince1970]*1000.0 + self.interval > [[NSDate date] timeIntervalSince1970] * 1000.0) {
                    
                }else{
                    self.lastDate = [NSDate date];
                    CMAcceleration acceleration = accelerometerData.acceleration;
                    NSLog(@"%f, %f, %f", acceleration.x, acceleration.y, acceleration.z);
                    back(nil,@{@"x":@(acceleration.x * kGravitationalConstant),@"y":@(acceleration.y * kGravitationalConstant),@"z":@(acceleration.z * kGravitationalConstant)});

                }
        }

    }];

}

- (void)clearWatch:(NatCallback)back{
    if (self.motionManager.isAccelerometerActive == YES) {
        
        // 结束更新硬件数据
        [self.motionManager stopAccelerometerUpdates];
    }

}
- (void)close{
    if (self.motionManager.isAccelerometerActive == YES) {
        
        // 结束更新硬件数据
        [self.motionManager stopAccelerometerUpdates];
    }
}
@end
