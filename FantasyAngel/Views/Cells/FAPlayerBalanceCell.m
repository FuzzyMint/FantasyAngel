//
//  FAPlayerBalanceCell.m
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/21/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import "FAPlayerBalanceCell.h"
#import "FAUser.h"

@implementation FAPlayerBalanceCell

@synthesize user = _user;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.textColor = [UIColor darkGrayColor];
    self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
    self.detailTextLabel.numberOfLines = 0;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return self;
}

- (void)setUser:(FAUser *) user {
    _user = user;
    
    self.textLabel.text = self.user.name;
    self.detailTextLabel.text = [NSString stringWithFormat:@"Total Invested: %d, Balance: %d", 200000-self.user.balance, self.user.balance];
    [self.imageView setImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
    [self setNeedsLayout];
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(10.0f, 10.0f, 50.0f, 50.0f);
    self.textLabel.frame = CGRectMake(70.0f, 10.0f, 240.0f, 20.0f);
    [self.detailTextLabel sizeToFit];
    self.detailTextLabel.frame = CGRectMake(self.textLabel.frame.origin.x, self.textLabel.frame.origin.y + self.textLabel.frame.size.height + 4, self.detailTextLabel.frame.size.width, self.detailTextLabel.frame.size.height);
}

@end