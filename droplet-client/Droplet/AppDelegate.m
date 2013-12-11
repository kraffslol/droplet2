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

- (void)uploadFiles:(NSArray*)filenames;

@end


@implementation AppDelegate

@synthesize screenshotsDirectoryListener = screenshotsDirectoryListener_,
            fileUploader = fileUploader_;

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
}

- (void)fileUploaderDidStart:(LSFileUploader*)fileUploader
{
}

- (void)fileUploader:(LSFileUploader*)fileUploader
didChangeProgression:(float)progression
{
}

@end
