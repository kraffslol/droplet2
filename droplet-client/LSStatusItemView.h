//
//  LSStatusItemView.h
//  Droplet
//
//  Created by Rickard Ekman on 11/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern int const LSStatusItemStateNormal;
extern int const LSStatusItemStateUploading;
extern int const LSStatusItemStateComplete;
extern int const LSStatusItemStateError;

@class LSStatusItemView;

@protocol LSStatusItemViewDelegate

@optional;
- (void)statusItemView:(LSStatusItemView*)view didDropFiles:(NSArray*)filenames;
- (void)statusItemView:(LSStatusItemView *)view didDropString:(NSString*)string;

@end

@interface LSStatusItemView : NSView <NSMenuDelegate> {
    BOOL isMenuVisible_;
    NSStatusItem *statusItem_;
    NSImage *image_;
    NSImage *emptyImage_;
    NSImage *maskImage_;
    NSImage *alternateImage_;
    NSImage *errorImage_;
    NSImage *completedImage_;
    int state_;
    float progression_;
    //NSObject <LSStatusItemViewDelegate> *delegate_;
}

@property (retain) NSStatusItem *statusItem;
@property (retain, nonatomic) NSImage *image;
@property (retain, nonatomic) NSImage *emptyImage;
@property (retain, nonatomic) NSImage *maskImage;
@property (retain, nonatomic) NSImage *alternateImage;
@property (retain, nonatomic) NSImage *errorImage;
@property (retain, nonatomic) NSImage *completedImage;
@property (assign, nonatomic) int state;
@property (assign, nonatomic) float progression;
@property (assign) NSObject <LSStatusItemViewDelegate> *delegate;

@end
