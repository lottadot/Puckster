//
//  LDTPuckContentView.h
//  Puckster
//
//  Created by Shane Zatezalo on 4/25/15.
//  Copyright (c) 2015-2018 Lottadot LLC. All rights reserved.
//

@import UIKit;

/**
 The `LDTPuckContentView` is the `UIView` based class used to display content when the user single-taps on the puck.
 */
@interface LDTPuckContentView : UIView

/**
 Sets the content to be shown. If nil, removes any existing content.
 */
- (void)setContent:(UIView *)contentView;

@end
