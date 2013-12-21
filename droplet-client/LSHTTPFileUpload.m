//
//  LSHTTPFileUpload.m
//  Droplet
//
//  Created by Rickard Ekman on 11/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import "LSHTTPFileUpload.h"

@interface LSHTTPFileUpload ()

@property (assign) long fileSize;
@property (assign) long totalBytesWritten;
@property (nonatomic, retain) NSMutableData *responseData;

@end

@implementation LSHTTPFileUpload

@synthesize fileSize = fileSize_,
            totalBytesWritten = totalBytesWritten_,
            responseData = responseData_;

- (void)cancel
{
    // Cancel
}

-(NSURLRequest *)postRequestWithURL: (NSString *)url

                               data: (NSData *)data
                           fileName: (NSString*)fileName
{
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] init];
    [urlRequest setURL:[NSURL URLWithString:url]];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    NSString *myboundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSMutableData *postData = [NSMutableData data];
    [postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"file\"; filename=\"%@\"\r\n", fileName]dataUsingEncoding:NSUTF8StringEncoding]];
    [postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
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
    
    NSString *fileName = [self.source lastPathComponent];
    
    //NSURL *destination = [NSURL URLWithString:self.destination];
    NSData* data = [NSData dataWithContentsOfURL:self.source];
    NSURLRequest *httpReq = [self postRequestWithURL:self.destination data:data fileName:fileName];
    
    if([self.delegate respondsToSelector:@selector(fileUploadDidStartUpload:)])
        [self.delegate fileUploadDidStartUpload:self];

    NSLog(@"Uploading");
    self.responseData = [NSMutableData data];
    NSURLConnection *result = [[NSURLConnection alloc] initWithRequest:httpReq delegate:self];
    result = nil;
    
    
}

- (void)connection:(NSURLConnection *)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    //self.totalBytesWritten += bytesWritten;
    
    float progression = ((float)totalBytesWritten / (float)self.fileSize);
    if([self.delegate respondsToSelector:@selector(fileUpload:didChangeProgression:bytesRead:totalBytes:)]) {
        [self.delegate fileUpload:self didChangeProgression:progression bytesRead:totalBytesWritten totalBytes:self.fileSize];
        NSLog(@"Progress %f", progression);
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
        NSLog(@"Upload Failed with error %@",error);
        if([self.delegate respondsToSelector:@selector(fileUpload:didFailWithError:)])
            [self.delegate fileUpload:self
                         didFailWithError:error.description];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    NSInteger code = [httpResponse statusCode];
    NSLog(@"Got response with %ld", (long)code);
    if(code == 200) {
        [self.responseData setLength:0];
    } else {
        NSError *error;
        [connection cancel];
        if([self.delegate respondsToSelector:@selector(fileUpload:didFailWithError:)])
            [self.delegate fileUpload:self
                     didFailWithError:error.description];
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSString *responseString = [[NSString alloc] initWithData:self.responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", responseString);
    if([self.delegate respondsToSelector:@selector(fileUploadDidSuccess:didSuccessWithResponse:)])
        [self.delegate fileUploadDidSuccess:self didSuccessWithResponse:responseString];
}

@end
