//
//  AppDelegate.m
//  Screenshot
//
//  Created by Craig McNamara on 24/06/2014.
//  Copyright (c) 2014 dibnt. All rights reserved.
//

#import "AppDelegate.h"
#import "AFURLRequestSerialization.h"
#import "AFURLSessionManager.h"
#import "AFHTTPRequestOperationManager.h"
#import "LoginWindowController.h"

static NSString * const BASE_URL = @"http://ec2-54-206-66-123.ap-southeast-2.compute.amazonaws.com/screenshot/#/";
static NSString * const COLLECTION_BASE_URL = @"http://ec2-54-206-66-123.ap-southeast-2.compute.amazonaws.com/screenshot/#/collections/";
static NSString * const API_BASE_URL = @"http://ec2-54-206-66-123.ap-southeast-2.compute.amazonaws.com/screenshot/api/index.php/";
static NSString * const UPLOAD_BASE_URL = @"http://ec2-54-206-66-123.ap-southeast-2.compute.amazonaws.com/screenshot/uploads/";

@interface AppDelegate ()
  @property (strong, nonatomic) LoginWindowController *logInWindowController;
  @property (strong, nonatomic) NSDictionary *user;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
  NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
  self.statusItem.title = @"";
  self.statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
  self.statusItem.highlightMode = YES;
  [self.statusItem setImage:[NSImage imageNamed:@"icon.png"]];
  
  self.menu = [[NSMenu alloc] init];
//  [self.menu addItemWithTitle:@"Open Web App" action:@selector(openWebApp:) keyEquivalent:@""];
  
  [self.menu addItemWithTitle:@"Log In" action:@selector(logIn:) keyEquivalent:@""];
  [self.menu addItem:[NSMenuItem separatorItem]];
  [self.menu addItemWithTitle:@"Quit" action:@selector(terminate:) keyEquivalent:@""];
  [self.menu addItemWithTitle:@"hi kelvin Project" action:@selector(terminate:) keyEquivalent:@"" ];
  self.statusItem.menu = self.menu;
  
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
  NSSortDescriptor *sortKeys = [[NSSortDescriptor alloc] initWithKey:(id)kMDItemFSCreationDate
                                                          ascending:YES];
  [self.metadataSearch setSortDescriptors:[NSArray arrayWithObject:sortKeys]];
  
  // Begin the asynchronous query
  
  NSLog(@"Starting query!");
  [self.metadataSearch startQuery];
  
  
  NSURL *baseUrl = [NSURL URLWithString:API_BASE_URL];
  self.manager = [[AFHTTPRequestOperationManager manager] initWithBaseURL:baseUrl];
  
}

- (void)logIn:(id)sender
{
  NSLog(@"Show login");
  if (!self.logInWindowController) {
    NSLog(@"making contrlller");
    self.logInWindowController = [[LoginWindowController alloc] init];
  }
  [self.logInWindowController showWindow:nil];
  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
  //  [self.logInWindowController showWindowWithCompletionHandler:^(NSURLCredential *credential){
  //    [[KMFeedbinCredentialStorage sharedCredentialStorage] setCredential:credential];
  //    [self getUnreadEntries:self];
  //    [self setupMenu];
  //  }];
  //  [[NSApplication sharedApplication] activateIgnoringOtherApps:YES];
}

- (void)loggedIn:(NSDictionary *)user
{
  self.user = user;
  NSLog(@"Logged in as %@", [user objectForKey:@"name"]);
  //  [self setupMenu];
  [self.menu removeItemAtIndex:0];
  [self.menu insertItemWithTitle:@"Open Web App" action:@selector(openWebApp:) keyEquivalent:@"" atIndex:0];
//  [self.menu insertItem:[NSMenuItem separatorItem] atIndex:1];
  
  //  [self.menu insertItem:[NSMenuItem separatorItem] atIndex:3];
  //  [menu addItemWithTitle:@"Refresh" action:@selector(getUnreadEntries:) keyEquivalent:@""];
  //  if ([[[KMFeedbinCredentialStorage sharedCredentialStorage] credential] hasPassword]) {
  //    [menu addItemWithTitle:@"Log Out" action:@selector(logOut:) keyEquivalent:@""];
  //  } else {
  //    [menu addItemWithTitle:@"Log In" action:@selector(logIn:) keyEquivalent:@""];
  //  }
  //  [self.menu addItem:[NSMenuItem separatorItem]];
  //  [self.menu addItem:[NSMenuItem separatorItem]];
  
  //  [self setupProjects];
}

- (void)openWebApp:(id)sender
{
  NSString *urlString = [NSString stringWithFormat:@"%@me/collections", BASE_URL];
  NSURL *URL = [NSURL URLWithString:urlString];
  
  [[NSWorkspace sharedWorkspace] openURL:URL];
}

// Method invoked when notifications of content batches have been received
- (void)queryDidUpdate:sender;
{
  NSLog(@"A data batch has been received");
  
  [self.metadataSearch disableUpdates];
  
//  NSUInteger i=0;
//  for (i=0; i < [self.metadataSearch resultCount]; i++) {
//    NSMetadataItem *theResult = [self.metadataSearch resultAtIndex:i];
//    NSString *displayName = [theResult valueForAttribute:(NSString *)kMDItemDisplayName];
//    NSLog(@"result at %lu - %@",i,displayName);
//  }
  

  NSMetadataItem *newestScreenshot = [self.metadataSearch resultAtIndex:([self.metadataSearch resultCount] - 1)];
  NSString *path = [newestScreenshot valueForAttribute:(NSString *)kMDItemPath];
  NSString *fileName = [newestScreenshot valueForAttribute:(NSString *)kMDItemFSName];
  NSLog(@"result at %@", path);
  
  NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@me/screenshots", API_BASE_URL] parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
    [formData appendPartWithFileURL:[NSURL fileURLWithPath:path] name:@"file" fileName:fileName mimeType:@"image/jpeg" error:nil];
  } error:nil];
  
  AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
  NSProgress *progress = nil;
  
  NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
    if (error) {
      NSLog(@"Error: %@", error);
    } else {
      NSString *urlString = [NSString stringWithFormat:@"%@%@", COLLECTION_BASE_URL, [responseObject objectForKey:@"id"]];
      NSURL *URL = [NSURL URLWithString:urlString];
      
      [[NSWorkspace sharedWorkspace] openURL:URL];
    }
  }];
  [uploadTask resume];

  
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
//  NSUInteger i=0;
//  for (i=0; i < [self.metadataSearch resultCount]; i++) {
//    NSMetadataItem *theResult = [self.metadataSearch resultAtIndex:i];
//    NSString *displayName = [theResult valueForAttribute:(NSString *)kMDItemDisplayName];
//    NSLog(@"result at %lu - %@",i,displayName);
//  }
  


  
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
