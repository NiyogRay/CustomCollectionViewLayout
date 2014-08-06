//
//  LSAlbumPhotoCell.m
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import "LSAlbumPhotoCell.h"
#import <QuartzCore/QuartzCore.h>

@interface LSAlbumPhotoCell ()

// Redefine as readwrite privately
@property (nonatomic, strong, readwrite) UIImageView *imageView;

@end

@implementation LSAlbumPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}


- (void)setup
{
    // bgColor
    self.backgroundColor = [UIColor colorWithWhite:.85 alpha:1.];
    
    // border
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.layer.borderWidth = 1.;
    // shadow
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowRadius = 3.;
    self.layer.shadowOffset = CGSizeMake(0., 2.);
    self.layer.shadowOpacity = .5;
    // imageView
    self.imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
}

// Reset any previous content of cell when reused
- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

@end
