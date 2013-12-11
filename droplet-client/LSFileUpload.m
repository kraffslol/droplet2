//
//  LSFileUpload.m
//  Droplet
//
//  Created by Rickard Ekman on 10/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import "LSFileUpload.h"

@implementation LSFileUpload

@synthesize destination = destination_,
source = source_,
delegate = delegate_;

- (id)initWithDestination:(NSString *)destination source:(NSURL *)source delegate:(NSObject <LSFileUploadDelegate> *)delegate
{
    NSLog(@"init?");
    self = [super init];
    if(self) {
        destination_ = destination;
        source_ = source;
        delegate_ = delegate;
    }
    return self;
}

- (void)start {
    
}

- (void)cancel {
    
}

@end