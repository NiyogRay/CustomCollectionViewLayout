//
//  BHAlbum.m
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import "LSAlbum.h"
#import "LSPhoto.h"

@interface LSAlbum ()

@property (nonatomic, strong) NSMutableArray *mutablePhotos;

@end

@implementation LSAlbum

#pragma mark - Properties

- (NSArray *)photos
{
    return [self.mutablePhotos copy];
}


#pragma mark - Lifecycle

- (id)init
{
    self = [super init];
    if (self) {
        self.mutablePhotos = [NSMutableArray array];
    }
    return self;
}

#pragma mark - Photos

- (void)addPhoto:(LSPhoto *)photo
{
    [self.mutablePhotos addObject:photo];
}

- (BOOL)removePhoto:(LSPhoto *)photo
{
    if ([self.mutablePhotos indexOfObject:photo] == NSNotFound) {
        return NO;
    }
    
    [self.mutablePhotos removeObject:photo];
    
    return YES;
}



@end
