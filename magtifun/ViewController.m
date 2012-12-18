//
//  ViewController.m
//  magtifun
//
//  Created by Sergo Beruashvili on 12/16/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import "ViewController.h"
#import "HTTPController.h"
#import "AppDelegate.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize http = _http;

#pragma mark -

#pragma mark Generated Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.adBannerView.delegate = self;    
    
    self.scrollViewMain.scrollEnabled = YES;
    [self.scrollViewMain setContentSize:CGSizeMake(self.scrollViewMain.frame.size.width, self.containerView.frame.origin.y + self.containerView.frame.size.height + 60)];
    
    UIToolbar *keyBoardToolBar = [[UIToolbar alloc] init];
    keyBoardToolBar.barStyle = UIBarStyleBlack;
    keyBoardToolBar.tintColor = [UIColor blackColor];
    keyBoardToolBar.opaque = YES;
    [keyBoardToolBar sizeToFit];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *sendButton = [[UIBarButtonItem alloc] initWithTitle:@"გაგზავნა" style:UIBarButtonItemStyleBordered target:self action:@selector(sendSms)];
    UIBarButtonItem *clearButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(clearMessageTextView)];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard)];
    
    self.countLabel = [[UIBarButtonItem alloc] initWithTitle:@"0" style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.countLabel.tintColor = [UIColor blueColor];
    self.countLabel.enabled = NO;

    
    keyBoardToolBar.items = [NSArray arrayWithObjects:sendButton,space,clearButton, space,self.countLabel, space,doneButton , nil];
    
    self.messageField.inputAccessoryView = keyBoardToolBar;
    self.messageField.delegate = self;
    
    
    UIButton *numberFieldLeftButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [numberFieldLeftButton addTarget:self action:@selector(getContact:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.numberField.leftView = numberFieldLeftButton;
    self.numberField.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *numberFieldRightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    [numberFieldRightButton addTarget:self action:@selector(addNumberWithCurrentField) forControlEvents:UIControlEventTouchUpInside];
    
    self.numberField.rightView = numberFieldRightButton;
    self.numberField.rightViewMode = UITextFieldViewModeAlways;
    
    UIToolbar *numberFieldToolbar = [[UIToolbar alloc] init];
    numberFieldToolbar.barStyle = UIBarStyleBlack;
    numberFieldToolbar.tintColor = [UIColor blackColor];
    numberFieldToolbar.opaque = YES;
    [numberFieldToolbar sizeToFit];
    
    UIBarButtonItem *doneButton2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(hideKeyboard)];
    
    numberFieldToolbar.items = @[space,doneButton2];
    self.numberField.inputAccessoryView = numberFieldToolbar;
    
    
    self.number1Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.number1Button.tag = 101;
    
    
    
    CGRect numberFieldRect = self.numberField.frame;
    
    
    
    [self.number1Button addTarget:self action:@selector(removeSelectedContact:) forControlEvents:UIControlEventTouchUpInside];
    self.number1Button.frame = CGRectMake(numberFieldRect.origin.x,numberFieldRect.origin.y - numberFieldRect.size.height - 5, (numberFieldRect.size.width / 3 - 10)  , numberFieldRect.size.height);
    
    
    self.number2Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.number2Button.tag = 102;
    [self.number2Button addTarget:self action:@selector(removeSelectedContact:) forControlEvents:UIControlEventTouchUpInside];
    self.number2Button.frame = CGRectMake(numberFieldRect.origin.x + (numberFieldRect.size.width / 3 - 10 ) + 10,numberFieldRect.origin.y - numberFieldRect.size.height - 5, (numberFieldRect.size.width / 3 - 10)  , numberFieldRect.size.height);
    
    
    self.number3Button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.number3Button.tag = 103;
    [self.number3Button addTarget:self action:@selector(removeSelectedContact:) forControlEvents:UIControlEventTouchUpInside];
    self.number3Button.frame = CGRectMake(numberFieldRect.origin.x + ((numberFieldRect.size.width / 3 - 10 ) + 10 ) * 2,numberFieldRect.origin.y - numberFieldRect.size.height - 5, (numberFieldRect.size.width / 3 - 10)  , numberFieldRect.size.height);
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setAdBannerView:nil];
    [self setNumberField:nil];
    [self setMessageField:nil];
    [self setScrollViewMain:nil];
    [self setContainerView:nil];
    [self setSubContainer:nil];
    [self setResultLabel:nil];
    [self setSettingsButton:nil];
    [self setLoadingIndicator:nil];
    [super viewDidUnload];
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    
    return toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown;

}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    [self bannerOrient:toInterfaceOrientation];
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    
    CGRect r = self.containerView.frame;
    r.origin.y = self.messageField.frame.origin.y + self.messageField.frame.size.height + 8;
    self.containerView.frame = r;
    [self.scrollViewMain setContentSize:CGSizeMake(320, self.containerView.frame.origin.y + self.containerView.frame.size.height + 60)];
    
    if(self.pop && [self.pop isPopoverVisible]){
        [self.pop dismissPopoverAnimated:YES];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.loadingIndicator stopAnimating];
}

