//
//  LDTPuckViewDataSource.h
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

@import Foundation;

@protocol LDTPuckViewDataSource <NSObject>

@optional

- (UIColor *)puckColor;
- (UIColor *)puckBorderColor;

@end
