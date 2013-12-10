//
//  LSFileUploader.h
//  Droplet
//
//  Created by Rickard Ekman on 09/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSFileUpload.h"
#import "LSFileUploadDelegate.h"

@class LSFileUploader;

@protocol LSFileUploaderDelegate

- (void)fileUploaderDidStart:(LSFileUploader*)fileUploader;
- (void)fileUploader:(LSFileUploader*)fileUploader didChangeProgression:(float)progression;
- (void)fileUploader:(LSFileUploader*)fileUploader
          didSuccess:(NSString*)url
            fileName:(NSString*)filename
            filePath:(NSString*)filepath;
- (void)fileUploader:(LSFileUploader *)fileUploader didFailWithError:(NSString*)error;

@end

@interface LSFileUploader : NSObject <LSFileUploaderDelegate> {
    LSFileUpload *fileupload_;
    NSString *filename_;
    NSString *filepath_;
    int tries_;
    //NSObject <LSFileUploaderDelegate> *delegate_;
}

@property (nonatomic, assign) NSObject <LSFileUploaderDelegate> *delegate;

- (void)uploadFile:(NSString*)filepath
        toFilename:(NSString*)filename;

@end