-(HTTPController *)http {

    if(_http == nil){
        _http = [[HTTPController alloc] init];
        _http.delegate = self;
    }

    return _http;
}

#pragma mark Banner View Methods

-(void)bannerOrient:(UIInterfaceOrientation)orientation {
    
    if(UIInterfaceOrientationIsLandscape(orientation)) {
        self.adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
    } else {
        self.adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierPortrait];
    }
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {

    if(!banner.hidden) {
        banner.hidden = YES;
        
        CGRect r = self.subContainer.frame;
        r.origin.y = banner.frame.origin.y;
        self.subContainer.frame = r;

    }
    
}

-(void)bannerViewWillLoadAd:(ADBannerView *)banner {
    
    if(banner.hidden) {
        banner.hidden = NO;
        
        CGRect r = self.subContainer.frame;
        r.origin.y = banner.frame.origin.y + banner.frame.size.height + 5;
        self.subContainer.frame = r;
        
    }
    
}


#pragma mark Keyboard & TextField Methods

-(void)hideKeyboard {
    
    if([self.numberField isFirstResponder]) {
        [self.numberField resignFirstResponder];
    } else if([self.messageField isFirstResponder]) {
        [self.messageField resignFirstResponder];
    }
    
}

-(void)clearMessageTextView {
    [self.messageField setText:@""];
    [self updateLabelCount];
}

-(void)updateLabelCount {
    self.countLabel.title = [NSString stringWithFormat:@"%i", [self.messageField.text length] ];
}

-(void)textViewDidChange:(UITextView *)textView {
    [self updateLabelCount];
}

#pragma mark Button Methods

-(IBAction)sendSms {
    
    [self hideKeyboard];
    
    self.resultLabel.text = @"გთხოვთ მოითმინოთ...";
    
    NSString * number = nil;
    
    if([self.numberField.text length] > 8) {
        number = self.numberField.text;
    }
    
    if(self.number1 != nil) {
        if(number == nil) {
            number = self.number1;
        } else {
            number = [number stringByAppendingFormat:@",%@",self.number1];
        }
    }
    
    if(self.number2 != nil) {
        if(number == nil) {
            number = self.number2;
        } else {
            number = [number stringByAppendingFormat:@",%@",self.number2];
        }
    }
    
    if(self.number3 != nil) {
        if(number == nil) {
            number = self.number3;
        } else {
            number = [number stringByAppendingFormat:@",%@",self.number3];
        }
    }
    
    NSArray *listItems = [number componentsSeparatedByString:@","];
    
    if([listItems count] > 3) {
        [AppDelegate getResult:@"მაქსიმუმ 3 მიმღები!"];
        self.resultLabel.text = @"";
        return;
    }
    
    if(number.length < 9 || self.messageField.text.length < 1) {
        [AppDelegate getResult:@"მინიმუმ 1 მიმღები!"];
        self.resultLabel.text = @"";        
        return;
    }
    
    NSString *message = self.messageField.text;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.loadingIndicator startAnimating];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.http send:message :number];
    });
    
}

- (IBAction)getSettings:(id)sender {
    
    if(self.pop == nil) {
    
        self.pop = [[UIPopoverController alloc] initWithContentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"PopoverController"]];
        CGSize viewSize = ((PopoverController *)self.pop.contentViewController).containerView.frame.size;
        
        
        if(viewSize.width == 280) {
            viewSize.width = 300;
        }
        
        ((PopoverController *)self.pop.contentViewController).delegate = self;
        
        [self.pop setPopoverContentSize:viewSize animated:YES];
        
    }
    
    if([self.pop isPopoverVisible]) {
        [self.pop dismissPopoverAnimated:YES];
    } else {
        
        
        CGPoint p = CGPointMake(self.containerView.frame.origin.x + self.subContainer.frame.origin.x
                                + ((UIButton *)sender).frame.origin.x  , self.containerView.frame.origin.y + self.subContainer.frame.origin.y
                                + ((UIButton *)sender).frame.origin.y );

        CGFloat diff = p.y - self.scrollViewMain.contentOffset.y;
        
        if( diff < 205 ) {
            [self.scrollViewMain setContentOffset:CGPointMake(0, p.y - 205 ) animated:NO];
        }
        
        [self.pop presentPopoverFromRect:((UIButton *)sender).frame
                              inView:((UIButton *)sender).superview
                            permittedArrowDirections:UIPopoverArrowDirectionDown
                            animated:YES];
        
    }
    
}


