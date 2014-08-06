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

// Cell Identifier
static NSString * const PhotoCellIdentifier = @"PhotoCell";

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
    
    // background color
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    
    // delegate, dataSource
//    self.delegate = [LSCollectionViewDelegate new];
//    self.collectionView.delegate = self.delegate;
//    
//    self.dataSource = [LSCollectionViewDataSource new];
//    self.collectionView.dataSource = self.dataSource;
    
    // register cell class for identifier
    [self.collectionView registerClass:[LSAlbumPhotoCell class] forCellWithReuseIdentifier:PhotoCellIdentifier];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UICOllectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 10;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    return 5;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    LSAlbumPhotoCell *photoCell = [collectionView dequeueReusableCellWithReuseIdentifier:PhotoCellIdentifier forIndexPath:indexPath];
    
    return photoCell;
}


@end
