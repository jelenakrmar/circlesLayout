//
//  CirclesLayout.h
//  circles layout
//
//  Created by Jelena on 8/3/18.
//  Copyright © 2018 byteout. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CirclesLayout : UICollectionViewLayout

// "Cached" layout information
@property (nonatomic, strong) NSDictionary *layoutInfo;
@property (nonatomic) float contentHeight;

// Helpers
@property (nonatomic) UIEdgeInsets viewInsets;
@property (nonatomic) float initialX;
@property (nonatomic) float initialY;

@end
