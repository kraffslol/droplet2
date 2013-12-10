//
//  LSFileUploader.m
//  Droplet
//
//  Created by Rickard Ekman on 09/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import "LSFileUploader.h"

@interface LSFileUploader ()

@property (retain) LSFileUpload *fileUpload;
@property (retain) NSString *filename;
@property (retain) NSString *filepath;
@property (assign) int tries;

//- (void)deleteFile:(NSURL*)fileURL;

@end

@implementation LSFileUploader

@synthesize delegate = delegate_,
fileUpload = fileUpload_,
filename = filename_,
filepath = filepath_,
tries = tries_;

- (void)uploadFile:(NSString *)filepath toFilename:(NSString *)filename
{
    if(self.fileUpload)
        return;
    self.tries = 3;
    NSURL *source = [NSURL fileURLWithPath:filepath];
    self.filepath = filepath;
    self.filename = filename;
    
}

@end
