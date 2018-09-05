//
//  LDTPuckContentView.m
//  Puckster
//
//  Created by Shane Zatezalo on 4/25/15.
//  Copyright (c) 2015-2018 Lottadot LLC. All rights reserved.
//

#import "LDTPuckContentView.h"
#import "UIView+LDTPuckAutoLayoutUtil.h"

@interface LDTPuckContentView ()

/// A `UIView` to contain the content View.
@property (nonatomic, strong) IBOutlet UIView *contentContainerView;

/// The `UIView` to show within our Container view. Setting to Nil removes.
@property (nonatomic, strong) UIView *contentView;

@end

@implementation LDTPuckContentView

#pragma mark Lifecycle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        [self addContentContainerView];
        self.accessibilityLabel = NSLocalizedString(@"PuckContent", nil);
    }
    
    return self;
}

#pragma mark - UI Setup

/**
 Adds the contentContainerView as a subview and constraints its bounds to self.
 */
- (void)addContentContainerView
{
    // Add Content Container View
    [self addSubview:self.contentContainerView];
    [self ldt_pinView:self.contentContainerView toContainer:self];
}

#pragma mark - iVars

- (UIView *)contentContainerView
{
    if (nil == _contentContainerView) {
        _contentContainerView = [[UIView alloc] initWithFrame:CGRectZero];
        [_contentContainerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }

    return _contentContainerView;
}

#pragma mark - Public Methods

- (void)setContent:(UIView *)contentView
{
    if (nil == contentView) {
        if (nil != _contentView) {
            [_contentView removeFromSuperview];
            return;
        }
    } else {
        if (_contentView == contentView) {
            return;
        }
        
        [_contentView removeFromSuperview];
        _contentView = contentView;

        [self addSubview:_contentView];
        [self ldt_pinView:_contentView toContainer:self];
    }
}

@end
