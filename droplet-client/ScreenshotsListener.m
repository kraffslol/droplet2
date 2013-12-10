//
//  ScreenshotsListener.m
//  Droplet
//
//  Created by Rickard Ekman on 09/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import "ScreenshotsListener.h"

@interface ScreenshotsListener () <NSMetadataQueryDelegate>

@property (retain) NSDate *date;
@property (retain) NSMetadataQuery *query;

@end

@implementation ScreenshotsListener

@synthesize listening,
            query,
            date,
            delegate;

- (id)init
{
    self = [super init];
    if (self) {
        date = [[NSDate alloc] init];
        query = [[NSMetadataQuery alloc] init];
        [query setDelegate:self];
        [query setPredicate:[NSPredicate predicateWithFormat:@"kMDItemIsScreenCapture = 1"]];
        [query startQuery];
    }
    
    return self;
}

/*- (void)dealloc
{
    [date release];
    [query release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}*/

- (void)setListening:(BOOL)isListening {
    if(listening == isListening)
        return;
    listening = isListening;
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    if(listening) {
        self.date = [NSDate date];
        [nc addObserver:self selector:@selector(queryUpdated:) name:NSMetadataQueryDidStartGatheringNotification object:query];
        [nc addObserver:self selector:@selector(queryUpdated:) name:NSMetadataQueryDidUpdateNotification object:query];
        [nc addObserver:self selector:@selector(queryUpdated:) name:NSMetadataQueryDidFinishGatheringNotification object:query];
    }
    else {
        [nc removeObserver:self];
    }
}

- (void)queryUpdated:(NSNotification *)note {
    NSDate *newDate = nil;
    for (NSMetadataItem *result in self.query.results) {
        NSURL *fileURL = [NSURL fileURLWithPath:[result valueForAttribute:NSMetadataItemPathKey]];
        if(!fileURL)
            continue;
        NSDate *creationDate = [result valueForAttribute:NSMetadataItemFSCreationDateKey];
        if(creationDate != nil && [self.date compare:creationDate] == NSOrderedAscending) {
            if(newDate == nil || ([newDate compare:creationDate] == NSOrderedAscending)) {
                newDate = creationDate;
            }
            
            if([delegate respondsToSelector:@selector(directoryListener:newFile:)])
                [delegate directoryListener:self newFile:fileURL];
        }
    }
    
    if(newDate)
        self.date = newDate;
}

@end
