//
//  FAStartupCell.h
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/18/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FAStartup;

@interface FAStartupCell : UITableViewCell

@property (nonatomic, strong) FAStartup *startup;

+ (CGFloat)heightForCellWithPost:(FAStartup *)startup;

@end