-(void)removeSelectedContact:(UIButton *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"შეტყობინება"
                          message:@"ნამდვილად გსურთ ნომრის წაშლა?"
                          delegate:self
                          cancelButtonTitle:@"არა"
                          otherButtonTitles: @"დიახ" , nil];
    alert.tag = 2;
    [alert show];
    
    self.lastTag = sender.tag;
    
}




- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if(alertView.tag == 2) {
    
        if (buttonIndex == 1) {
            if(self.lastTag == 101) {
                self.number1 = nil;
            } else if (self.lastTag == 102) {
                self.number2 = nil;
            } else if (self.lastTag == 103) {
                self.number3 = nil;
            }
            [self drawNumberButtons];
        }
        
    }
    
    
}

-(void)drawNumberButtons {
    
    
    if(self.number1 != nil) {
        [self.number1Button setTitle:self.number1 forState:UIControlStateNormal];
        [self.view addSubview:self.number1Button];
        
    } else {
        [self.number1Button removeFromSuperview];
    }
    
    if(self.number2 != nil) {
        [self.number2Button setTitle:self.number2 forState:UIControlStateNormal];
        [self.view addSubview:self.number2Button];
        
    } else {
        [self.number2Button removeFromSuperview];
    }
    
    if(self.number3 != nil) {
        [self.number3Button setTitle:self.number3 forState:UIControlStateNormal];
        [self.view addSubview:self.number3Button];
    } else {
        [self.number3Button removeFromSuperview];
    }
    
    
    if ( [self.numberField isFirstResponder] ) {
        [self.numberField resignFirstResponder];
    }
    
    
}

#pragma mark Popover Delegate

-(void)popoverDidPressLogin:(NSString *)username andPassword:(NSString *)password {
    
    [self.loadingIndicator startAnimating];

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self.http login:username andPassword:password];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pop dismissPopoverAnimated:YES];
        });
        
    });
}

-(void)popoverDidPressClear {
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:@"username"];
    [def removeObjectForKey:@"password"];
    [def synchronize];
    
    [self.pop dismissPopoverAnimated:YES];
}

#pragma mark HTTPControllerDelegate
-(void)updateStatus:(NSString *)status {
    [self.resultLabel setText:status];
}

-(void)updateSMSCount:(NSString *)count {
    [self.loadingIndicator stopAnimating];
    if(count != nil) {
        [self.resultLabel setText:[NSString stringWithFormat:@"%@,დარჩენილია %@ SMS",self.resultLabel.text,count]];
    }
}

-(void)notLoggedIn {
    [self.loadingIndicator stopAnimating];
    [self.settingsButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

#pragma mark CallBack Methods


-(void)setRecipientWithNumber:(NSString *)number {
    
    NSError * error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\D" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString * sanitized_number = [regex stringByReplacingMatchesInString:number options:0 range:NSMakeRange(0, [number length]) withTemplate:@""];
    
    if([sanitized_number length] < 9) {
        [AppDelegate getResult:@"ნომერი არასწორია!"];
        return;
    }
    
    if(self.number1 == nil) {
        self.number1 = sanitized_number;
    } else if (self.number2 == nil) {
        self.number2 = sanitized_number;
    } else if (self.number3 == nil) {
        self.number3 = sanitized_number;
    } else {
        [AppDelegate getResult:@"შესაძლებელია მხოლოდ 3 მიმღები!"];
        return;
    }    
    
    [self drawNumberButtons];
    [self.numberField setText:@""];
    
}

-(void)addNumberWithCurrentField{
    
    NSError * error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"\\D" options:NSRegularExpressionCaseInsensitive error:&error];
    NSString * sanitized_number = [regex stringByReplacingMatchesInString:self.numberField.text options:0 range:NSMakeRange(0, [self.numberField.text length]) withTemplate:@""];
    
    if([sanitized_number length] < 9) {
        [AppDelegate getResult:@"ნომერი არასწორია!"];
        return;
    }
    
    [self setRecipientWithNumber:sanitized_number];
}




#pragma mark Address Book Functions
-(void)getContact:(id)sender{
    
    if(self.picker == nil) {
        self.picker = [[ABPeoplePickerNavigationController alloc] init];        
        self.picker.peoplePickerDelegate = self;
    }

    [self presentModalViewController:self.picker animated:YES];
    
}


-(BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    return YES;
    
}

-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    
    [self dismissModalViewControllerAnimated:YES];
    
}


- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    
    ABMultiValueRef multi = ABRecordCopyValue(person, property);
    
    NSString * tempNumber = (__bridge_transfer NSString*)ABMultiValueCopyValueAtIndex(multi,ABMultiValueGetIndexForIdentifier(multi, identifier));
    
    [self setRecipientWithNumber:tempNumber];
    [self dismissModalViewControllerAnimated:YES];
    
    if(multi) {
        CFRelease(multi);
    }
    
    return NO;
    
}


@end
