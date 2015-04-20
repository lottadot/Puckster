//
//  LDTPuckControl.h
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

@import Foundation;
@import UIKit;

@class LDTPuckView;

typedef enum : NSUInteger {
    LDTPuckViewLocationTopLeft,
    LDTPuckViewLocationTopRight,
    LDTPuckViewLocationBottomLeft,
    LDTPuckViewLocationBottomRight
} LDTPuckViewLocation;


@interface LDTPuckControl : NSObject

- (instancetype)initInWindow:(UIWindow *)window withLocation:(LDTPuckViewLocation)location;

@end
