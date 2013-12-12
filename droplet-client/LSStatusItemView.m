//
//  LSStatusItemView.m
//  Droplet
//
//  Created by Rickard Ekman on 11/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import "LSStatusItemView.h"

int const LSStatusItemStateNormal = 0;
int const LSStatusItemStateUploading = 1;
int const LSStatusItemStateComplete = 2;
int const LSStatusItemStateError = 3;

@interface LSStatusItemView ()

@property (assign) BOOL isMenuVisible;

@end

@implementation LSStatusItemView

@synthesize statusItem        = statusItem_,
image             = image_,
emptyImage        = emptyImage_,
maskImage         = maskImage_,
alternateImage    = alternateImage_,
errorImage        = errorImage_,
completedImage    = completedImage_,
state             = state_,
progression       = progression_,
isMenuVisible     = isMenuVisible_,
delegate          = delegate_;

- (id)initWithFrame:(NSRect)frameRect
{
    self = [super initWithFrame:frameRect];
    if (self) {
        statusItem_ = nil;
        image_ = nil;
        emptyImage_ = nil;
        maskImage_ = nil;
        state_ = LSStatusItemStateNormal;
        progression_ = 1.0;
        alternateImage_ = nil;
        errorImage_ = nil;
        completedImage_ = nil;
        delegate_ = nil;
        
        [self registerForDraggedTypes:[NSArray arrayWithObjects:NSFilenamesPboardType, NSStringPboardType, nil]];
    }
    return self;
}

- (void)mouseDown:(NSEvent *)event {
    [[self menu] setDelegate:self];
    [self.statusItem popUpStatusItemMenu:[self menu]];
    [self setNeedsDisplay:YES];
    [self.statusItem setHighlightMode:YES];
}

- (void)rightMouseDown:(NSEvent *)event {
    [self mouseDown:event];
}

- (void)menuWillOpen:(NSMenu *)menu {
    self.isMenuVisible = YES;
    [self setNeedsDisplay:YES];
}

- (void)menuDidClose:(NSMenu *)menu {
    self.isMenuVisible = NO;
    [menu setDelegate:nil];
    [self setNeedsDisplay:YES];
}

- (void)drawRect:(NSRect)dirtyRect
{
    [self.statusItem drawStatusBarBackgroundInRect:[self bounds] withHighlight:self.isMenuVisible];
    
    NSImage *image = nil;
    if(self.isMenuVisible && self.alternateImage)
        image = self.alternateImage;
    else {
        if(self.state == LSStatusItemStateNormal)
            image = self.image;
        else if(self.state == LSStatusItemStateComplete)
            image = self.completedImage;
        else if(self.state == LSStatusItemStateError)
            image = self.errorImage;
        else if(self.state == LSStatusItemStateUploading)
            image = self.emptyImage;
    }
    if(image)
    {
        [image drawInRect:NSMakeRect(3, 2, image.size.width, image.size.height) fromRect:NSMakeRect(0, 0, image.size.width, image.size.height) operation:NSCompositeSourceOver fraction:1.0];
        if(self.state == LSStatusItemStateUploading && image != self.alternateImage)
        {
            // Uploading process animation
        }
    }
}

- (void)setState:(int)state
{
    if(state == state_)
        return;
    state_ = state;
    [self setNeedsDisplay:YES];
}

@end
