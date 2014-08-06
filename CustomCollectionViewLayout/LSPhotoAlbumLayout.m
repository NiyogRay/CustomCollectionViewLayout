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


#pragma mark - Layout Attributes for Items in Rect

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // attributes for cells present in rect
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    // per layout dictionary (ATMO cells')
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSString *elementIdentifier, NSDictionary *elementInfo, BOOL *stop)
    {
        // per cell's layout
        [elementInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath, UICollectionViewLayoutAttributes *attributes, BOOL *innerStop)
        {
            // if cell is in rect
            if (CGRectIntersectsRect(rect, attributes.frame))
            {
                // add cell's attributes to allAttributes
                [allAttributes addObject:attributes];
            }
        }];
    }];
    
    return allAttributes;
}


#pragma mark - Layout Attributes for Item

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // layoutInfo of item kind at indexPath
    return self.layoutInfo[LSPhotoAlbumLayoutPhotoCellKind][indexPath];
}


#pragma mark - Overall ContentSize of CollectionView

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
    
    // add any partially filled row
    if ([self.collectionView numberOfSections] % self.numberOfColumns)
        rowCount++;
    
    // content height
    CGFloat height = self.itemInsets.top + rowCount*(self.itemSize.height) + (rowCount-1)*self.interItemSpacingY + self.itemInsets.bottom;
    
    // content width
    CGFloat width = self.collectionView.bounds.size.width;
    
    CGSize contentSize = CGSizeMake( height, width );
    
    return contentSize;
}


@end
