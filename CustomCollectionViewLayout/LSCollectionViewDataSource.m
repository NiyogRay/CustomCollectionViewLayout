//
//  LSCollectionViewDataSource.m
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import "LSCollectionViewDataSource.h"
#import "LSAlbumPhotoCell.h"
#import "LSAlbumTitleReusableView.h"

#import "LSAlbum.h"
#import "LSPhoto.h"

#define ALBUM_COUNT 12

// Cell Identifier
static NSString * const PhotoCellIdentifier = @"PhotoCell";
// Album Title Identifier
static NSString * const AlbumTitleIdentifier = @"AlbumTitle";

/// Private Interface
@interface LSCollectionViewDataSource ()

// hold all the albums
@property (nonatomic, strong) NSMutableArray *albums;

/// photo Q
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

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
    self.thumbnailQueue = [NSOperationQueue new];
    self.thumbnailQueue.maxConcurrentOperationCount = 3;
    
    self.albums = [NSMutableArray array];
    
    NSURL *urlPrefix = [NSURL URLWithString:@"https://raw.github.com/ShadoFlameX/PhotoCollectionView/master/Photos/"];

    NSInteger photoIndex = 0;
    
    for (NSInteger a = 0; a < ALBUM_COUNT; a++)
    {
        LSAlbum *album = [[LSAlbum alloc] init];
        album.name = [NSString stringWithFormat:@"Photo Album %d", a + 1];
        
        NSUInteger photoCount = arc4random_uniform(4) + 2;
        
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
    
    // load photos in bg
    __weak LSCollectionViewDataSource *weakSelf = self;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        
        UIImage *image = [photo image];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([weakSelf.collectionView.indexPathsForVisibleItems containsObject:indexPath])
            {
                LSAlbumPhotoCell *photoCell = (LSAlbumPhotoCell *)[weakSelf.collectionView cellForItemAtIndexPath:indexPath];
                
                photoCell.imageView.image = image;
            }
        });
    }];
    
    // give priority to top photo in album
    operation.queuePriority = (indexPath.item == 0 ? NSOperationQueuePriorityHigh : NSOperationQueuePriorityNormal);
    
    [self.thumbnailQueue addOperation:operation];
    
    return photoCell;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath
{
    LSAlbumTitleReusableView *titleView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:AlbumTitleIdentifier forIndexPath:indexPath];
    
    LSAlbum *album = self.albums[indexPath.section];
    
    titleView.titleLabel.text = album.name;
    
    return titleView;
}


@end
