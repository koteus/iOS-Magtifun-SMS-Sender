//
//  AppDelegate.h
//  magtifun
//
//  Created by Sergo Beruashvili on 12/16/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

// Displays alert view with description
+(void)getResult:(NSString *)description;

// get global key for encrypt/decrypt
+(NSString *)getGlobalKey;
@end
