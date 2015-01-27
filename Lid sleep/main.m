//
//  main.m
//  Lid sleep
//
//  Created by Asger Hautop Drewsen on 07/03/2013.
//  Copyright (c) 2013 Asger Hautop Drewsen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>
#import <ScriptingBridge/ScriptingBridge.h>

BOOL isBuiltinDisplayConnected() {
	for(NSScreen* screen in [NSScreen screens]) {
		NSDictionary* screenDictionary = [screen deviceDescription];
		NSNumber* screenID = [screenDictionary objectForKey:@"NSScreenNumber"];
		CGDirectDisplayID aID = [screenID unsignedIntValue];
		if(CGDisplayIsBuiltin(aID)) {
			return YES;
		}
	}
	return NO;
}

void displayConfigChanged(CGDirectDisplayID display, CGDisplayChangeSummaryFlags flags, void *userInfo) {
	if(!isBuiltinDisplayConnected()) {
		NSLog(@"Builtin display removed, sleeping...");

		SBApplication *systemEvents = [SBApplication applicationWithBundleIdentifier:@"com.apple.systemevents"];
		[systemEvents performSelector:@selector(sleep)];
	}
}

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		CGDisplayRegisterReconfigurationCallback(displayConfigChanged, NULL);

		NSApplicationLoad();
		
		CFRunLoopRun();
	}
    return 0;
}

