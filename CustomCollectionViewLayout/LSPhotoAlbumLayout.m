//
//  LSPhotoAlbumLayout.m
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import "LSPhotoAlbumLayout.h"

/// layout cell kind
static const NSString *LSPhotoAlbumLayoutPhotoCellKind = @"PhotoCell";

/// Private interface
@interface LSPhotoAlbumLayout ()

/// layout info dictionary
@property (nonatomic, strong) NSDictionary *layoutInfo;

@end

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


#pragma mark - Layout

- (void)prepareLayout
{
    // cell layout info
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    
    // sectionCount
    NSInteger sectionCount = [self.collectionView numberOfSections];
    
    // per section
    for (NSInteger section = 0; section < sectionCount; section++)
    {
        NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        
        // per item
        for (NSInteger item = 0; item < itemCount; item++)
        {
            // apply attributes
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:0];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
            
            // store attributes by indexPath
            cellLayoutInfo[indexPath] = itemAttributes;
        }
    }
    
    // store layout info by cell kind
    newLayoutInfo[LSPhotoAlbumLayoutPhotoCellKind] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
}


#pragma mark - Cell Frame as per Layout

- (CGRect)frameForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    // find item's row & column for multicolumn section
    NSInteger row = indexPath.section / self.numberOfColumns;
    NSInteger column = indexPath.section % self.numberOfColumns;
    
    // spacingX
    CGFloat spacingX = self.collectionView.bounds.size.width - self.itemInsets.left - self.itemInsets.right - (self.numberOfColumns * self.itemSize.width);
    
    // spacingX for multicolumn
    if (self.numberOfColumns > 1)
        spacingX /= (self.numberOfColumns - 1);
    
    // origins
    CGFloat originX = floor(self.itemInsets.left + self.itemSize.width + spacingX);
    CGFloat originY = floor((self.itemInsets.top  + self.interItemSpacingY) * row);
    
    // frame
    CGRect cellFrame = CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
    
    return cellFrame;
}


@end
