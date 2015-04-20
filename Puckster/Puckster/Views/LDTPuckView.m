//
//  LDTPuckView.m
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import "LDTPuckView.h"
#import "LDTPuckViewDelegate.h"

@implementation LDTPuckView

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
    return CGSizeMake(50.0f, 50.0f);
}

@end
