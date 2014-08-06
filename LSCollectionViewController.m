//
//  LSCollectionViewController.m
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import "LSCollectionViewController.h"
#import "LSPhotoAlbumLayout.h"

#import "LSAlbumPhotoCell.h"
#import "LSAlbumTitleReusableView.h"

#import "LSAlbum.h"
#import "LSPhoto.h"

#define ALBUM_COUNT 12

// Cell Identifier
static NSString * const PhotoCellIdentifier = @"PhotoCell";
// Album Title Identifier
static NSString * const AlbumTitleIdentifier = @"AlbumTitle";

@interface LSCollectionViewController ()

@property (nonatomic, weak) IBOutlet LSPhotoAlbumLayout *photoAlbumLayout;

@property (nonatomic, strong) NSMutableArray *albums;
@property (nonatomic, strong) NSOperationQueue *thumbnailQueue;

@end

@implementation LSCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // background image
    UIImage *imagePattern = [UIImage imageNamed:@"Concrete Wall"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:imagePattern];
    
    // register photo cell
    [self.collectionView registerClass:[LSAlbumPhotoCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    // register supplementary view
    [self.collectionView registerClass:[LSAlbumTitleReusableView class] forSupplementaryViewOfKind:LSPhotoAlbumLayoutAlbumTitleKind withReuseIdentifier:AlbumTitleIdentifier];
    
    [self setup];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Rotation


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    // Landscape
    if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation))
    {
        // 3 column
        self.photoAlbumLayout.numberOfColumns = 3;
        
        // TODO: Make generic
        // insets for 3.5" or 4"
        CGFloat sideInset = (([UIScreen mainScreen].preferredMode.size.width == 1136.) ? 45. : 25.);
        
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22., sideInset, 22., sideInset);
    }
    else
    {
        self.photoAlbumLayout.numberOfColumns = 2;
        self.photoAlbumLayout.itemInsets = UIEdgeInsetsMake(22., 22., 13., 22.);
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
//    __weak LSCollectionViewDataSource *weakSelf = self;
    
    __weak LSCollectionViewController *weakSelf = self;
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
