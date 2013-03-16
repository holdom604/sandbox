//
//  AppDelegate.h
//  PictureOrganizer
//
//  Created by Brian on 03/12/13.
//  Copyright (c) 2013 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    NSMutableArray* targetDirectoryContents;
}

@property (assign) IBOutlet NSWindow *window;
- (IBAction)browseButtonAction:(NSButton *)sender;
@property (assign) IBOutlet NSTextField *outputLabel;

@property (nonatomic, assign) NSString *targetDirectory;
@property(nonatomic, assign) NSArray* targetDirectoryContents;

@end