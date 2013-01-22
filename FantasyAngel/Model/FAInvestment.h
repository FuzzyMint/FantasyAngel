//
//  FAInvestment.h
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/18/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FAStartup;

@interface FAInvestment : NSObject

@property (nonatomic, assign) NSInteger amount;

@property (nonatomic, assign) NSInteger startup_id;

@property (nonatomic, strong) NSString *username;

@property (nonatomic, strong) NSString *startupname;

@end
