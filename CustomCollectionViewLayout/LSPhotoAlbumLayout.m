//
//  LSPhotoAlbumLayout.m
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import "LSPhotoAlbumLayout.h"

static NSUInteger const RotationCount = 32;
// use Stride to jump a few rotation values between sections
static NSUInteger const RotationStride = 3;

// zIndex. default is 0 for cells, so their ordering is arbitrary
// Use it to keep cell on top of others.
static NSUInteger const PhotoCellBaseZIndex = 100;

static NSString * const LSPhotoAlbumLayoutPhotoCellKind = @"PhotoCell";

// splitting up the definition & setting
// ensures consumers use the constant, not the specific value
NSString * const LSPhotoAlbumLayoutAlbumTitleKind = @"AlbumTitle";

/// Private interface
@interface LSPhotoAlbumLayout ()

/// layout info dictionary
@property (nonatomic, strong) NSDictionary *layoutInfo;
/// rotations
@property (nonatomic, strong) NSArray *rotations;

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
    // layout
    self.itemInsets = UIEdgeInsetsMake(22.f, 22.f, 13.f, 22.f);
    self.itemSize = CGSizeMake(125., 125.);
    self.interItemSpacingY = 12.;
    self.numberOfColumns = 2;
    self.titleHeight = 26.;
    
    // rotations
    // create rotations at load so that they are consistent during prepareLayout
    
    NSMutableArray *rotations = [NSMutableArray arrayWithCapacity:RotationCount];
    
    CGFloat percentage = 0.;
    
    // per rotation
    for (NSInteger i = 0; i < RotationCount; i++)
    {
        // ensure that each angle is different enough to be seen
        CGFloat newPercentage = 0.;
        do {
            newPercentage = ((CGFloat)(arc4random() % 220) - 110) * 0.0001f;
        } while (fabsf(percentage - newPercentage) < 0.006);
        percentage = newPercentage;
        
        
        CGFloat angle = 2 * M_PI * (1. + percentage);
        CATransform3D transform = CATransform3DMakeRotation(angle, 0., 0., 1.);
        
        NSValue *rotationValue = [NSValue valueWithCATransform3D:transform];
        [rotations addObject:rotationValue];
    }
    
    _rotations = rotations;
}


#pragma mark - Layout

- (void)prepareLayout
{
    // cell layout info
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *cellLayoutInfo = [NSMutableDictionary dictionary];
    NSMutableDictionary *titleLayoutInfo = [NSMutableDictionary dictionary];
    
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
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            UICollectionViewLayoutAttributes *itemAttributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
            
            // frame
            itemAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
            
            // transform
            itemAttributes.transform3D = [self transformForAlbumPhotoAtIndexPath:indexPath];
            
            // zIndex
            itemAttributes.zIndex = PhotoCellBaseZIndex + itemCount - item;
            
            // store attributes by indexPath
            cellLayoutInfo[indexPath] = itemAttributes;
            
            // add supplementary attribute for album title
            if (indexPath.item == 0)
            {
                UICollectionViewLayoutAttributes *titleAttributes = [UICollectionViewLayoutAttributes layoutAttributesForSupplementaryViewOfKind:LSPhotoAlbumLayoutAlbumTitleKind withIndexPath:indexPath];
                
                titleAttributes.frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
                
                titleLayoutInfo[indexPath] = titleAttributes;
            }
        }
    }
    
    // store layout info by cell kind
    newLayoutInfo[LSPhotoAlbumLayoutPhotoCellKind] = cellLayoutInfo;
    
    self.layoutInfo = newLayoutInfo;
    
    // set the titleLayoutInfo on the top level dictionary
    newLayoutInfo[LSPhotoAlbumLayoutAlbumTitleKind] = titleLayoutInfo;
}


#pragma mark - Frame

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
    CGFloat originX = floorf(self.itemInsets.left + (self.itemSize.width + spacingX) * column);
    
    CGFloat originY = floor(self.itemInsets.top +
                            (self.itemSize.height + self.titleHeight + self.interItemSpacingY) * row);
    
    // frame
    CGRect cellFrame = CGRectMake(originX, originY, self.itemSize.width, self.itemSize.height);
    
    return cellFrame;
}


- (CGRect)frameForAlbumTitleAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect frame = [self frameForAlbumPhotoAtIndexPath:indexPath];
    frame.origin.y += frame.size.height;
    frame.size.height = self.titleHeight;
    
    return frame;
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


- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)kind 
atIndexPath:(NSIndexPath *)indexPath
{
    return self.layoutInfo[LSPhotoAlbumLayoutAlbumTitleKind][indexPath];
}


#pragma mark - Overall ContentSize of CollectionView

- (CGSize)collectionViewContentSize
{
    NSInteger rowCount = [self.collectionView numberOfSections] / self.numberOfColumns;
    
    // add any partially filled row
    if ([self.collectionView numberOfSections] % self.numberOfColumns)
        rowCount++;
    
    // content height
    CGFloat height = self.itemInsets.top + rowCount*self.itemSize.height + rowCount*self.titleHeight + (rowCount-1)*self.interItemSpacingY + self.itemInsets.bottom;
    
    // content width
    CGFloat width = self.collectionView.bounds.size.width;
    
    CGSize contentSize = CGSizeMake( width, height );
    
    return contentSize;
}


#pragma mark - 

- (CATransform3D)transformForAlbumPhotoAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger offset = (indexPath.section * RotationStride  +  indexPath.item);
    
    CATransform3D transform = [ self.rotations[ offset % RotationCount ] CATransform3DValue ];
    
    return transform;
}


#pragma mark - Setters for Properties

- (void)setItemInsets:(UIEdgeInsets)itemInsets
{
    if (UIEdgeInsetsEqualToEdgeInsets(_itemInsets, itemInsets))
        return;
    
    _itemInsets = itemInsets;
    
    [self invalidateLayout];
}


- (void)setItemSize:(CGSize)itemSize
{
    if (CGSizeEqualToSize(_itemSize, itemSize))
        return;
    
    _itemSize = itemSize;
    
    [self invalidateLayout];
}


- (void)setInterItemSpacingY:(CGFloat)interItemSpacingY
{
    if (_interItemSpacingY == interItemSpacingY)
        return;
    
    _interItemSpacingY = interItemSpacingY;
    
    [self invalidateLayout];
}


- (void)setNumberOfColumns:(NSInteger)numberOfColumns
{
    if (_numberOfColumns == numberOfColumns)
        return;
    
    _numberOfColumns = numberOfColumns;
    
    [self invalidateLayout];
}


- (void)setTitleHeight:(CGFloat)titleHeight
{
    if (_titleHeight == titleHeight)
        return;
    
    _titleHeight = titleHeight;
    
    [self invalidateLayout];
}


@end
