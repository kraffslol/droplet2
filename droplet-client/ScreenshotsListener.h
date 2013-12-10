//
//  ScreenshotsListener.h
//  Droplet
//
//  Created by Rickard Ekman on 09/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DirectoryListenerDelegate;

@interface ScreenshotsListener : NSObject {
    
}

@property (assign, nonatomic) BOOL listening;
@property (assign) NSObject <DirectoryListenerDelegate> *delegate;

@end

@protocol DirectoryListenerDelegate

- (void)directoryListener:(ScreenshotsListener*)aDirectoryListener
                  newFile:(NSURL*)fileURL;

@end
