//
//  LSHTTPFileUpload.m
//  Droplet
//
//  Created by Rickard Ekman on 11/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import "LSHTTPFileUpload.h"
#import <CURLHandle/CURLHandle.h>

@interface LSHTTPFileUpload ()

@property (assign) long fileSize;
@property (assign) long totalBytesWritten;
@property (strong, readwrite) CURLHandle *httpSession;

@end

@implementation LSHTTPFileUpload

@synthesize fileSize = fileSize_,
            totalBytesWritten = totalBytesWritten_,
            httpSession = httpSession_;

- (void)cancel
{
    [self.httpSession cancel];
}

-(NSURLRequest *)postRequestWithURL: (NSString *)url

                               data: (NSData *)data
                           fileName: (NSString*)fileName
{
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:url]];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *myboundary = [NSString stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableData *postData = [NSMutableData data];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"image\"; filename=\"%@\"\r\n", fileName]dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[NSData dataWithData:data]];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [urlRequest setHTTPBody:postData];
    return urlRequest;
}

- (void)start {
    NSDictionary *attrs = [[NSFileManager defaultManager] attributesOfItemAtPath:[self.source path] error:nil];
    
    if(attrs) {
        self.fileSize = [((NSNumber*)[attrs valueForKey:NSFileSize]) longValue];
    }
    
    NSURL *destination = [NSURL URLWithString:self.destination];
    NSData* data = [NSData dataWithContentsOfURL:self.source];
    NSURLRequest *httpReq = [self postRequestWithURL:self.destination data:data fileName:@"test.png"];
    
    if([self.delegate respondsToSelector:@selector(fileUploadDidStartUpload:)])
        [self.delegate fileUploadDidStartUpload:self];

    NSLog(@"Uploading");
    NSURLConnection *result = [[NSURLConnection alloc] initWithRequest:httpReq delegate:self];
}

@end
