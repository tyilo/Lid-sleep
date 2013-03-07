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

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		[[NSDistributedNotificationCenter defaultCenter] addObserverForName:@"com.apple.BezelServices.BMDisplayHWReconfiguredEvent" object:nil queue:nil usingBlock:^(NSNotification *notification) {
			if(!isBuiltinDisplayConnected()) {
				SBApplication *systemEvents = [SBApplication applicationWithBundleIdentifier:@"com.apple.systemevents"];
				[systemEvents performSelector:@selector(sleep)];
			}
		}];
		
		CFRunLoopRun();
	}
    return 0;
}

