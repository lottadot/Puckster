//
//  LDTPuckView.h
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

@import UIKit;
@protocol LDTPuckViewDelegate;

/**
 The view that will represent a 'puck'. It will use it's delegate to relay information.
 */
@interface LDTPuckView : UIView

@property (nonatomic, readonly) id<LDTPuckViewDelegate> delegate;

- (instancetype)initWithDelegate:(id<LDTPuckViewDelegate>)delegate;

@end
