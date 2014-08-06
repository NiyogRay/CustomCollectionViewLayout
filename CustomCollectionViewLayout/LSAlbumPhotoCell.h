//
//  LSAlbumPhotoCell.h
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSAlbumPhotoCell : UICollectionViewCell

// Define as public publicly
// Allows change of properties of image view
// doesnt allow switching image view itself
@property (nonatomic, strong, readonly) UIImageView *imageView;

@end
