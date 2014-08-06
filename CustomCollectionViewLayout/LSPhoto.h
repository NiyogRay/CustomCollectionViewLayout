//
//  LSPhoto.h
//  CollectionViewTutorial
//
//  Created by Bryan Hansen on 11/3/12.
//  Copyright (c) 2012 Bryan Hansen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSPhoto : NSObject

@property (nonatomic, strong, readonly) NSURL *imageURL;
@property (nonatomic, strong, readonly) UIImage *image;

+ (LSPhoto *)photoWithImageURL:(NSURL *)imageURL;

- (id)initWithImageURL:(NSURL *)imageURL;

@end
