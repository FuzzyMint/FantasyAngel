//
//  FAInvestmentCell.m
//  FantasyAngel
//
//  Created by Yusuf Sobh on 1/21/13.
//  Copyright (c) 2013 ProductX. All rights reserved.
//

#import "FAInvestmentCell.h"
#import "FAInvestment.h"

@implementation FAInvestmentCell

@synthesize investment = _investment;

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

- (void)setInvestment:(FAInvestment *)investment {
    _investment = investment;
    
    self.textLabel.text = [NSString stringWithFormat:@"%d", self.investment.amount];
    //self.detailTextLabel.text = self.startup.high_concept;
    //[self.imageView setImageWithURL:[NSURL URLWithString:self.startup.thumb_url] placeholderImage:[UIImage imageNamed:@"profile-image-placeholder"]];
    
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

