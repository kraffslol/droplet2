//
//  LSFileUpload.h
//  Droplet
//
//  Created by Rickard Ekman on 10/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSFileUploadDelegate.h"

@interface LSFileUpload : NSObject {
    NSString *destination_;
    NSURL *source_;
    __unsafe_unretained NSObject <LSFileUploadDelegate> *delegate_;
}

@property (retain) NSString *destination;
@property (retain) NSURL *source;
@property (assign) NSObject <LSFileUploadDelegate> *delegate;

- (id)initWithDestination:(NSString *)destination
                   source:(NSURL *)source
                 delegate:(NSObject <LSFileUploadDelegate> *)delegate;
- (void)start;
- (void)cancel;


@end