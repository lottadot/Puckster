//
//  AppDelegate.m
//  Puckster
//
//  Created by Shane Zatezalo on 4/19/15.
//  Copyright (c) 2015 Lottadot LLC. All rights reserved.
//

#import "AppDelegate.h"
#import <PucksterFramework/LDTPuckControl.h>
#import <PucksterFramework/UIView+LDTPuckAutoLayoutUtil.h>

@interface AppDelegate () <LDTPuckControlDataSource, LDTPuckControlDelegate>

@property (nonatomic, strong) LDTPuckControl *puckControl;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self performSelector:@selector(addPuck) withObject:application afterDelay:2.0f];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)addPuck
{
    if (nil == _puckControl) {
        UIWindow *window = self.window;
        _puckControl = [[LDTPuckControl alloc] initInWindow:window
                                               withLocation:LDTPuckViewLocationBottomRight
                                               withDelegate:self dataSource:self
                                                  puckColor:[UIColor yellowColor]
                                            puckBorderColor:[UIColor redColor]
                                                   animated:YES];
    }
}

#pragma mark - LDTPuckControlDataSource

- (UIView *)contentViewForPuckControl:(LDTPuckControl *)puckControl
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [view setBackgroundColor:[UIColor blueColor]];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    [label setTranslatesAutoresizingMaskIntoConstraints:NO];
    [label setText:@"Some information you need"];
    [label setNumberOfLines:0];
    [label setTextColor:[UIColor whiteColor]];
    
    [view addSubview:label];
    [view ldt_centerView:label toContainer:view];
    
    
//    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:label
//                                                                        attribute:NSLayoutAttributeHeight
//                                                                        relatedBy:NSLayoutRelationEqual
//                                                                           toItem:view
//                                                                        attribute:NSLayoutAttributeNotAnAttribute
//                                                                       multiplier:1.0
//                                                                         constant:100.0];
//    [view addConstraint:heightConstraint];
//    
//    NSLayoutConstraint *widthConstraint = [NSLayoutConstraint constraintWithItem:label
//                                                                       attribute:NSLayoutAttributeWidth
//                                                                       relatedBy:NSLayoutRelationEqual
//                                                                          toItem:view
//                                                                       attribute:NSLayoutAttributeNotAnAttribute
//                                                                      multiplier:1.0
//                                                                        constant:100.0];
//    [view addConstraint:widthConstraint];
    
    [label sizeToFit];
    
    return view;
}

- (BOOL)shouldAnimatContentDisplayWithPuckControl:(LDTPuckControl *)puckControl
{
    return YES;
}

- (BOOL)shouldAnimatPuckDismissalPuckControl:(LDTPuckControl *)puckControl
{
    return YES;
}

- (void)didDismissPuckWithPuckControl:(LDTPuckControl *)puckControl
{
    [self performSelector:@selector(killThePuck) withObject:nil afterDelay:.05f];
}

- (void)killThePuck
{
    _puckControl = nil;
}


@end
