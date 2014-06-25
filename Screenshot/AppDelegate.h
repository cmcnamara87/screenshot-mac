//
//  AppDelegate.h
//  Screenshot
//
//  Created by Craig McNamara on 24/06/2014.
//  Copyright (c) 2014 dibnt. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (strong, nonatomic) NSStatusItem *statusItem;
@property (strong, nonatomic) NSMenu *menu;
@property (nonatomic, strong) NSMetadataQuery *metadataSearch;

@end
