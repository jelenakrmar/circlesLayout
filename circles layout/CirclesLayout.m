//
//  CirclesLayout.m
//  circles layout
//
//  Created by Jelena on 8/3/18.
//  Copyright © 2018 byteout. All rights reserved.
//

#import "CirclesLayout.h"

#define kMinSpaceBetweenCircles 10
#define kMaxPredecessorNum 4
#define kPositionIncrement 5

@implementation CirclesLayout

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

// Initial settings.
- (void)setup {
    self.viewInsets = UIEdgeInsetsMake(20, 20, 20, 20); // top, left, bottom, right
}

#pragma mark - Required functions for custom layouts

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width, self.contentHeight);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.layoutInfo[indexPath];
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSMutableArray *allAttributes = [NSMutableArray arrayWithCapacity:self.layoutInfo.count];
    
    // We are iterating through self.layoutInfo.
    // We are getting attributes for each indexPath and returning them if they are within the rect.
    [self.layoutInfo enumerateKeysAndObjectsUsingBlock:^(NSIndexPath *indexPath,
                                                         UICollectionViewLayoutAttributes *attributes,
                                                         BOOL *innerStop) {
        if (CGRectIntersectsRect(rect, attributes.frame)) {
            [allAttributes addObject:attributes];
        }
    }];
    
    return allAttributes;
}

// Caching layout attributes.
- (void)prepareLayout {
    NSMutableDictionary *newLayoutInfo = [NSMutableDictionary dictionary];
    self.contentHeight = self.viewInsets.top;
    self.initialX = self.viewInsets.left;
    self.initialY = self.viewInsets.top;
    
    NSIndexPath *indexPath;
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger item = 0; item < itemCount; item++) {
        indexPath = [NSIndexPath indexPathForItem:item inSection:0];
        
        UICollectionViewLayoutAttributes *itemAttributes =
        [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        itemAttributes.frame = [self frameForCircleAtIndexPath:indexPath layoutInfo:newLayoutInfo];
        
        newLayoutInfo[indexPath] = itemAttributes;
        
        self.contentHeight = MAX(self.contentHeight, (itemAttributes.frame.origin.y + itemAttributes.frame.size.height));
    }
    
    self.contentHeight += self.viewInsets.bottom;
    self.layoutInfo = newLayoutInfo;
}

#pragma mark - CALCULATIONS

// The size and position of a single circle.
- (CGRect)frameForCircleAtIndexPath:(NSIndexPath *)indexPath layoutInfo:(NSMutableDictionary *)newLayoutInfo {
    float originX = self.initialX, originY = self.initialY;
    float width = [self sizeForItemAtIndexPath:indexPath].width;
    CGRect circle;
    
    circle = CGRectMake(originX, originY, width, width);
    while (![self distanceConditionForItem:circle AtIndexPath:indexPath InLayout:newLayoutInfo]) {
        originX += kPositionIncrement;
        
        if (originX + width + self.viewInsets.right > self.collectionView.bounds.size.width) {
            originX = self.viewInsets.left;
            originY += kPositionIncrement;
        }
        circle = CGRectMake(originX, originY, width, width);
    }
    
    // Set initial X i Y.
    self.initialX = originX + (width / 2);
    self.initialY = originY;
    
    return CGRectMake(originX, originY, width, width);
}

- (CGSize)sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([[self.collectionView.delegate class] conformsToProtocol:@protocol(UICollectionViewDelegateFlowLayout)]) {
        return [(id)self.collectionView.delegate collectionView:self.collectionView layout:self sizeForItemAtIndexPath:indexPath];
    }
    return CGSizeMake(0, 0);
}

- (BOOL)distanceConditionForItem:(CGRect)circle AtIndexPath:(NSIndexPath *)indexPath InLayout:(NSMutableDictionary *)newLayoutInfo {
    BOOL condition = YES;
    
    long numPredecessors = indexPath.row;
    if (indexPath.row >= kMaxPredecessorNum) {
        numPredecessors = kMaxPredecessorNum;
    }
    
    for (int i = 1; i <= numPredecessors; i++) {
        NSIndexPath *ip = [NSIndexPath indexPathForItem:(MAX(indexPath.row - i, 0)) inSection:0];
        UICollectionViewLayoutAttributes *attr = newLayoutInfo[ip];
        condition = condition && [self distanceBetween:circle and:attr.frame isLargerThan:kMinSpaceBetweenCircles];
    }
    
    return condition;
}

- (BOOL)distanceBetween:(CGRect)circle1 and:(CGRect)circle2 isLargerThan:(float)delta {
    float r1 = circle1.size.width / 2;
    float cx1 = circle1.origin.x + r1;
    float cy1 = circle1.origin.y + r1;
    
    float r2 = circle2.size.width / 2;
    float cx2 = circle2.origin.x + r2;
    float cy2 = circle2.origin.y + r2;
    
    float d = sqrt((pow(cx1 - cx2, 2) + pow(cy1 - cy2, 2)));
    
    return (d >= r1 + r2 + delta);
}

@end

