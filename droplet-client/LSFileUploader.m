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

- (id)init {
    self = [super init];
    if(self) {
        fileUpload_ = nil;
        filename_ = nil;
        filepath_ = nil;
        tries_ = -1;
    }
    return self;
}

- (void)uploadFile:(NSString *)filepath toFilename:(NSString *)filename
{
    if(self.fileUpload)
        return;
    self.tries = 3;
    NSURL *source = [NSURL fileURLWithPath:filepath];
    self.filepath = filepath;
    self.filename = filename;
    NSString *encodedFilename = [self.filename stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    
    LSFileUpload *tmpFileUpload = nil;
    NSString *destination = @"http://localhost:3000/upload";
    
    tmpFileUpload = [[LSHTTPFileUpload alloc] initWithDestination:destination source:source delegate:self];
    
    self.fileUpload = tmpFileUpload;
    
    if(self.fileUpload) {
        NSLog(@"Sending to fileupload");
        [self.fileUpload start];
    }

}

- (void)fileUpload:(LSFileUpload*)fileUpload
  didFailWithError:(NSString*)error
{
    self.tries--;
    [self.fileUpload cancel];
    if(self.tries > 0) {
        [self.fileUpload start];
    }
    else {
        if([self.delegate respondsToSelector:@selector(fileUploader:didFailWithError:)])
            [self.delegate fileUploader:self
                       didFailWithError:error];
        
        self.fileUpload = nil;
    }
}

- (void)fileUploadDidStartUpload:(LSFileUpload *)fileUpload
{
    if([self.delegate respondsToSelector:@selector(fileUploaderDidStart:)])
        [self.delegate fileUploaderDidStart:self];
}

- (void)fileUploadDidSuccess:(LSFileUpload*)fileUpload
{
    NSLog(@"Success!");
}

- (void)fileUpload:(LSFileUpload *)fileUpload
didChangeProgression:(float)progression
         bytesRead:(long)bytesRead
        totalBytes:(long)totalBytes
{
    if([self.delegate respondsToSelector:@selector(fileUploader:didChangeProgression:)])
        [self.delegate fileUploader:self didChangeProgression:progression];
}

@end
