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

@interface PucksterTests : XCTestCase

@property (nonatomic, strong) ViewController *viewController;
@property (nonatomic, strong) LDTPuckControl *puckControl;

@end

@implementation PucksterTests

- (void)setUp
{
    [super setUp];
// TODO
//    _viewController = [ViewController new];
//    UIWindow *window = _viewController.view.window;
//    
//    [_viewController beginAppearanceTransition:YES animated:YES];
//    [_viewController loadView];
//    [_viewController endAppearanceTransition];
//    
//    _puckControl = [[LDTPuckControl alloc]
//                    initInWindow:window
//                    withLocation:LDTPuckViewLocationBottomRight
//                    withDelegate:_viewController
//                    dataSource:_viewController
//                    puckColor:[UIColor greenColor]
//                    puckBorderColor:[UIColor blackColor]
//                    animated:YES];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)test001ElementsExist
{
// TODO
//    XCTAssertNotNil(_viewController);
//    XCTAssertNotNil(_puckControl);
}

@end
