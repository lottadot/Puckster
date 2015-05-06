[![Build Status](https://travis-ci.org/lottadot/Puckster.svg?branch=development)](https://travis-ci.org/lottadot/Puckster) [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Puckster Debug Puck
===============
This is an iOS-8 Dynamic framework that gives you "Debug Puck"; a small item on the screen that can be tapped to provide "hidden" information.

## Why
We generally implement things like this into our apps during QA or UAT. It is intended to let the tester obtain information which a normal user would not normally have access to.

I've found over the years, I am constantly implementing something similar, for each project, over and over. Now, I won't have to. I'll just pull this in via [Carthage](https://github.com/carthage/carthage).

The "puck" is flickable, around the edges of the screen. The user can fling move it out of the way. The user can totally dismiss the puck by double-tapping it.

This framework is carthage compatible, so it's easy to use. You can wire it up to a hidden shake or super-secret gesture.

[Puckster UI video](https://github.com/lottadot/Puckster/raw/development/assets/puckster-1-0-0.mov)
![Puckster UI Screenshot](https://github.com/lottadot/Puckster/raw/development/assets/puckster-1-0-0.png)

### Use
You'll add the puck to the current UIWindow:

````
_puckControl = [[LDTPuckControl alloc] initInWindow:window
                                       withLocation:LDTPuckViewLocationBottomRight
                                       withDelegate:self 
                                       dataSource:self
                                          puckColor:[UIColor yellowColor]
                                    puckBorderColor:[UIColor redColor]
                                           animated:YES];
````

You'll want to provide it a delegate and data source. Then tell it to present:

````
[_puckControl presentPuckAnimated:YES];
````

### Tests
This framework comes with logical unit tests, as well as acceptance tests (done with KIF).
To run them:

#### Logical Tests
````
xcodebuild -workspace DebugPuck.xcworkspace -scheme "Puckster" -destination 'platform=iOS Simulator,name=iPhone 6,OS=latest' test
````

#### Acceptance Tests
````
xcodebuild -workspace DebugPuck.xcworkspace -scheme "Puckster Acceptance Tests" test
````

## License

Puckster is released under the [MIT License](LICENSE.md).
