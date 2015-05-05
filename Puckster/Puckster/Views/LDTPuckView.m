//
//  LDTPuckView.m
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import "LDTPuckView.h"

static const CGFloat LDTPuckViewDefaultWidth  = 50.0;
static const CGFloat LDTPuckViewDefaultHeight = 50.0;
static const CGFloat LDTPuckViewStrokeWidth   = 3.0f;

static const CGFloat LDTPuckViewDeselectedRadius = 22.0f; // Go with Radius or width/height? TODO

#define LDTPuckViewSelectedStrokeLightColor [UIColor whiteColor]
#define LDTPuckViewSelectedStrokeDarkColor  [UIColor colorWithWhite:0.27f alpha:1.0f]
#define LDTPuckViewDeselectedStrokeColor    [UIColor colorWithWhite:0.0f alpha:0.49f]

@interface LDTPuckView ()

/// Shape layer for the stroke.
@property (nonatomic, weak) CAShapeLayer *strokeLayer;

/// Shape layer for the fill.
@property (nonatomic, weak) CAShapeLayer *fillLayer;

@end

@implementation LDTPuckView

#pragma mark Lifecycle

- (instancetype)initWithPoint:(CGPoint)point withBodyColor:(UIColor *)bodyColor
              withBorderColor:(UIColor *)borderColor
{
    CGRect frame = CGRectMake(point.x - LDTPuckViewDefaultWidth,
                              point.y - LDTPuckViewDefaultHeight,
                              LDTPuckViewDefaultWidth,
                              LDTPuckViewDefaultHeight);
    
    
    return [self initWithFrame:frame withBodyColor:bodyColor withBorderColor:borderColor];
}


- (instancetype)initWithFrame:(CGRect)frame withBodyColor:(UIColor *)bodyColor
              withBorderColor:(UIColor *)borderColor
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //[self setBackgroundColor:[UIColor redColor]];
        [self setupWithBodyColor:bodyColor borderColor:borderColor];
    }
    
    return self;
}

#pragma mark Drawing Setup

// Setup the layers that will make up the stroke and fill.
- (void)setupWithBodyColor:(UIColor *)bodyColor borderColor:(UIColor *)borderColor
{
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CAShapeLayer *strokeLayer = [CAShapeLayer layer];
    UIBezierPath *strokePath = [UIBezierPath bezierPathWithArcCenter:center
                                                              radius:LDTPuckViewDeselectedRadius
                                                          startAngle:0 endAngle:(CGFloat)(2 * M_PI)
                                                           clockwise:YES];
    strokeLayer.path = [strokePath CGPath];
    
    UIColor *strokeFillColor = (nil != borderColor) ? borderColor : LDTPuckViewDeselectedStrokeColor;
    
    strokeLayer.fillColor = [strokeFillColor CGColor];
    strokeLayer.bounds = self.bounds;
    strokeLayer.position = center;
    
    [self.layer addSublayer:strokeLayer];
    self.strokeLayer = strokeLayer;
    
    CAShapeLayer *fillLayer = [CAShapeLayer layer];
    UIBezierPath *fillPath = [UIBezierPath bezierPathWithArcCenter:center
                                                            radius:LDTPuckViewDeselectedRadius - LDTPuckViewStrokeWidth
                                                        startAngle:0 endAngle:(CGFloat)(2 * M_PI)
                                                         clockwise:YES];
    fillLayer.path = [fillPath CGPath];
    
    UIColor *fillColor = (nil != bodyColor) ? bodyColor : [UIColor colorWithRed:0.97 green:0.45 blue:0.07 alpha:1.0];

    fillLayer.fillColor = [fillColor CGColor];
    fillLayer.bounds = self.bounds;
    fillLayer.position = center;
    [self.layer addSublayer:fillLayer];
    self.fillLayer = fillLayer;
    
    self.accessibilityLabel = NSLocalizedString(@"Puck", nil);
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(LDTPuckViewDefaultWidth, LDTPuckViewDefaultHeight);
}

@end
