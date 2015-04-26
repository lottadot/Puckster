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

/// Provide the puck control content to display when the user taps the puck.
- (UIView *)contentViewForPuckControl:(LDTPuckControl *)puckControl;

@optional

/// Tell the puck control the puck's body color.
- (UIColor *)puckColor;

/// Tell the puck control the puck's border color.
- (UIColor *)puckBorderColor;

/// Tell the puck control whether it should animate display of content.
- (BOOL)shouldAnimatContentDisplayWithPuckControl:(LDTPuckControl *)puckControl;

/// Tell the puck control whether it should animate the dismissal of the puck.
- (BOOL)shouldAnimatPuckDismissalPuckControl:(LDTPuckControl *)puckControl;

@end

@interface LDTPuckControl : NSObject

/**
 Creates a puck Contol in the provided window at the specified location.
 @param location an `LDTPuckViewLocation` intended to indicate the initial location of the puck. Required.
 @param delegate an object which conforms to the `LDTPuckControlDelegate` protocol to relay events and information to the puck control owner. Required.
 @param dataSource an object which conforms to the `LDTPuckControlDataSource` protocol which provides information (such as puck color) to the puck Control. Required.
 @param puckColor the `UIColor` of the body of the puck. Optional.
 @param puckBorderColor the `UIColor` of the border around the puck. Optional.
 */
- (instancetype)initInWindow:(UIWindow *)window withLocation:(LDTPuckViewLocation)location
                withDelegate:(id <LDTPuckControlDelegate>)delegate
                  dataSource:(id <LDTPuckControlDataSource>)dataSource
                   puckColor:(UIColor *)puckColor
             puckBorderColor:(UIColor *)puckBorderColor;

/**
 Dismiss the puck from the screen.
 @param animated `BOOL` whether to animate the removal or not.
 */
- (void)dismissPuckAnimated:(BOOL)animated;

@end
