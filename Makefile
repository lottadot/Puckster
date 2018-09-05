.PHONY: all bootstrap docs analyze test

all: bootstrap docs analyze tests build

bootstrap:
	brew tap Homebrew/bundle
	brew bundle
	#carthage bootstrap --no-use-binaries -cache-builds
	carthage bootstrap --no-use-binaries --platform iOS
	#bundle install
	#pod install

analyze:

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "DorbaNetworking" \
 	   -sdk iphonesimulator \
 	   -destination 'platform=iOS Simulator,name=iPhone 8 Plus,OS=latest' \
	analyze | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "DorbaNetworking" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 8 Plus,OS=latest' \
	analyze | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

build:
	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "DorbaNetworking"

tests: 
	# instruments -s devices

	# iPhone 4S - iOS 8.4, 9.3

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 4S,OS=8.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 4S,OS=9.3' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone 5 - iOS 8.4, 9.3, 10.3.1

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 5,OS=8.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 5,OS=9.3' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 5,OS=10.3.1' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone 5S - iOS 8.4, 9.3, 10.3.1, 11.4

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 5s,OS=8.4' \
	test  | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 5s,OS=9.3' \
	test  | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 5s,OS=10.3.1' \
	test  | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 5s,OS=11.4' \
	test  | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 5s,OS=latest' \
	test  | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone SE - really don't care about this one.

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone SE,OS=latest' \
	test  | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone 6 - 9.3, 10.3.1, 11.4, 12.0

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6,OS=9.3' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6,OS=10.3.1' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6,OS=11.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6,OS=latest' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	
	# iPhone 6 Plus - 9.3, 10.3.1, 11.4, 12.0

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=9.3' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=10.3.1' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=11.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6 Plus,OS=latest' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone 6S - 9.3, 10.3.1, 11.4, 12.0

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6S,OS=9.3' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6S,OS=10.3.1' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6S,OS=11.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6S,OS=latest' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone 6S Plus - 9.3, 10.3.1, 11.4, 12.0

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6S Plus,OS=9.3' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6S Plus,OS=10.3.1' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6S Plus,OS=11.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
		-scheme "Puckster" \
		-sdk iphonesimulator \
		-destination 'platform=iOS Simulator,name=iPhone 6S Plus,OS=latest' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -


	# iPhone 7 - 10.3.1, 11.4, 12.0

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7,OS=10.3.1' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7,OS=11.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7,OS=latest' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone 7 Plus  - 10.3.1, 11.4, 12.0

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7 Plus,OS=10.3.1' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7 Plus,OS=11.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7Plus ,OS=latest' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone 7S - 10.3.1, 11.4, 12.0

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7S,OS=10.3.1' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7S,OS=11.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7S,OS=latest' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone 7S Plus - 10.3.1, 11.4, 12.0

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7S Plus,OS=10.3.1' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7S Plus,OS=11.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 7S Plus,OS=latest' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone 8 - 11.4, 12.0

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 8,OS=10.3.1' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 8,OS=11.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 8,OS=latest' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone 8 Plus - 11.4, 12.0

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 8 Plus,OS=10.3.1' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 8 Plus,OS=11.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone 8 Plus,OS=latest' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	# iPhone X - 11.4, 12.0

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone X,OS=11.4' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

	xcrun xcodebuild -workspace DebugPuck.xcworkspace \
	   -scheme "Puckster Acceptance Tests" \
       -sdk iphonesimulator \
       -destination 'platform=iOS Simulator,name=iPhone X,OS=latest' \
	test | egrep '^(/.+:[0-9+:[0-9]+:.(error|warning):|fatal|===)' -

docs:
	bundle exec jazzy \
	  --clean \
	  --author Lottadot \
	  --author_url https://twitter.com/lottadot \
	  --github_url https://github.com/lottadot \
	  --github-file-prefix https://github.com/lottadot/puckster \
	  --module-version 1.0.0 \
	  --xcodebuild-arguments -scheme,PucksterFramework \
	  --module PucksterFramework \
	  --root-url https://github.com/lottadot/Puckster/docs \
	  --theme apple
	open "docs/index.html"
