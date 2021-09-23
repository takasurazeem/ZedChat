//
//  InstalledAppReader.m
//  ZedChat
//
//  Created by MacBook Pro on 12/06/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

#import "InstalledAppReader.h"
static NSString* const installedAppListPath = @"/private/var/mobile/Library/Caches/com.apple.mobile.installation.plist";



@implementation InstalledAppReader

- (void)viewDidLoad{
    [self installedApp];
    
    
   

}
#pragma mark - Init
-(NSMutableArray *)desktopAppsFromDictionary:(NSDictionary *)dictionary
{
    NSMutableArray *desktopApps = [NSMutableArray array];
    
    for (NSString *appKey in dictionary)
    {
        [desktopApps addObject:appKey];
    }
    return desktopApps;
}

-(NSArray *)installedApp
{
    
    
    BOOL isDir = NO;
    NSDictionary *cacheDienter;
    NSDictionary *user;
    static NSString *const cacheFileName = @"";
    
    NSString *relativeCachePath = [[@"Library" stringByAppendingPathComponent: @"Caches"] stringByAppendingPathComponent: cacheFileName];
    NSString *path = [[NSHomeDirectory() stringByAppendingPathComponent: @"../.."] stringByAppendingPathComponent: relativeCachePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath: path isDirectory: &isDir] && !isDir) // Ensure that file exists
    {
        cacheDienter    = [NSDictionary dictionaryWithContentsOfFile: path];
        user = [cacheDienter objectForKey: @"System"];
        NSLog(@"%@",user);
        // Then all the user (App Store /var/mobile/Applications) apps
    }
    ///
    NSArray *appFolderContents = [[NSFileManager defaultManager] directoryContentsAtPath:@"/Applications"];

    
    
    /////////
    //BOOL isDir = NO;
    if([[NSFileManager defaultManager] fileExistsAtPath: installedAppListPath isDirectory: &isDir] && !isDir)
    {
        NSMutableDictionary *cacheDict = [NSDictionary dictionaryWithContentsOfFile: installedAppListPath];
        NSDictionary *system = [cacheDict objectForKey: @"System"];
        NSMutableArray *installedApp = [NSMutableArray arrayWithArray:[self desktopAppsFromDictionary:system]];
        
        NSDictionary *user = [cacheDict objectForKey: @"User"];
        [installedApp addObjectsFromArray:[self desktopAppsFromDictionary:user]];
        
        return installedApp;
    }
    
    NSLog(@"can not find installed app plist");
    return nil;
}

@end


