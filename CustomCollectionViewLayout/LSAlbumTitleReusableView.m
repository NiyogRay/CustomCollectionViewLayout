//
//  LSAlbumTitleReusableView.m
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import "LSAlbumTitleReusableView.h"

@interface LSAlbumTitleReusableView ()

@property (nonatomic, strong, readwrite) UILabel *titleLabel;

@end

@implementation LSAlbumTitleReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        
        self.titleLabel.backgroundColor = [UIColor clearColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont boldSystemFontOfSize:13.];
        self.titleLabel.textColor = [UIColor colorWithWhite:1. alpha:1.];
        self.titleLabel.shadowColor = [UIColor colorWithWhite:0. alpha:.3];
        self.titleLabel.shadowOffset = CGSizeMake(0., 1.);
        
        [self addSubview:self.titleLabel];
    }
    return self;
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.titleLabel.text = nil;
}

@end
