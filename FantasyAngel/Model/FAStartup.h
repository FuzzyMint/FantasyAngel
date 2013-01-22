//
//  FAStartup.h
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/18/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FAStartup : NSObject


/**
 * The unique ID of this startup
 */
@property (nonatomic, copy) NSNumber *id;

/**
 * Name of startup
 */
@property (nonatomic, copy) NSString *name;

/**
 * High concept of this startup
 */
@property (nonatomic, copy) NSString *high_concept;

/**
 * Full description of the startup
 */
@property (nonatomic, copy) NSString *product_desc;

/**
 * Startup Logo
 */
@property (nonatomic, copy) NSString *logo_url;

/**
 * Startup Thumbnail Logo
 */
@property (nonatomic, copy) NSString *thumb_url;

@end
