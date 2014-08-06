//
//  LSCollectionViewController.m
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import "LSCollectionViewController.h"
#import "LSPhotoAlbumLayout.h"
#import "LSCollectionViewDataSource.h"
#import "LSCollectionViewDelegate.h"

#import "LSAlbumPhotoCell.h"
#import "LSAlbumTitleReusableView.h"

// Cell Identifier
static NSString * const PhotoCellIdentifier = @"PhotoCell";
// Album Title Identifier
static NSString * const AlbumTitleIdentifier = @"AlbumTitle";

@interface LSCollectionViewController ()

@property (nonatomic, weak) IBOutlet LSPhotoAlbumLayout *photoAlbumLayout;
@property (nonatomic, strong) LSCollectionViewDelegate *delegate;
@property (nonatomic, strong) LSCollectionViewDataSource *dataSource;

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


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // background image
    UIImage *imagePattern = [UIImage imageNamed:@"Concrete Wall"];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:imagePattern];
    
    // delegate, dataSource
    self.delegate = [LSCollectionViewDelegate new];
    self.collectionView.delegate = self.delegate;
    
    self.dataSource = [LSCollectionViewDataSource new];
    self.collectionView.dataSource = self.dataSource;
    // TEST
    self.dataSource.collectionView = self.collectionView;
    
    // register photo cell
    [self.collectionView registerClass:[LSAlbumPhotoCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    // register supplementary view
    [self.collectionView registerClass:[LSAlbumTitleReusableView class] forSupplementaryViewOfKind:LSPhotoAlbumLayoutAlbumTitleKind withReuseIdentifier:AlbumTitleIdentifier];
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


@end
