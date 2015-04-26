//
//  LDTPuckControl.m
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import "LDTPuckControl.h"
#import "LDTPuckView.h"
#import "LDTPuckViewDataSource.h"
#import "LDTPuckContentView.h"
#import "UIView+LDTPuckAutoLayoutUtil.h"

#define LDTPuckControlWidth 50.0f
#define LDTPuckControlHeight 50.0f

//#define LDTPuckControlDismissDebug 1

@interface LDTPuckControl () <LDTPuckViewDataSource>

/// The `LDTPuckView` the use will pan around and tap.
@property (nonatomic, strong) LDTPuckView *puckView;

@property (nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *rightHorizontalSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftHorizontalSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *upVerticalSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *downVerticalSwipeGestureRecognizer;

/// The current location of the Puck. So we know where it is onscreen, logically.
@property (nonatomic, assign) LDTPuckViewLocation puckLocation;

@property (nonatomic, assign) id <LDTPuckControlDelegate> delegate;
@property (nonatomic, assign) id <LDTPuckControlDataSource> dataSource;

/// The `LDTPuckContentView` that will be shown to the user.
@property (nonatomic, strong) LDTPuckContentView *contentView;

@property (nonatomic, strong) UIColor *puckColor;
@property (nonatomic, strong) UIColor *puckBorderColor;

@end

@implementation LDTPuckControl

- (instancetype)initInWindow:(UIWindow *)window withLocation:(LDTPuckViewLocation)location
                withDelegate:(id <LDTPuckControlDelegate>)delegate
                  dataSource:(id <LDTPuckControlDataSource>)dataSource
                   puckColor:(UIColor *)puckColor
             puckBorderColor:(UIColor *)puckBorderColor
{
    NSParameterAssert(window);
    NSParameterAssert(delegate);
    NSParameterAssert(dataSource);
    
    if (nil == window || nil == delegate || nil == dataSource) {
        [NSException raise:@"LDTPuckControl" format:@"Window, Delegate and DataSource must be provided."];
    }
    
    self = [super init];
    
    if (self) {
        
        _delegate = delegate;
        _dataSource = dataSource;
        
        _puckColor = puckColor;
        _puckBorderColor = puckBorderColor;
        
        _puckLocation = location;
        CGPoint center = CGPointMake(CGRectGetMaxY(window.frame), CGRectGetMaxY(window.frame));
        
        _puckView = [[LDTPuckView alloc] initWithPoint:center withDataSource:self];
        NSAssert(nil != _puckView, nil);
        
        [window addSubview:[self puckView]];
        [_puckView setAutoresizingMask:UIViewAutoresizingNone];

        [_puckView setCenter:[self puckCenterForLocation:_puckLocation]];
        [self.puckView addGestureRecognizer:[self upVerticalSwipeGestureRecognizer]];
        [self.puckView addGestureRecognizer:[self downVerticalSwipeGestureRecognizer]];
        [self.puckView addGestureRecognizer:[self leftHorizontalSwipeGestureRecognizer]];
        [self.puckView addGestureRecognizer:[self rightHorizontalSwipeGestureRecognizer]];

        [self.puckView addGestureRecognizer:[self singleTapGestureRecognizer]];
        [self.puckView addGestureRecognizer:[self doubleTapGestureRecognizer]];
        //[[self puckView] setNeedsLayout];
        
        [window bringSubviewToFront:_puckView];
    }
    
    return self;
}

#pragma mark - iVar's

- (LDTPuckView *)puckView
{
    if (nil == _puckView) {
        
        _puckView = [LDTPuckView new];
    }
    
    return _puckView;
}

- (LDTPuckContentView *)contentView
{
    if (nil == _contentView) {
        
        _contentView = [[LDTPuckContentView alloc] initWithFrame:CGRectZero];
        [_contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    
    return _contentView;
}

- (UITapGestureRecognizer *)singleTapGestureRecognizer
{
    if (nil == _singleTapGestureRecognizer) {
        _singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(puckSingleTapped:)];
        [_singleTapGestureRecognizer setNumberOfTapsRequired:1];
        [_singleTapGestureRecognizer requireGestureRecognizerToFail:[self doubleTapGestureRecognizer]];
    }
    
    return _singleTapGestureRecognizer;
}

- (UITapGestureRecognizer *)doubleTapGestureRecognizer
{
    if (nil == _doubleTapGestureRecognizer) {
        _doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                 initWithTarget:self
                                 action:@selector(puckDoubleTapped:)];
        [_doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    }
    
    return _doubleTapGestureRecognizer;
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
            CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            CGPoint point = CGPointMake(CGRectGetMinX(windowFrame) + XOffset,
                                        CGRectGetMinY(windowFrame) + YOffset + statusHeight);
            
            return point;
            
            break;
        }
        case LDTPuckViewLocationTopRight:
        {
            CGFloat statusHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
            CGPoint point = CGPointMake(CGRectGetMaxX(windowFrame) - XOffset,
                                        CGRectGetMinY(windowFrame) + YOffset + statusHeight);
            
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
    [self movePuckAnimated:YES];
}

- (void)movePuckAnimated:(BOOL)animated
{
    void (^animations)() = ^{
        self.puckView.center = [self puckCenterForLocation:_puckLocation];
    };
    
    if (animated) {
        [UIView animateWithDuration:0.5f delay:0.0f
             usingSpringWithDamping:0.6f
              initialSpringVelocity:0.5f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:animations
                         completion:nil];
    } else {
        animations();
    }
}

#pragma mark - UIGestureRecognizer Events

/**
 The Action when the user taps the puck a single time.
 */
- (IBAction)puckSingleTapped:(id)sender
{
    BOOL animated = YES;
    
    if (nil != self.dataSource
        && [self.dataSource conformsToProtocol:@protocol(LDTPuckControlDataSource)]
        && [self.dataSource respondsToSelector:@selector(shouldAnimatContentDisplayWithPuckControl:)]) {
        animated = [self.dataSource shouldAnimatContentDisplayWithPuckControl:self];
    }
    
    [self presentContentAnimated:animated];
}

- (IBAction)puckDoubleTapped:(id)sender
{
    BOOL animated = YES;
    
    if (nil != self.dataSource
        && [self.dataSource conformsToProtocol:@protocol(LDTPuckControlDataSource)]
        && [self.dataSource respondsToSelector:@selector(shouldAnimatPuckDismissalPuckControl:)]) {
        animated = [self.dataSource shouldAnimatPuckDismissalPuckControl:self];
    }
    
    [self dismissPuckAnimated:animated];
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

#pragma mark - Expansion Presenetation of Content View

/**
 Present the Content view to the user by animating it shrunk, in from the puck's corner, to enlarge it.
 */
- (void)presentContentAnimated:(BOOL)animated
{
    UIApplication *appDel = [UIApplication sharedApplication];
    UIWindow *window = [appDel windows][0];
    UIView *view = [window viewForBaselineLayout];
    __unused UIViewController *vc = [window rootViewController];
    
    CGFloat halfWidth = LDTPuckControlWidth / 2.0f;
    CGFloat halfHeight = LDTPuckControlHeight / 2.0f;
    CGFloat widthAdjustment = ([self isPuckAtRight]) ? halfWidth : -halfWidth;
    CGFloat heightAdjustmet = ([self isPuckAtBottom]) ? -halfHeight : halfHeight;
    
    CGFloat windowHeight = window.bounds.size.height;
    
    // Not really sure why anyone would ever use this and _not_ provide the contentView, may
    if (nil != self.dataSource) {
        if ([self.dataSource conformsToProtocol:@protocol(LDTPuckControlDataSource)]) {
            [self.contentView setContent:[self.dataSource contentViewForPuckControl:self]];
        } else {
            [self dataSourceDelegateInvalid];
        }
    } else {
        [self dataSourceDelegateInvalid];
    }

    // So the user cannot see it yet.
    [self.contentView setAlpha:0.0f];
    
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [view addSubview:self.contentView];
    [view LDTPinView:self.contentView toContainer:view];
    [view layoutSubviews];

    // Add gestures to the content view so the user can easily dismiss it.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(contentViewTapped:)];
    [self.contentView addGestureRecognizer:tap];
    self.contentView.layer.cornerRadius = 2;
    self.contentView.clipsToBounds = YES;
    
    if (!animated) {
        [self.contentView setAlpha:0.0f];
        self.puckView.alpha = 0.0f;
        return;
    }
    
    CGAffineTransform scaleTransform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                              0.05f,
                                                              0.05f);
    CGAffineTransform moveTransform  = CGAffineTransformTranslate(CGAffineTransformIdentity,
                                                                  ([self isPuckAtRight] ? window.bounds.size.width : -window.bounds.size.width) + widthAdjustment,
                                                                  ([self isPuckAtBottom] ? windowHeight : -windowHeight) - heightAdjustmet);
    CGAffineTransform comboTransform = CGAffineTransformConcat(scaleTransform, moveTransform);
    self.contentView.transform = comboTransform;

    NSTimeInterval duration = 0.5f;
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{

        self.contentView.transform = CGAffineTransformIdentity;
        self.contentView.alpha = 1.0f;
        self.contentView.layer.cornerRadius = 0.0f;
        self.puckView.alpha = 0.0f;
        
    } completion:^(BOOL finished) {
        
        if (finished) {

            [self.contentView.layer removeAllAnimations];
        }
    }];
}

/**
 Received by the Content View Tap Gesture Recognizer when the user taps anywhere on the content view.
 */
- (void)contentViewTapped:(id)sender
{
    [self dismissContentViewAnimated:YES];
}

#pragma mark - Dismissal Removal of Content View

/**
 Removes the Content View from the screen.
 */
- (void)dismissContentViewAnimated:(BOOL)animated
{
    if (!animated) {
        [self.contentView removeFromSuperview];
        self.contentView = nil;
        self.puckView.alpha = 1.0f;
        return;
    }
    UIApplication *appDel = [UIApplication sharedApplication];
    UIWindow *window = [appDel windows][0];
    
    CGFloat halfWidth = LDTPuckControlWidth / 2.0f;
    CGFloat halfHeight = LDTPuckControlHeight / 2.0f;
    CGFloat widthAdjustment = ([self isPuckAtLeft]) ? halfWidth : -halfWidth;
    CGFloat heightAdjustmet = ([self isPuckAtTop]) ? -halfHeight : halfHeight;
    
    CGAffineTransform scaleTransform = CGAffineTransformScale(CGAffineTransformIdentity,
                                                              0.05f,
                                                              0.05f);
    CGAffineTransform moveTransform  = CGAffineTransformTranslate(CGAffineTransformIdentity,
                                                                  ([self isPuckAtLeft] ? -window.bounds.size.width : window.bounds.size.width) + widthAdjustment,
                                                                  ([self isPuckAtTop] ? -window.bounds.size.height : window.bounds.size.height) - heightAdjustmet);
    CGAffineTransform comboTransform = CGAffineTransformConcat(scaleTransform, moveTransform);
    self.contentView.transform = CGAffineTransformIdentity;

    NSTimeInterval duration = 0.25f;
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.contentView.transform = comboTransform;
        self.contentView.alpha = 0.0f;
        self.contentView.layer.cornerRadius = 0.5f;
        self.puckView.alpha = 1.0f;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            [self.contentView.layer removeAllAnimations];
            [self.contentView removeFromSuperview];
            self.contentView = nil;
        }
    }];
}

