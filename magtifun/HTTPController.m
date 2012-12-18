//
//  HTTPController.m
//  magtifun
//
//  Created by Sergo Beruashvili on 12/17/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import "HTTPController.h"
#import "AppDelegate.h"
#import "NSData+AESCrypt.h"

@implementation HTTPController


-(void)login:(NSString *)username andPassword:(NSString *)password {
    
    // building request data
    NSString *up = [[NSString alloc] initWithFormat:@"user=%@&password=%@&act=1&remember=on" , username , password ];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.magtifun.ge/index.php?page=11&lang=ge"] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    [request addValue:@"" forHTTPHeaderField:@"Cookie"];
    [request setHTTPBody:[up dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLResponse* response;
    
    NSError* error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [AppDelegate getResult:error.localizedDescription];
            [self.delegate updateStatus:@"Connection Error"];
            [self.delegate updateSMSCount:nil];
        });
        return;
    }
    
    up = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    if([up rangeOfString:@"Sent Messages"].location == NSNotFound) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [AppDelegate getResult:@"მომხმარებელი ან პაროლი არასწორია"];
            [self.delegate updateStatus:@"Incorrect Username/Password"];
            [self.delegate updateSMSCount:nil];
        });
        return;
        
    } else {
        
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:username forKey:@"username"];
        
        NSData *encrypted = [[password dataUsingEncoding:NSUTF8StringEncoding] AES256EncryptWithKey:[AppDelegate getGlobalKey]];
        
        [defaults setObject:encrypted forKey:@"password"];
        
        [defaults synchronize];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [AppDelegate getResult:@"Logged in"];
            [self.delegate updateStatus:@"Logged in"];
            [self.delegate updateSMSCount:nil];            
        });
        return;       
        
    }
    
}




-(void)send:(NSString *)message :(NSString *)number {
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString  *user = [defaults valueForKey:@"username"];
    
    if(user == nil) {        
        dispatch_async(dispatch_get_main_queue(), ^{
            [AppDelegate getResult:@"მომხმარებელი და პაროლი არ არის შევსებული"];
            [self.delegate updateStatus:@""];
            [self.delegate notLoggedIn];
        });        
        return;
    }
    
    NSData *password = [defaults valueForKey:@"password"];
    
    NSString *p = [[NSString alloc]  initWithData:[password AES256DecryptWithKey:[AppDelegate getGlobalKey]] encoding:NSUTF8StringEncoding];
    
    NSString *up = [[NSString alloc] initWithFormat:@"user=%@&password=%@&act=1" , user , p];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.magtifun.ge/index.php?page=11&lang=ge"] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"" forHTTPHeaderField:@"Cookie"];
    [request setHTTPBody:[up dataUsingEncoding:NSUTF8StringEncoding]];
    NSURLResponse* response;
    
    NSError* error = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [AppDelegate getResult:error.localizedDescription];
            [self.delegate updateStatus:@""];
        });
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate updateStatus:@"Sending..."];
    });
    
    error = nil;
    
    up = [[NSString alloc] initWithFormat:@"message_body=%@&recipients=%@",message,number ];
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.magtifun.ge/scripts/sms_send.php"] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    //[request addValue:cookies forHTTPHeaderField:@"Cookie"];
    [request setHTTPBody:[up dataUsingEncoding:NSUTF8StringEncoding]];
    
    error = nil;
    NSData * result =  [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [AppDelegate getResult:error.localizedDescription];
            [self.delegate updateStatus:@""];
        });
        
        return;
    }
    
    NSString *resulttext = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.delegate updateStatus:resulttext];
        
        if(![resulttext isEqualToString:@"success"]) {
            return;
        }
        
    });
    
    request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://www.magtifun.ge/index.php?page=2&lang=ge"] cachePolicy:NSURLCacheStorageNotAllowed timeoutInterval:10];    
    
    result = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    up = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
    
    NSRegularExpression * regex = [NSRegularExpression regularExpressionWithPattern:@"<span class=\"xxlarge dark english\">(.*?)</span>" options:NSRegularExpressionCaseInsensitive error:&error];
    
    
    NSTextCheckingResult* firstMatch = [regex firstMatchInString:up options:0 range:NSMakeRange(0, [up length])];
    
    NSString *left = [up substringWithRange:[firstMatch rangeAtIndex:1]];
    
    if(firstMatch != nil)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            if(left != nil) {
                [self.delegate updateSMSCount:left];
            } else {
                [self.delegate updateSMSCount:[[NSString alloc] init]];
            }
            
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{            
            [self.delegate updateSMSCount:[[NSString alloc] init]];
        });
    }
    

    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    
}



@end
