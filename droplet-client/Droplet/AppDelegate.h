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
#import "LSStatusItemView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate,
                                    DirectoryListenerDelegate,
                                    LSFileUploaderDelegate,
                                    NSUserNotificationCenterDelegate,
                                    LSStatusItemViewDelegate>
{
    ScreenshotsListener *screenshotsDirectoryListener_;
    LSFileUploader *fileUploader_;
    NSStatusItem *statusItem_;
    LSStatusItemView *statusView_;
    NSMenu *statusMenu_;
    NSMenuItem *seperatorMenuItem_;
    
    NSString *uploadedFileURL;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSTextField *customHostTextField;
@property (assign) IBOutlet NSButton *hostCheckbox;

- (IBAction)hostChanged:(id)sender;
- (IBAction)hostTextChanged:(id)sender;


@end
