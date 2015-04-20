//
//  LDTPuckControl.m
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import "LDTPuckControl.h"
#import "LDTPuckView.h"
#import "LDTPuckViewDelegate.h"

#define LDTPuckControlWidth 50.0f
#define LDTPuckControlHeight 50.0f

@interface LDTPuckControl () <LDTPuckViewDelegate>

@property (nonatomic, strong) LDTPuckView *puckView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightHorizontalSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftHorizontalSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *upVerticalSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *downVerticalSwipeGestureRecognizer;

@property (nonatomic, assign) LDTPuckViewLocation puckLocation;
@end

@implementation LDTPuckControl

- (instancetype)initInWindow:(UIWindow *)window withLocation:(LDTPuckViewLocation)location
{
    NSParameterAssert(window);
    self = [super init];
    if (self) {
        
        _puckLocation = location;
        
        CGRect frame = CGRectMake(0.0f, 0.0f, 50.0f, 50.0f);
        _puckView = [[LDTPuckView alloc] initWithFrame:frame withDelegate:self];

        [window addSubview:[self puckView]];
        [_puckView setAutoresizingMask:UIViewAutoresizingNone];
        [_puckView setCenter:[self puckCenterForLocation:_puckLocation]];
        [_puckView setBackgroundColor:[UIColor blueColor]];
        
        [self.puckView addGestureRecognizer:[self upVerticalSwipeGestureRecognizer]];
        [self.puckView addGestureRecognizer:[self downVerticalSwipeGestureRecognizer]];
        [self.puckView addGestureRecognizer:[self leftHorizontalSwipeGestureRecognizer]];
        [self.puckView addGestureRecognizer:[self rightHorizontalSwipeGestureRecognizer]];

        //[[self puckView] setNeedsLayout];
        
        [window bringSubviewToFront:_puckView];
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

- (UITapGestureRecognizer *)tapGestureRecognizer
{
    if (nil == _tapGestureRecognizer) {
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(puckTapped:)];
    }
    return _tapGestureRecognizer;
}

- (UISwipeGestureRecognizer *)leftHorizontalSwipeGestureRecognizer
{
    if (nil == _leftHorizontalSwipeGestureRecognizer) {
        _leftHorizontalSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(puckSwipedHorizontallyLeft:)];
        [_leftHorizontalSwipeGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        
    }
    return _leftHorizontalSwipeGestureRecognizer;
}

- (UISwipeGestureRecognizer *)rightHorizontalSwipeGestureRecognizer
{
    if (nil == _rightHorizontalSwipeGestureRecognizer) {
        _rightHorizontalSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(puckSwipedHorizontallyRight:)];
        [_rightHorizontalSwipeGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionRight)];
        
    }
    return _rightHorizontalSwipeGestureRecognizer;
}

- (UISwipeGestureRecognizer *)upVerticalSwipeGestureRecognizer
{
    if (nil == _upVerticalSwipeGestureRecognizer) {
        _upVerticalSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                             initWithTarget:self
                                             action:@selector(puckSwipedVerticallyUp:)];
        [_upVerticalSwipeGestureRecognizer setDirection:( UISwipeGestureRecognizerDirectionUp)];
        
    }
    return _upVerticalSwipeGestureRecognizer;
}

- (UISwipeGestureRecognizer *)downVerticalSwipeGestureRecognizer
{
    if (nil == _downVerticalSwipeGestureRecognizer) {
        _downVerticalSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(puckSwipedVerticallyDown:)];
        [_downVerticalSwipeGestureRecognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        
    }
    return _downVerticalSwipeGestureRecognizer;
}


#pragma mark - Puck Placement

/**
 Determine the appropriate center point for the puck given the provided location.
 */
- (CGPoint)puckCenterForLocation:(LDTPuckViewLocation)location
{
    CGRect windowFrame = [_puckView.window bounds];
    CGFloat XOffset = LDTPuckControlWidth / 2.0f;
    CGFloat YOffset = LDTPuckControlHeight / 2.0f;

    switch (location) {
        case LDTPuckViewLocationTopLeft:
        {
            CGPoint point = CGPointMake(CGRectGetMinX(windowFrame) + XOffset,
                                        CGRectGetMinY(windowFrame) + YOffset);
            return point;
            break;
        }
        case LDTPuckViewLocationTopRight:
        {
            CGPoint point = CGPointMake(CGRectGetMaxX(windowFrame) - XOffset,
                                        CGRectGetMinY(windowFrame) + YOffset);
            return point;
            break;
        }
        case LDTPuckViewLocationBottomLeft:
        {
            CGPoint point = CGPointMake(CGRectGetMinX(windowFrame) + XOffset,
                                        CGRectGetMaxY(windowFrame) - YOffset);
            return point;
            break;
        }
        default:
        {
            // LDTPuckViewLocationBottomRight
            CGPoint point = CGPointMake(CGRectGetMaxX(windowFrame) - XOffset,
                                              CGRectGetMaxY(windowFrame) - YOffset);
            return point;
            break;
        }
    }
}

#pragma mark - Movement

- (void)movePuckToCurrentLocation
{
    self.puckView.center = [self puckCenterForLocation:_puckLocation];
}

#pragma mark - UIGestureRecognizer Events

- (IBAction)puckTapped:(id)sender
{
    UITapGestureRecognizer *recognizer = (UITapGestureRecognizer *)sender;
    // TODO
}

- (IBAction)puckSwipedHorizontallyLeft:(id)sender
{
    //UISwipeGestureRecognizer *recognizer = (UISwipeGestureRecognizer *)sender;
    switch (_puckLocation) {
        case LDTPuckViewLocationTopRight:
        {
            _puckLocation = LDTPuckViewLocationTopLeft;
            [self movePuckToCurrentLocation];
            break;
        }
            
        default:
        {
            _puckLocation = LDTPuckViewLocationBottomLeft;
            [self movePuckToCurrentLocation];
            break;
        }
    }
}

- (IBAction)puckSwipedHorizontallyRight:(id)sender
{
    switch (_puckLocation) {
        case LDTPuckViewLocationTopLeft:
        {
            _puckLocation = LDTPuckViewLocationTopRight;
            [self movePuckToCurrentLocation];
            break;
        }
            
        default:
        {
            _puckLocation = LDTPuckViewLocationBottomRight;
            [self movePuckToCurrentLocation];
            break;
        }
    }
}


- (IBAction)puckSwipedVerticallyUp:(id)sender
{
    switch (_puckLocation) {
        case LDTPuckViewLocationBottomLeft:
        {
            _puckLocation = LDTPuckViewLocationTopLeft;
            [self movePuckToCurrentLocation];
            break;
        }
            
        default:
        {
            _puckLocation = LDTPuckViewLocationTopRight;
            [self movePuckToCurrentLocation];
            break;
        }
    }
}

- (IBAction)puckSwipedVerticallyDown:(id)sender
{
    switch (_puckLocation) {
        case LDTPuckViewLocationTopLeft:
        {
            _puckLocation = LDTPuckViewLocationBottomLeft;
            [self movePuckToCurrentLocation];
            break;
        }
            
        default:
        {
            _puckLocation = LDTPuckViewLocationBottomRight;
            [self movePuckToCurrentLocation];
            break;
        }
    }
}

#pragma mark - LDTPuckViewDelegate


@end
