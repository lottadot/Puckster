//
//  PucksterTests.m
//  PucksterTests
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "LDTPuckControl.h"
#import "LDTPuckView.h"
#import "LDTPuckViewDataSource.h"
#import "LDTPuckContentView.h"
#import "ViewController.h"
#import <OCMockFramework/OCMockFramework.h>

@interface PucksterTests : XCTestCase

@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) LDTPuckControl *puckControl;

@end

@implementation PucksterTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test001ElementsExist
{
    // TODO Figure out whether we can use our own Window or must mock or...
    _viewController = [ViewController new];
    XCTAssertNotNil(_viewController);
    UIWindow *window = [UIWindow new];  //_viewController.view.window;
    XCTAssertNotNil(window);

    [window setRootViewController:_viewController];
    
    // use OCMock to create a mock delegate object conforming to our custom delegate “LDTPuckControlDataSource”
    id mockPuckDelegate = [OCMockObject mockForProtocol:@protocol(LDTPuckControlDelegate)];
    id mockPuckDataSource = [OCMockObject mockForProtocol:@protocol(LDTPuckControlDataSource)];
    
    [_viewController beginAppearanceTransition:YES animated:YES];
    [_viewController loadView];
    [_viewController endAppearanceTransition];
    
    // [[authService expect] loginWithEmail:[OCMArg any] andPassword:[OCMArg any]];
    // FIXME [[mockPuckDelegate expect] puckBorderColor];
    [[mockPuckDelegate expect] willPresentPuckWithPuckControl:[OCMArg any]];
    [[mockPuckDelegate expect] didPresentPuckWithPuckControl:[OCMArg any]];
    
    _puckControl = [[LDTPuckControl alloc]
                    initInWindow:window
                    withLocation:LDTPuckViewLocationBottomRight
                    withDelegate:mockPuckDelegate
                    dataSource:mockPuckDataSource
                    puckColor:[UIColor greenColor]
                    puckBorderColor:[UIColor blackColor]
                    animated:YES];
    
    XCTAssertNotNil(_viewController);
    XCTAssertNotNil(_puckControl);
    XCTAssertTrue([mockPuckDelegate verify]);
}

@end
