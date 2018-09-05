//
//  UIView+LDTPuckAutoLayoutUtil.m
//  Puckster
//
//  Created by Shane Zatezalo on 4/25/15.
//  Copyright (c) 2015-2018 Lottadot LLC. All rights reserved.
//

#import "UIView+LDTPuckAutoLayoutUtil.h"

@implementation UIView (LDTPuckAutoLayoutUtil)

- (void)ldt_pinView:(UIView *)view toContainer:(UIView *)container
{
    NSParameterAssert(view);
    NSParameterAssert(container);

    if (nil != view && nil != container) {
        NSDictionary *viewsDictionary = @{@"view" : view, @"container" : container};
        
        [view setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictionary]];
        
        [container addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:viewsDictionary]];
        
        [container layoutSubviews];
    }
}

- (void)ldt_centerView:(UIView *)view toContainer:(UIView *)container
{
    NSParameterAssert(view);
    NSParameterAssert(container);
    
    if (nil != view && nil != container) {
        // Center Vertically
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:container
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1.0
                                                                              constant:0.0];
        [container addConstraint:centerYConstraint];
        
        // Center Horizontally
        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:view
                                                                             attribute:NSLayoutAttributeCenterX
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:container
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1.0
                                                                              constant:0.0];
        [container addConstraint:centerXConstraint];
    }
}

@end
