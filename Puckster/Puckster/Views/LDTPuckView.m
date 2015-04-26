//
//  LDTPuckView.m
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import "LDTPuckView.h"
#import "LDTPuckViewDataSource.h"

#define LDTPuckViewDefaultWidth  50.0f
#define LDTPuckViewDefaultHeight 50.0f

#define LDTPuckViewStrokeWidth 3.0f

#define LDTPuckViewDeselectedRadius 22.0f
#define LDTPuckViewSelectedRadius   50.0f // Go with Radius or width/height? TODO

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

- (instancetype)initWithPoint:(CGPoint)point withDataSource:(id<LDTPuckViewDataSource>)delegate
{
    CGRect frame = CGRectMake(point.x - LDTPuckViewDefaultWidth,
                              point.y - LDTPuckViewDefaultHeight,
                              LDTPuckViewDefaultWidth,
                              LDTPuckViewDefaultHeight);
    return [self initWithFrame:frame withDelegate:delegate];
}

- (instancetype)initWithFrame:(CGRect)frame withDelegate:(id<LDTPuckViewDataSource>)delegate
{
    NSParameterAssert(delegate);
    self = [super initWithFrame:frame];
    if (self) {
        //[self setBackgroundColor:[UIColor redColor]];
        _dataSource = delegate;
        [self setup];
    }
    return self;
}

// Setup the layers that will make up the stroke and fill.
- (void)setup
{
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    CAShapeLayer *strokeLayer = [CAShapeLayer layer];
    UIBezierPath *strokePath = [UIBezierPath bezierPathWithArcCenter:center
                                                              radius:LDTPuckViewDeselectedRadius
                                                          startAngle:0 endAngle:(CGFloat)(2 * M_PI)
                                                           clockwise:YES];
    strokeLayer.path = [strokePath CGPath];
    
    UIColor *strokeFillColor = LDTPuckViewDeselectedStrokeColor;
    
    if (nil != self.dataSource) {
        if ([self.dataSource conformsToProtocol:@protocol(LDTPuckViewDataSource)]) {
            if ([self.dataSource respondsToSelector:@selector(puckBorderColor)]) {
                strokeFillColor = [self.dataSource puckBorderColor];
            }
        }
    }
    
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
    
    UIColor *fillColor = [UIColor colorWithRed:0.97 green:0.45 blue:0.07 alpha:1.0];
    
    if (nil != self.dataSource) {
        if ([self.dataSource conformsToProtocol:@protocol(LDTPuckViewDataSource)]) {
            if ([self.dataSource respondsToSelector:@selector(puckColor)]) {
                fillColor = [self.dataSource puckColor];
            }
        }
    }
    
    fillLayer.fillColor = [fillColor CGColor];
    fillLayer.bounds = self.bounds;
    fillLayer.position = center;
    [self.layer addSublayer:fillLayer];
    self.fillLayer = fillLayer;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(LDTPuckViewDefaultWidth, LDTPuckViewDefaultHeight);
}

@end
