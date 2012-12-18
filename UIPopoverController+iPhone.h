//
//  UIPopoverController+iPhone.h
//  magtifun
//
//  Created by Sergo Beruashvili on 12/16/12.
//  Copyright (c) 2012 Sergo Beruashvili. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPopoverController (iPhone)
// override for iPhone , otherwise popover wont show up
+(BOOL)_popoversDisabled;
@end
