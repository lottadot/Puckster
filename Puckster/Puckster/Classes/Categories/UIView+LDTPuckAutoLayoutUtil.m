//
//  UIView+LDTPuckAutoLayoutUtil.m
//  Puckster
//
//  Created by Shane Zatezalo on 4/25/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import "UIView+LDTPuckAutoLayoutUtil.h"

@implementation UIView (LDTPuckAutoLayoutUtil)

- (void)LDTPinView:(UIView *)view toContainer:(UIView *)container
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

@end
