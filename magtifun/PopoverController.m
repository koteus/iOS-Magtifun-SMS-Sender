//
//  PopoverController.m
//  magtifun
//
//  Created by Sergo Beruashvili on 12/16/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import "PopoverController.h"
#import "AppDelegate.h"
#import "NSData+AESCrypt.h"

@implementation PopoverController

-(void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.loadingIndicator stopAnimating];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"username"];
    if(user) {
        [self.textFieldUsername setText:user];
        NSData *p = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
        NSData *decrypted = [p AES256DecryptWithKey:[AppDelegate getGlobalKey]];
        [self.textFieldPassword setText:[[NSString alloc] initWithData:decrypted encoding:NSUTF8StringEncoding]];
    }
}

- (IBAction)login:(id)sender {
    [self.loadingIndicator startAnimating];
    [self.delegate popoverDidPressLogin:self.textFieldUsername.text andPassword:self.textFieldPassword.text];
}

- (IBAction)clearData:(id)sender {
    [self.textFieldUsername setText:@""];
    [self.textFieldPassword setText:@""];
    [self.delegate popoverDidPressClear];
}



- (void)viewDidUnload {
    [self setContainerView:nil];
    [self setTextFieldUsername:nil];
    [self setTextFieldPassword:nil];
    [self setLoadingIndicator:nil];
    [super viewDidUnload];
}
@end
