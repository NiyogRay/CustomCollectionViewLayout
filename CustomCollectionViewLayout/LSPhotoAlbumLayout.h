//
//  LSPhotoAlbumLayout.h
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString * const LSPhotoAlbumLayoutAlbumTitleKind;

@interface LSPhotoAlbumLayout : UICollectionViewLayout

@property (nonatomic) UIEdgeInsets itemInsets;
@property (nonatomic) CGSize itemSize;
@property (nonatomic) CGFloat interItemSpacingY;
@property (nonatomic) NSInteger numberOfColumns;
@property (nonatomic) CGFloat titleHeight;

@end
