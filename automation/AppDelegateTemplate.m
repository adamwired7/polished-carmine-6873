//
//  AppDelegate.m
//  sdktest
//
//  Created by Brad Smith on 2/15/13.
//  Copyright (c) 2013 Brad Smith. All rights reserved.
//

#import "AppDelegate.h"
#import "DemoViewcontrollerViewController.h"
@implementation AppDelegate

- (void)dealloc
{
  [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  UIUserInterfaceIdiom uii = [[UIDevice currentDevice] userInterfaceIdiom];
  UIViewController  *vc = nil;
  
  if(uii == UIUserInterfaceIdiomPhone)
  {
    vc = [[DemoViewcontrollerViewController alloc] initWithNibName:nil bundle:nil];
  }
  else if(uii == UIUserInterfaceIdiomPad)
  {
    vc = [[DemoViewcontrollerViewController alloc] initWithNibName:nil bundle:nil];
  }
  
  CGRect itemRect = [[UIScreen mainScreen] bounds];
    
  self.window = [[[UIWindow alloc] initWithFrame:itemRect] autorelease];
  // Override point for customization after application launch.
  self.window.backgroundColor = [UIColor whiteColor];
  [self.window makeKeyAndVisible];
  
  self.window.rootViewController = vc;
  
  // To control config
  QA_LINE_A
  
  // [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:R1CropModeSquare] forKey:@"R1ExclusiveCropMode"];
  
  // [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"R1ExclusiveCropMode"];
  
  // To control config
  QA_LINE_B
  
  //NSArray *customTabs = @[R1TabEffects];
  // [[NSUserDefaults standardUserDefaults] setObject:customTabs forKey:@"R1TabSetupList"];
  
  
  [vc release];
  
  return YES;
}

@end
