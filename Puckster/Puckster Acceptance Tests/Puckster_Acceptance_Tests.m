//
//  Puckster_Acceptance_Tests.m
//  Puckster Acceptance Tests
//
//  Created by Shane Zatezalo on 5/3/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <KIFFramework/KIFFramework.h>

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

- (void)testExample {
    [tester waitForViewWithAccessibilityLabel:@"ExampleLabel"];
}

@end
