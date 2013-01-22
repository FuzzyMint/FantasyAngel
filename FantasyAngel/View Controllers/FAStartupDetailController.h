//
//  FAStartupDetailController.h
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/19/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FAStartup;

@protocol FAModalControllerDelegate <UITextFieldDelegate>

@end

@interface FAStartupDetailController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) FAStartup *startup;

- (id) initWithStartup:(FAStartup *) startup;

@end
