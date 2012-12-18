//
//  PopoverController.h
//  magtifun
//
//  Created by Sergo Beruashvili on 12/16/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PopoverControllerDelegate
// Pressed Login button
-(void)popoverDidPressLogin:(NSString *)username andPassword:(NSString *)password;
// Pressed Clear button
-(void)popoverDidPressClear;
@end

@interface PopoverController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *textFieldUsername;
@property (weak, nonatomic) IBOutlet UITextField *textFieldPassword;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (nonatomic,strong) id<PopoverControllerDelegate> delegate;


- (IBAction)login:(id)sender;
- (IBAction)clearData:(id)sender;


@end
