//
//  AppDelegate.m
//  Screenshot
//
//  Created by Craig McNamara on 24/06/2014.
//  Copyright (c) 2014 dibnt. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  // Insert code here to initialize your application
  // Create the metadata query instance. The metadataSearch @property is
  // declared as retain
  self.metadataSearch = [[NSMetadataQuery alloc] init];
  
  // Register the notifications for batch and completion updates
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(queryDidUpdate:)
                                               name:NSMetadataQueryDidUpdateNotification
                                             object:_metadataSearch];
  
//  [[NSNotificationCenter defaultCenter] addObserver:self
//                                           selector:@selector(initalGatherComplete:)
//                                               name:NSMetadataQueryDidFinishGatheringNotification
//                                             object:_metadataSearch];
  
  // Configure the search predicate to find all images using the
  // public.image UTI
  [self.metadataSearch setPredicate:[NSPredicate predicateWithFormat:@"kMDItemIsScreenCapture = 1"]];
//  NSPredicate *searchPredicate;
//  searchPredicate=[NSPredicate predicateWithFormat:@"kMDItemContentTypeTree == 'public.image'"];
//  [_metadataSearch setPredicate:searchPredicate];
  
  // Set the search scope. In this case it will search the User's home directory
  // and the iCloud documents area
//  NSArray *searchScopes;
//  searchScopes=[NSArray arrayWithObjects:NSMetadataQueryUserHomeScope,
//                NSMetadataQueryUbiquitousDocumentsScope,nil];
//  [_metadataSearch setSearchScopes:searchScopes];
  
  // Configure the sorting of the results so it will order the results by the
  // display name
//  NSSortDescriptor *sortKeys = [[NSSortDescriptor alloc] initWithKey:(id)kMDItemDisplayName
//                                                          ascending:YES];
//  [self.metadataSearch setSortDescriptors:[NSArray arrayWithObject:sortKeys]];
  
  // Begin the asynchronous query
  
  NSLog(@"Starting query!");
  [self.metadataSearch startQuery];
  
}

// Method invoked when notifications of content batches have been received
- (void)queryDidUpdate:sender;
{
  NSLog(@"A data batch has been received");
  
  [self.metadataSearch disableUpdates];
  
  NSUInteger i=0;
  for (i=0; i < [self.metadataSearch resultCount]; i++) {
    NSMetadataItem *theResult = [self.metadataSearch resultAtIndex:i];
    NSString *displayName = [theResult valueForAttribute:(NSString *)kMDItemDisplayName];
    NSLog(@"result at %lu - %@",i,displayName);
  }
  
    [self.metadataSearch enableUpdates];
  
}

//- (void)applicationWillTerminate:(NSNotification *)notification {
//  [self.metadataSearch stopQuery];
//  self.metadataSearch = nil;
//}



// Method invoked when the initial query gathering is completed
- (void)initalGatherComplete:sender;
{
  // Stop the query, the single pass is completed.
  [self.metadataSearch stopQuery];
  
  // Process the content. In this case the application simply
  // iterates over the content, printing the display name key for
  // each image
  NSUInteger i=0;
  for (i=0; i < [self.metadataSearch resultCount]; i++) {
    NSMetadataItem *theResult = [self.metadataSearch resultAtIndex:i];
    NSString *displayName = [theResult valueForAttribute:(NSString *)kMDItemDisplayName];
    NSLog(@"result at %lu - %@",i,displayName);
  }
  
  
  // Remove the notifications to clean up after ourselves.
  // Also release the metadataQuery.
  // When the Query is removed the query results are also lost.
//  [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                  name:NSMetadataQueryDidUpdateNotification
//                                                object:self.metadataSearch];
//  [[NSNotificationCenter defaultCenter] removeObserver:self
//                                                  name:NSMetadataQueryDidFinishGatheringNotification
//                                                object:self.metadataSearch];
//  self.metadataSearch=nil;
}

@end
