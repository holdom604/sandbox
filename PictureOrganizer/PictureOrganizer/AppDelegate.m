//
//  AppDelegate.m
//  PictureOrganizer
//
//  Created by Brian on 03/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


@implementation AppDelegate

@synthesize targetDirectory;
@synthesize targetDirectoryContents = _targetDirectoryContents;


- (void) dealloc
{
    [super dealloc];
}

- (void) applicationDidFinishLaunching:(NSNotification*)aNotification
{
    // Insert code here to initialize your application

}

- (IBAction) browseButtonAction:(NSButton*)sender
{
    NSOpenPanel* openDialog = [NSOpenPanel openPanel];
    [openDialog setCanChooseFiles:NO];
    [openDialog setCanChooseDirectories:YES];
    [openDialog setPrompt:@"Select"];

    NSInteger result = [openDialog runModal];

    if( result == NSOKButton )
    {
        self.targetDirectory = [[openDialog directoryURL] path];
    }

    if(![self scanTargetDirectory])
    {
        NSLog(@"Bunch of things failed");
    }
}

- (BOOL) scanTargetDirectory
{
    if( self.targetDirectory == nil )
    {
        NSLog( @"targetDirectory is nil. Please select directory to scan for" );
        return NO;
    }

    NSFileManager* manager = [NSFileManager defaultManager];
    NSError      * error   = nil;
    self.targetDirectoryContents = [manager contentsOfDirectoryAtPath:self.targetDirectory error:&error];

    NSMutableDictionary* listOfFilesWithAttributes = [[NSMutableDictionary new] autorelease];

    for( NSString* fileName in self.targetDirectoryContents )
    {
        NSString    * fullPath         = [self.targetDirectory stringByAppendingPathComponent:fileName];
        NSDictionary* fileAttributes   = [self fileAttributes:fullPath];
        NSString    * fileCreationDate = [fileAttributes objectForKey:NSFileCreationDate];
        NSString    * fileType         = [[NSWorkspace sharedWorkspace] typeOfFile:fullPath error:nil];

        NSLog( @"fileType %@", fileType );

        if( [fileType isEqualToString:@"public.jpeg"] || [fileType isEqualToString:@"public.avi"] )
        {
            NSMutableArray* fileInfo = [[NSMutableArray new] autorelease];

            [fileInfo addObject:fileName];
            [fileInfo addObject:fullPath];
            [fileInfo addObject:fileCreationDate];

            [listOfFilesWithAttributes setValue:fileInfo];
        }
    }

    NSLog( @"listOfFilesWithAttributes: %@", listOfFilesWithAttributes );

    [listOfFilesWithAttributes writeToFile:@"/tmp/listOfFiles" atomically:YES];
    BOOL success = [self sortAndCopyFiles:listOfFilesWithAttributes];
    return success;
}

- (BOOL) sortAndCopyFiles:(NSDictionary*)listOfFiles
{
    for( NSArray* fileInfo in listOfFiles )
    {
        NSLog(@"fileInfo: %@", fileInfo );
    }
    return YES;
}

- (NSDictionary*) fileAttributes:(NSString*)fileName
{
    NSError     * error      = nil;
    NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath:fileName error:&error];
    return attributes;
}

- (BOOL) sortFiles:(NSDictionary*)listOfFiles
{

}

- (void) showOutput:(NSString*)message
{
    if( message != nil )
    {
        [self.outputLabel setStringValue:message];
    }
}

@end