//
//  AppDelegate.h
//  Droplet
//
//  Created by Rickard Ekman on 09/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScreenshotsListener.h"
#import "LSFileUploader.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,
                                    DirectoryListenerDelegate,
                                    LSFileUploaderDelegate>
{
    ScreenshotsListener *screenshotsDirectoryListener_;
    LSFileUploader *fileUploader_;
}

@property (assign) IBOutlet NSWindow *window;

@end
