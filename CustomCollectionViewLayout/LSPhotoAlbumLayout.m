//
//  LSPhotoAlbumLayout.m
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import "LSPhotoAlbumLayout.h"

@implementation LSPhotoAlbumLayout

#pragma mark - Lifecycle

- (id)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}


- (void)setup
{
    self.itemInsets = UIEdgeInsetsMake(22., 22., 13., 22.);
    self.itemSize = CGSizeMake(125., 125.);
    self.interItemSpacingY = 12.;
    self.numberOfColumns = 2;
}

@end
