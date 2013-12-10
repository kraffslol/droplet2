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

- (void)uploadFiles:(NSArray*)filenames;

@end


@implementation AppDelegate

@synthesize screenshotsDirectoryListener = screenshotsDirectoryListener_;

- (id)init
{
    self = [super init];
    
    if (self) {
        
        screenshotsDirectoryListener_ = [[ScreenshotsListener alloc] init];
        // TODO: Add config for listening.
        [screenshotsDirectoryListener_ setListening:YES];
        [screenshotsDirectoryListener_ setDelegate:self];
        
    }
    
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
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
    
    
    if(file)
        // If theres a file upload it!
        return;
}

@end