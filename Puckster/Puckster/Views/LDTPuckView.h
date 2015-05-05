//
//  LDTPuckView.h
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

@import UIKit;

/**
 The view that will represent a 'puck'. It will use it's delegate to relay information.
 */
@interface LDTPuckView : UIView

- (instancetype)initWithPoint:(CGPoint)point withBodyColor:(UIColor *)bodyColor withBorderColor:(UIColor *)borderColor;

@end
