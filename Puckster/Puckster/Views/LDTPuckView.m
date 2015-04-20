//
//  LDTPuckView.m
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import "LDTPuckView.h"
#import "LDTPuckViewDelegate.h"

#define LDTPuckViewDefaultWidth  50.0f
#define LDTPuckViewDefaultHeight 50.0f

@implementation LDTPuckView

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<LDTPuckViewDelegate>)delegate
{
    NSParameterAssert(delegate);
    self = [super initWithFrame:frame];
    if (self) {
        [self setBackgroundColor:[UIColor redColor]];
        _delegate = delegate;
    }
    return self;
}

- (instancetype)initWithDelegate:(id<LDTPuckViewDelegate>)delegate
{
    NSParameterAssert(delegate);
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor redColor]];
        _delegate = delegate;
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(LDTPuckViewDefaultWidth, LDTPuckViewDefaultHeight);
}

@end
