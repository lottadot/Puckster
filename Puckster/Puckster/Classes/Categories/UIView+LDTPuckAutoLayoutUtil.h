//
//  UIView+LDTPuckAutoLayoutUtil.h
//  Puckster
//
//  Created by Shane Zatezalo on 4/25/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

@import UIKit;

/**
 `LDTPuckAutoLayoutUtil` is a Category on `UIView` to container Auto Layout Helper methods.
 */
@interface UIView (LDTPuckAutoLayoutUtil)

/**
 Pin a View to a container view by the view's bounds.
 
 @note sets `setTranslatesAutoresizingMaskIntoConstraints` NO to the view, sends `container layoutSubviews`.
 */
- (void)LDTPinView:(UIView *)view toContainer:(UIView *)container;

@end
