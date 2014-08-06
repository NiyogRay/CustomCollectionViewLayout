//
//  BHAlbum.h
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LSPhoto;

@interface LSAlbum : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong, readonly) NSArray *photos;

- (void)addPhoto:(LSPhoto *)photo;
- (BOOL)removePhoto:(LSPhoto *)photo;

@end
