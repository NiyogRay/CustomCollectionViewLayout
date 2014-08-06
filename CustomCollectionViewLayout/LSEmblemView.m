//
//  LSEmblemView.m
//  CustomCollectionViewLayout
//
//  Created by Niyog Ray on 06/08/14.
//  Copyright (c) 2014 LeftShift. All rights reserved.
//

#import "LSEmblemView.h"

static NSString * const LSEmblemViewImageName = @"Emblem";

@implementation LSEmblemView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        UIImage *image = [UIImage imageNamed:LSEmblemViewImageName];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = self.bounds;
        
        [self addSubview:imageView];
    }
    return self;
}


+ (CGSize)defaultSize
{
    return [UIImage imageNamed:LSEmblemViewImageName].size;
}

@end
