//
//  LDTPuckViewDataSource.h
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

@import Foundation;

/**
 `LDTPuckViewDataSource` protocol sources for puck configuration (ie colors).
 */
@protocol LDTPuckViewDataSource <NSObject>

@optional

/// The `UIColor` the puck will be filled with.
- (UIColor *)puckColor;

/// The `UIColor` the puck will have a border with.
- (UIColor *)puckBorderColor;

@end
