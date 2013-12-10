//
//  NSObject_LSFileUploadDelegate.h
//  Droplet
//
//  Created by Rickard Ekman on 10/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSFileUpload;

@protocol LSFileUploadDelegate <NSObject>

@optional
- (void)fileUpload:(LSFileUpload*)fileUpload didFailWithError:(NSString*)error;
- (void)fileUploadDidSuccess:(LSFileUpload*)fileUpload;
- (void)fileUploadDidStartUpload:(LSFileUpload*)fileUpload;
- (void)fileUpload:(LSFileUpload*)fileUpload didChangeProgression:(float)progression
         bytesRead:(long)bytesRead
        totalBytes:(long)totalBytes;

@end