- (void)dismissPuckAnimated:(BOOL)animated
{
    NSTimeInterval duration = 1.0f;
    
    /*
     Shift the puck in while enlarging, then flex it, then shrink it the corner
     */
    CGFloat movementFactor = 100.0f;

    CGFloat xTranslation = 0.0f;
    CGFloat yTranslation = 0.0f;
    
    CGFloat xAnimationInset = 0.0f;
    CGFloat yAnimationInset1 = 0.0f;
    CGFloat yAnimationInset2 = 0.0f;
    
    switch (_puckLocation) {
        case LDTPuckViewLocationTopLeft:
        {
            xTranslation = movementFactor;
            yTranslation = movementFactor;
            xAnimationInset = 80.0f;
            yAnimationInset1 = 25.0f;
            yAnimationInset2 = 50.0f;
            
            break;
        }
        case LDTPuckViewLocationTopRight:
        {
            xTranslation = -movementFactor;
            yTranslation = movementFactor;
            xAnimationInset = 80.0f;
            yAnimationInset1 = 25.0f;
            yAnimationInset2 = 50.0f;
            
            break;
        }
        case LDTPuckViewLocationBottomLeft:
        {
            xTranslation = movementFactor;
            yTranslation = -movementFactor;
            xAnimationInset = 80.0f;
            yAnimationInset1 = -25.0f;
            yAnimationInset2 = -50.0f;
            
            break;
        }
        default:
        {
            xTranslation = -movementFactor;
            yTranslation = -movementFactor;
            xAnimationInset = -80.0f;
            yAnimationInset1 = -25.0f;
            yAnimationInset2 = -50.0f;
            
            break;
        }
    }

    CGPoint startPoint = self.puckView.center;
    
    // Create a bezier path with a curve, we'll change it to a CGPath at the end
    CGPoint endPoint = CGPointMake(startPoint.x + xTranslation, startPoint.y + yTranslation);
    CGPoint firstCurvePoint = CGPointMake(startPoint.x + xAnimationInset, startPoint.y + yAnimationInset1);
    CGPoint secondCurvePoint = CGPointMake(startPoint.x + xAnimationInset, startPoint.y + yAnimationInset2);

    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:startPoint];
    [bezierPath addCurveToPoint:endPoint controlPoint1:firstCurvePoint controlPoint2:secondCurvePoint];

    // Then create a path out of the Bezier Path.
    CGPathRef curvedPath = bezierPath.CGPath;
    
    void (^animations)() = ^{};
    
    animations = ^{
        
        // Move it out
        CAKeyframeAnimation *curvedPathAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        curvedPathAnimation.path = curvedPath;
        curvedPathAnimation.duration = duration / 5.0f;
        [curvedPathAnimation setCalculationMode:kCAAnimationPaced];
        [curvedPathAnimation setFillMode:kCAFillModeForwards];
        curvedPathAnimation.removedOnCompletion = NO;
        curvedPathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        [self.puckView.layer addAnimation:curvedPathAnimation forKey:@"positionAnimationToLargeState"];
        
        // If you want to move via a translation instead
//        [UIView addKeyframeWithRelativeStartTime:0.0f relativeDuration:0.2f animations:^{
//            self.puckView.transform = CGAffineTransformMakeTranslation(xTranslation, yTranslation);
//        }];
//        

        // Enlarge
        [UIView addKeyframeWithRelativeStartTime:0.2f relativeDuration:0.2f animations:^{
            self.puckView.transform = CGAffineTransformScale(self.puckView.transform, 1.5, 1.5);
        }];
        
        // Quickly Shrink
        [UIView addKeyframeWithRelativeStartTime:0.4f relativeDuration:0.1f animations:^{
            
            self.puckView.transform = CGAffineTransformScale(self.puckView.transform, 0.9, 0.9);
        }];
        // Quickly enlarge
        [UIView addKeyframeWithRelativeStartTime:0.5f relativeDuration:0.2f animations:^{
            
            self.puckView.transform = CGAffineTransformScale(self.puckView.transform, 1.4, 1.4);
        }];
        
        /// Move it off the screen
        [UIView addKeyframeWithRelativeStartTime:0.8f relativeDuration:0.1 animations:^{
            
            CGAffineTransform transformMove  = CGAffineTransformMakeTranslation(xTranslation * -3, yTranslation * -3);
            CGAffineTransform transformScale = CGAffineTransformMakeScale(0.0f, 0.0f);
            
            CGAffineTransform combo = CGAffineTransformConcat(transformScale, transformMove);
            self.puckView.transform = combo;
        }];
    };
    
    [UIView animateKeyframesWithDuration:duration delay:0 options:0 animations:animations
                              completion:^(BOOL finished) {
                                  if (finished) {
#ifdef LDTPuckControlDismissDebug
                                      [self.puckView.layer removeAllAnimations];
                                      self.puckView.center = startPoint;
                                      self.puckView.transform = CGAffineTransformIdentity;
                                      self.puckView.alpha = 1.0f;
#endif
                                  }
                              }];
}

