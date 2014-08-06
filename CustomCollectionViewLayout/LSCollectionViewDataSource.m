//
//  LSCollectionViewDataSource.m
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import "LSCollectionViewDataSource.h"
#import "LSAlbumPhotoCell.h"

#import "LSAlbum.h"
#import "LSPhoto.h"

#define ALBUM_COUNT 12

// Cell Identifier
static NSString * const PhotoCellIdentifier = @"PhotoCell";

/// Private Interface
@interface LSCollectionViewDataSource ()

// hold all the albums
@property (nonatomic, strong) NSMutableArray *albums;

@end

@implementation LSCollectionViewDataSource


- (id)init
{
    if (self = [super init])
    {
        [self setup];
    }
    return self;
}


- (void)setup
{
    self.albums = [NSMutableArray array];
    
    NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];

    NSInteger photoIndex = 0;
    
    for (NSInteger a = 0; a < ALBUM_COUNT; a++)
    {
        LSAlbum *album = [[LSAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %d", a + 1];
        
        NSUInteger photoCount = 1;
        
        for (NSInteger p = 0; p < photoCount; p++)
        {
            // upto 25 photos available in location
            NSString *photoFilename = [NSString stringWithFormat:@"thumbnail%d.jpg", photoIndex % 25];
            
            NSURL *photoURL = [urlPrefix URLByAppendingPathComponent:photoFilename];
            
            LSPhoto *photo = [LSPhoto photoWithImageURL:photoURL];
            
            [album addPhoto:photo];
            
            photoIndex++;
        }
        
        [self.albums addObject:album];
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.albums.count;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    LSAlbum *album = self.albums[section];
    return album.photos.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSAlbumPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
    
    LSAlbum *album = self.albums[indexPath.section];
    LSPhoto *photo = album.photos[indexPath.item];
    
    photoCell.imageView.image = [photo image];
    
    return photoCell;
}

@end
