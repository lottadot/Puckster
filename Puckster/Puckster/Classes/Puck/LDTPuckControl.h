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

@class LDTPuckControl;

/**
 `LDTPuckControlDelegate` protocol defining the interaction between the calling object for events, etc.
 */
@protocol LDTPuckControlDelegate <NSObject>

@optional

- (void)didDismissPuckControl:(LDTPuckControl *)puckControl;
- (void)didSelectPuckWithControl:(LDTPuckControl *)puckControl;
- (void)didPresentPuckControl:(LDTPuckControl *)puckControl;

@end

/**
 `LDTPuckControlDataSource` protocol sources for content.
 */
@protocol LDTPuckControlDataSource <NSObject>

- (UIView *)contentViewForPuckControl:(LDTPuckControl *)puckControl;

@end

@interface LDTPuckControl : NSObject

- (instancetype)initInWindow:(UIWindow *)window withLocation:(LDTPuckViewLocation)location
                withDelegate:(id <LDTPuckControlDelegate>)delegate
                  dataSource:(id <LDTPuckControlDataSource>)dataSource;

@end
