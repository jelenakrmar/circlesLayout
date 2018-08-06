//
//  ViewController.m
//  circles layout
//
//  Created by Jelena on 8/3/18.
//  Copyright © 2018 byteout. All rights reserved.
//

#import "ViewController.h"
#import "CircleCell.h"

#define kCircleIdentifier @"CircleCell"

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic) NSMutableArray *dataSource;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Data displayed
    self.dataSource = [[NSMutableArray alloc] initWithObjects:@120, @160, @80, @120, @80, @140, @100, @200, nil];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CircleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCircleIdentifier forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[CircleCell alloc] init];
    }
    
    cell.circleLabel.text = [NSString stringWithFormat:@"%@", self.dataSource[indexPath.row]];
    cell.layer.cornerRadius = cell.frame.size.width / 2;
    
    return cell;
}

#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([self.dataSource[indexPath.row] doubleValue], [self.dataSource[indexPath.row] doubleValue]);
}

@end
