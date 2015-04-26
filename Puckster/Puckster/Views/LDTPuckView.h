//
//  LDTPuckView.h
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

@import UIKit;

@protocol LDTPuckViewDataSource;

/**
 The view that will represent a 'puck'. It will use it's delegate to relay information.
 */
@interface LDTPuckView : UIView

@property (nonatomic, readonly) id<LDTPuckViewDataSource> dataSource;

- (instancetype)initWithPoint:(CGPoint)point withDataSource:(id<LDTPuckViewDataSource>)delegate;

@end