#pragma mark - Animation And Location Helpers

- (BOOL)isPuckAtTop
{
    return (self.puckLocation == LDTPuckViewLocationTopLeft || self.puckLocation == LDTPuckViewLocationTopRight);
}

- (BOOL)isPuckAtBottom
{
    return (self.puckLocation == LDTPuckViewLocationBottomLeft || self.puckLocation == LDTPuckViewLocationBottomRight);
}

- (BOOL)isPuckAtRight
{
    return (self.puckLocation == LDTPuckViewLocationBottomRight || self.puckLocation == LDTPuckViewLocationTopRight);
}

- (BOOL)isPuckAtLeft
{
    return (self.puckLocation == LDTPuckViewLocationBottomLeft || self.puckLocation == LDTPuckViewLocationTopLeft);
}

#pragma mark - Delegate Util

- (void)dataSourceDelegateInvalid
{
    [NSException raise:@"LDTPuckControlDataSource" format:@"Delegate must provide all required methods!"];
}

#pragma mark - LDTPuckViewDataSource

- (UIColor *)puckColor
{
    if (nil != self.dataSource
        && [self.dataSource conformsToProtocol:@protocol(LDTPuckControlDataSource)]
        && [self.dataSource respondsToSelector:@selector(puckColor)]) {
        return [self.dataSource puckColor];
    } else {
        return _puckColor;
    }
}

- (UIColor *)puckBorderColor
{
    if (nil != self.dataSource
        && [self.dataSource conformsToProtocol:@protocol(LDTPuckControlDataSource)]
        && [self.dataSource respondsToSelector:@selector(puckBorderColor)]) {
        return [self.dataSource puckBorderColor];
    } else {
        return _puckBorderColor;
    }
}

@end
