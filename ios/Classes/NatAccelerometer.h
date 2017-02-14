//
//  NatAccelerometer.h
//
//  Created by huangyake on 17/1/7.
//  Copyright © 2017 Nat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NatAccelerometer : NSObject

typedef void (^NatCallback)(id error,id result);
+ (NatAccelerometer *)singletonManger;
- (void)get:(NatCallback)back;
- (void)watch:(NSDictionary *)options :(NatCallback)back;
- (void)clearWatch:(NatCallback)back;
- (void)close;


@end
