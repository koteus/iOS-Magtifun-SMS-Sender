//
//  ViewController.h
//  magtifun
//
//  Created by Sergo Beruashvili on 12/16/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "UIPopoverController+iPhone.h"
#import "PopoverController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "HTTPController.h"

@interface ViewController : UIViewController <ADBannerViewDelegate , UIScrollViewDelegate , UITextViewDelegate , PopoverControllerDelegate , ABPeoplePickerNavigationControllerDelegate , HTTPControllerDelegate >

@property (strong, nonatomic) IBOutlet UIScrollView *scrollViewMain;
@property (weak, nonatomic) IBOutlet UITextField *numberField;
@property (weak, nonatomic) IBOutlet UITextView *messageField;
@property (weak, nonatomic) IBOutlet ADBannerView *adBannerView;
@property (nonatomic,strong) UIPopoverController *pop;
@property (nonatomic,strong) UIBarButtonItem *countLabel;
@property (weak, nonatomic) IBOutlet UIView *containerView;
@property (weak, nonatomic) IBOutlet UIView *subContainer;
@property (weak, nonatomic) IBOutlet UIButton *settingsButton;

@property (readwrite) int lastTag;

@property(nonatomic,strong) NSString * number1;
@property(nonatomic,strong) NSString * number2;
@property(nonatomic,strong) NSString * number3;

@property(nonatomic,strong) UIButton * number1Button;
@property(nonatomic,strong) UIButton * number2Button;
@property(nonatomic,strong) UIButton * number3Button;

@property (nonatomic,strong) ABPeoplePickerNavigationController *picker;
@property (weak, nonatomic) IBOutlet UILabel *resultLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;

@property (nonatomic,strong) HTTPController *http;


-(IBAction)sendSms;
- (IBAction)getSettings:(id)sender;


@end
