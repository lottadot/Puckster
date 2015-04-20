//
//  LDTPuckControl.m
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import "LDTPuckControl.h"
#import "LDTPuckView.h"
@import UIKit;

typedef enum : NSUInteger {
    LDTPuckViewLocationTopLeft,
    LDTPuckViewLocationTopRight,
    LDTPuckViewLocationBottomLeft,
    LDTPuckViewLocationBottomRight
} LDTPuckViewLocation;

@interface LDTPuckControl ()

@property (nonatomic, strong) LDTPuckView *puckView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;

@property (nonatomic, assign) LDTPuckViewLocation puckLocation;
@end

@implementation LDTPuckControl

- (instancetype)initInWindow:(UIWindow *)window withLocation:(LDTPuckViewLocation)locaton
{
    NSParameterAssert(window);
    self = [super init];
    if (self) {
        
        [window addSubview:[self puckView]];
        
        [self.puckView addGestureRecognizer:_tapGestureRecognizer];
        [self.puckView addGestureRecognizer:_swipeGestureRecognizer];
    }
    return self;
}

- (LDTPuckView *)puckView
{
    if (nil == _puckView) {
        
        _puckView = [LDTPuckView new];
    }
    return _puckView;
}

- (UITapGestureRecognizer *)tapGestureReconizer
{
    if (nil == _tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(puckTapped:)];
    }
    return _tapGestureRecognizer;
}

- (UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    if (nil == _swipeGestureRecognizer) {
        _swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(puckSwiped:)];
    }
    return _swipeGestureRecognizer;
}

#pragma mark - Puck Placement

/**
 Determine the appropriate center point for the puck given the provided location.
 */
- (CGPoint)puckCenterForLocation:(LDTPuckViewLocation)location
{
    // TODO
    return CGPointZero;
}

#pragma mark - UIGestureRecognizer Events

- (IBAction)puckTapped:(id)sender
{
    // TODO
}

- (IBAction)puckSwiped:(id)sender
{
    // TODO
}


@end
