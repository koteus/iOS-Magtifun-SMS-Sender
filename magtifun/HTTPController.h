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

@property (strong,nonatomic) id<HTTPControllerDelegate> delegate;

-(void)login:(NSString *)username andPassword:(NSString *)password;
-(void)send:(NSString *)message :(NSString *)number;

@end
