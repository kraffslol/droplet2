//
//  AppDelegate.m
//  Droplet
//
//  Created by Rickard Ekman on 09/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (retain) ScreenshotsListener *screenshotsDirectoryListener;
@property (retain) LSFileUploader *fileUploader;
@property (retain) NSStatusItem *statusItem;
@property (retain) LSStatusItemView *statusView;
@property (retain) NSMenu *statusMenu;
@property (retain) NSMenuItem *separatorMenuItem;
@property (retain) NSTimer *restoreDockIconTimer;


- (void)uploadFiles:(NSArray*)filenames;
- (void)setDisplayStatusItem:(BOOL)flag;
- (void)displayCompletedIcons;

@end


@implementation AppDelegate

@synthesize screenshotsDirectoryListener = screenshotsDirectoryListener_,
            fileUploader = fileUploader_,
            statusItem = statusItem_,
            statusView = statusView_,
            statusMenu = statusMenu_,
            separatorMenuItem = seperatorMenuItem_,
restoreDockIconTimer = restoreDockIconTimer_;

- (id)init
{
    self = [super init];
    
    if (self) {
        
        fileUploader_ = [[LSFileUploader alloc] init];
        fileUploader_.delegate = self;
        
        screenshotsDirectoryListener_ = [[ScreenshotsListener alloc] init];
        // TODO: Add config for listening.
        [screenshotsDirectoryListener_ setListening:YES];
        [screenshotsDirectoryListener_ setDelegate:self];
        
        statusMenu_ = [[NSMenu alloc] init];
        [statusMenu_ addItemWithTitle:@"Preferences" action:@selector(openPreferences) keyEquivalent:@""];
        [statusMenu_ addItemWithTitle:@"Quit" action:@selector(quit) keyEquivalent:@""];
        
        [self setDisplayStatusItem:YES];
        
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    [NSApp setServicesProvider:self];
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(windowDidUpdate:)
                                                 name:NSWindowDidUpdateNotification
                                               object:nil];
    
}

- (void)windowDidUpdate:(NSNotification*)notification
{
    //NSLog(@"Notifcation");
    //if(self.statusItem && self.statusItem.view.window)
    //    [self.statusItem.view.window makeKeyAndOrderFront:self];
}

- (void)directoryListener:(ScreenshotsListener *)aDirectoryListener newFile:(NSURL *)fileURL
{
    // Upload
    NSLog(@"Detected screenshot");
    [self uploadFiles:[NSArray arrayWithObject:fileURL.path]];
}

- (void)uploadFiles:(NSArray*)filenames
{
    NSString *file = nil;
    NSString *filename;
    
    file  = [filenames objectAtIndex:0];
    filename = [file lastPathComponent];
    //NSLog(filename);
    
    
    if(file) {
        NSLog(@"Sending to fileuploader");
        [fileUploader_ uploadFile:file toFilename:filename];
    }
    
}

- (void)fileUploader:(LSFileUploader *)fileUploader
    didFailWithError:(NSString *)error
{
    
}

- (void)fileUploader:(LSFileUploader*)fileUploader
          didSuccess:(NSString*)url
            fileName:(NSString*)filename
            filePath:(NSString*)filepath
{
    NSString *type = NSStringPboardType;
    [[NSPasteboard generalPasteboard] declareTypes:[NSArray arrayWithObject:type] owner:nil];
    [[NSPasteboard generalPasteboard] setString:url forType:type];
    
    
    if(NSClassFromString(@"NSUserNotification")) {
        NSUserNotification *notification = [NSUserNotification new];
        notification.hasActionButton = NO;
        notification.title = @"File uploaded";
        notification.informativeText = @"The URL has been written into your pasteboard";
        NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
        [center setDelegate:self];
        [center deliverNotification:notification];
    }
    
    [self displayCompletedIcons];
}

- (void)fileUploaderDidStart:(LSFileUploader*)fileUploader
{
    self.statusView.state = LSStatusItemStateUploading;
    self.statusView.progression = 0;
}

- (void)fileUploader:(LSFileUploader*)fileUploader
didChangeProgression:(float)progression
{
    self.statusView.state = LSStatusItemStateUploading;
    self.statusView.progression = progression;
}

- (BOOL)userNotificationCenter:(NSUserNotificationCenter *)center shouldPresentNotification:(NSUserNotification *)notification
{
    return YES;
}

- (void)setDisplayStatusItem:(BOOL)flag;
{
    if(flag) {
        if(!self.statusItem) {
            self.statusItem = [[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength];
            self.statusItem.menu = self.statusMenu;
            self.statusItem.highlightMode = YES;
            
            self.statusView = [[LSStatusItemView alloc] initWithFrame:NSMakeRect(0, 0, 26, 24)];
            self.statusView.statusItem = self.statusItem;
            self.statusView.menu = self.statusMenu;
            self.statusView.autoresizingMask = NSViewWidthSizable | NSViewHeightSizable;
            self.statusView.image = [NSImage imageNamed:@"status_item"];
            self.statusView.alternateImage = [NSImage imageNamed:@"status_item_highlighted"];
            self.statusView.errorImage = [NSImage imageNamed:@"status_item_error"];
            self.statusView.completedImage = [NSImage imageNamed:@"status_item_completed"];
            self.statusView.maskImage = [NSImage imageNamed:@"status_item_mask"];
            self.statusView.emptyImage = [NSImage imageNamed:@"status_item_empty"];
            self.statusView.delegate = self;
            
            self.statusItem.view = self.statusView;
        }
    }
    else {
        if(self.statusItem)
            [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
        self.statusItem = nil;
        self.statusView = nil;
    }
}

- (void)displayCompletedIcons
{
    self.statusView.state = LSStatusItemStateComplete;
    
    if(self.restoreDockIconTimer)
        [self.restoreDockIconTimer invalidate];
    self.restoreDockIconTimer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(restoreIcon) userInfo:nil repeats:NO];
}

- (void)restoreIcon
{
    self.statusView.state = LSStatusItemStateNormal;
    self.statusView.progression = 0;
}

- (void)openPreferences
{
    [self.window makeKeyAndOrderFront:self];
    [NSApp setActivationPolicy:NSApplicationActivationPolicyAccessory];
    [NSApp activateIgnoringOtherApps:YES];
}

- (void)quit
{
    [NSApp terminate:self];
}

@end
