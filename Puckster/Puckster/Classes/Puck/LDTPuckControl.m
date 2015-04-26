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
#import "LDTPuckContentView.h"
#import "UIView+LDTPuckAutoLayoutUtil.h"

#define LDTPuckControlWidth 50.0f
#define LDTPuckControlHeight 50.0f

@interface LDTPuckControl () <LDTPuckViewDelegate>

@property (nonatomic, strong) LDTPuckView *puckView;
@property (nonatomic, strong) UITapGestureRecognizer *singleTapGestureRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTapGestureRecognizer;

@property (nonatomic, strong) UISwipeGestureRecognizer *rightHorizontalSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *leftHorizontalSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *upVerticalSwipeGestureRecognizer;
@property (nonatomic, strong) UISwipeGestureRecognizer *downVerticalSwipeGestureRecognizer;

@property (nonatomic, assign) LDTPuckViewLocation puckLocation;

@property (nonatomic, assign) id <LDTPuckControlDelegate> delegate;
@property (nonatomic, assign) id <LDTPuckControlDataSource> dataSource;

@property (nonatomic, strong) LDTPuckContentView *contentView;
@end

@implementation LDTPuckControl

- (instancetype)initInWindow:(UIWindow *)window withLocation:(LDTPuckViewLocation)location
                withDelegate:(id <LDTPuckControlDelegate>)delegate
                  dataSource:(id <LDTPuckControlDataSource>)dataSource
{
    NSParameterAssert(window);
    NSParameterAssert(delegate);
    NSParameterAssert(dataSource);
    
    self = [super init];
    if (self) {
        
        _delegate = delegate;
        _dataSource = dataSource;
        
        _puckLocation = location;
        CGPoint center = CGPointMake(CGRectGetMaxY(window.frame),CGRectGetMaxY(window.frame));
        
        _puckView = [[LDTPuckView alloc] initWithPoint:center withDelegate:self];
        NSAssert(nil != _puckView, nil);
        
        [window addSubview:[self puckView]];
        [_puckView setAutoresizingMask:UIViewAutoresizingNone];
        //[_puckView setBackgroundColor:[UIColor blueColor]];
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
    [self presentContentAnimated:YES];
}

- (IBAction)puckDoubleTapped:(id)sender
{
    [self dismissAnimated:YES];
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

#pragma mark - Expansion

- (void)presentContentAnimated:(BOOL)animated
{
    // What window will we show?
    // Where does it get it's content from?
    
    UIApplication *appDel = [UIApplication sharedApplication];
    UIWindow *window = [appDel windows][0];
    __unused UIView *view = [window viewForBaselineLayout]; //superview]; // Should be a better way to do this
    __unused UIViewController *vc = [window rootViewController];
//    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Not Implemented", nil)
//                                                                   message:NSLocalizedString(@"Need another NSCoder", nil) preferredStyle:UIAlertControllerStyleAlert];
//    [alert addAction:[UIAlertAction actionWithTitle:NSLocalizedString(@"Ok", nil) style:UIAlertActionStyleDefault handler:nil]];
//    [vc presentViewController:alert animated:YES completion:nil];
    
    if (nil != self.dataSource) {
        if ([self.dataSource conformsToProtocol:@protocol(LDTPuckControlDataSource)]) {
            [self.contentView setContent:[self.dataSource contentViewForPuckControl:self]];
        }
    }

    [self.contentView setBackgroundColor:[UIColor redColor]];
    [view addSubview:self.contentView];
    [view LDTPinView:self.contentView toContainer:view];
    
    // Add gestures to the content view so the user can easily dismiss it.
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissContentViewAnimated:)];
    [self.contentView addGestureRecognizer:tap];
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]
                                       initWithTarget:self
                                       action:@selector(dismissContentViewAnimated:)];
    [self.contentView addGestureRecognizer:swipe];
}

#pragma mark - Dismissal

- (void)dismissContentViewAnimated:(BOOL)animated
{
    // TODO
    [self.contentView removeFromSuperview];
}

- (void)dismissAnimated:(BOOL)animated
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
                                  [self.puckView.layer removeAllAnimations];
                                  self.puckView.center = startPoint;
                                  self.puckView.transform = CGAffineTransformIdentity;
                                  self.puckView.alpha = 1.0f;
                              }];
}

#pragma mark - LDTPuckViewDelegate


@end
