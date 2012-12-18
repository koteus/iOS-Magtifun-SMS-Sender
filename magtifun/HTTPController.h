//
//  HTTPController.h
//  magtifun
//
//  Created by Sergo Beruashvili on 12/17/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HTTPControllerDelegate
-(void)updateStatus:(NSString *)status;
-(void)updateSMSCount:(NSString *)count;
-(void)notLoggedIn;
@end

@interface HTTPController : NSObject 

// delegate for callback methods
@property (strong,nonatomic) id<HTTPControllerDelegate> delegate;

// tries to log in with user and password , invokes callback methods on delegate
-(void)login:(NSString *)username andPassword:(NSString *)password;

// tries to send message to max 3 number , invokes callback methods on delegate
-(void)send:(NSString *)message :(NSString *)number;

@end
