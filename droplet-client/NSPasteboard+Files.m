//
//  NSPasteboard+Files.m
//  Droplet
//
//  Created by Rickard Ekman on 20/12/13.
//  Copyright (c) 2013 Larickstudios. All rights reserved.
//

#import "NSPasteboard+Files.h"

@implementation NSPasteboard (Files)

- (NSArray*)filesRepresentation {
    NSString *type = [self availableTypeFromArray:
                      [NSArray arrayWithObjects:
                       NSFilenamesPboardType,NSTIFFPboardType,
                       NSPasteboardTypeTIFF,NSPasteboardTypePNG,nil]];
    NSMutableArray *files = [NSMutableArray array];
    
    if(!type)
        return files;
    NSData *data = [self dataForType:type];
    if(type == NSTIFFPboardType || type == NSPasteboardTypeTIFF || type == NSPasteboardTypePNG) {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
        NSString *path = [NSString stringWithFormat:@"/tmp/image-%@.png",
        [formatter stringFromDate:[NSDate date]]];
        
        NSData *imageRepresentation = [[NSBitmapImageRep imageRepWithData:data]
                                       representationUsingType:NSPNGFileType
                                       properties:nil];
        [imageRepresentation writeToFile:path atomically:YES];
        
        [files addObject:path];
    }
    else if(type == NSFilenamesPboardType) {
        NSError *errorDescription;
        files = [NSPropertyListSerialization propertyListWithData:data options:kCFPropertyListImmutable format:Nil error:&errorDescription];
    }
    
    if(!files)
        return [NSArray array];
    return files;
}

@end
