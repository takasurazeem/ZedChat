//
//  InstalledAppReader.h
//  ZedChat
//
//  Created by MacBook Pro on 12/06/2019.
//  Copyright © 2019 MacBook Pro. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface InstalledAppReader : UIViewController
-(NSArray *)installedApp;

@end
@interface InstalledAppReader()

-(NSArray *)installedApp;
-(NSMutableDictionary *)appDescriptionFromDictionary:(NSDictionary *)dictionary;

@end
NS_ASSUME_NONNULL_END
