//
//  AppDelegate.h
//  Droplet
//
//  Created by Rickard Ekman on 09/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ScreenshotsListener.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,
                                    DirectoryListenerDelegate>
{
    ScreenshotsListener *screenshotsDirectoryListener_;
}

@property (assign) IBOutlet NSWindow *window;

@end
