//
//  Puckster_Acceptance_Tests.m
//  Puckster Acceptance Tests
//
//  Created by Shane Zatezalo on 5/3/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIF/KIF.h>

@interface Puckster_Acceptance_Tests : KIFTestCase

@end

@implementation Puckster_Acceptance_Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test001VerifyInitialSetup
{
    [tester waitForViewWithAccessibilityLabel:@"Puckster View Controller"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Puck"];
}

- (void)test002VerifyPuckIsShown
{
    [tester waitForTimeInterval:5.0f];
    [tester waitForViewWithAccessibilityLabel:@"Puck"];
}

- (void)test002VerifyPuckCanBeSwipedLeft
{
    // Default is to place the puck in the bottom right corner. Thefore, the user should be able to swipe it to the left.
    [tester swipeViewWithAccessibilityLabel:@"Puck" inDirection:KIFSwipeDirectionLeft];
    [tester waitForTimeInterval:1.0f];
}

- (void)test003VerifyPuckCanBeSwipedUp
{
    // Default is to place the puck in the bottom right corner. Thefore, the user should be able to swipe it up. We have already moved the puck to the left.
    [tester swipeViewWithAccessibilityLabel:@"Puck" inDirection:KIFSwipeDirectionUp];
    [tester waitForTimeInterval:1.0f];
}

- (void)test004VerifyPuckCanBeSwipedRight
{
    [tester swipeViewWithAccessibilityLabel:@"Puck" inDirection:KIFSwipeDirectionRight];
    [tester waitForTimeInterval:1.0f];
}

- (void)test005VerifyPuckCanBeSwipedDown
{
    [tester swipeViewWithAccessibilityLabel:@"Puck" inDirection:KIFSwipeDirectionDown];
    [tester waitForTimeInterval:1.0f];
    // Now the puck is back at it's original spot
}

- (void)test006VerifyPuckIsTappable
{
    [tester waitForTappableViewWithAccessibilityLabel:@"Puck"];
}

- (void)test007VerifyPuckTap
{
    [tester tapViewWithAccessibilityLabel:@"Puck"];
    [tester waitForViewWithAccessibilityLabel:@"Content View For Puck Control"];
}

- (void)test008VerifyInformationViewRemoves
{
    [tester tapViewWithAccessibilityLabel:@"Content View For Puck Control"];
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Content View For Puck Control"];
    [tester waitForViewWithAccessibilityLabel:@"Puck"];
}

- (void)test009VerifyPuckRemoves
{
    // Simulate a double-tap
    // stepToTapViewWithAccessibilityLabel
    
    UIWindow *window = [UIApplication.sharedApplication.windows firstObject];
    UIView *view = [window viewForBaselineLayout];
    CGRect frame = view.bounds;
    
    [tester waitForViewWithAccessibilityLabel:@"Puck"];
    
    CGFloat topPadding = 0.0f;
    CGFloat bottomPadding = 0.0f;
    
    if (@available(iOS 11.0, *)) {
        topPadding = window.safeAreaInsets.top;
        bottomPadding = window.safeAreaInsets.bottom;
    }
    
    CGPoint point = CGPointMake(CGRectGetMaxX(frame) - 25.0f,                           CGRectGetMaxY(frame) - 25.0f  - bottomPadding);

    //[tester tapViewWithAccessibilityLabel:@"Puck"];
    [tester tapScreenAtPoint:point];
    [tester waitForTimeInterval:0.1];
    //[tester tapViewWithAccessibilityLabel:@"Puck"];
    [tester tapScreenAtPoint:point];
    [tester waitForTimeInterval:5.0];
    
    [tester waitForAbsenceOfViewWithAccessibilityLabel:@"Puck"];
    [tester waitForViewWithAccessibilityLabel:@"Puckster View Controller"];
}

@end
