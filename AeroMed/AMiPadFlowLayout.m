//
//  AMiPadFlowLayout.m
//  AeroMed
//
//  Created by Michael Torres on 3/25/14.
//  Copyright (c) 2014 GVSU. All rights reserved.
//

#import "AMiPadFlowLayout.h"

@implementation AMiPadFlowLayout

- (UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    //layoutAttributes.frame = CGRectMake(0.0, 0.0, self.collectionViewContentSize.width, self.collectionViewContentSize.height);
    layoutAttributes.frame = CGRectMake(0.0, 0.0, self.collectionView.frame.size.width, self.collectionView.frame.size.height);

    layoutAttributes.zIndex = -1;
    return layoutAttributes;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *allAttributes = [[NSMutableArray alloc] initWithCapacity:4];
    
    [allAttributes addObject:[self layoutAttributesForDecorationViewOfKind:@"helicopter" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]]];
    
    for (NSInteger i = 0; i < [self.collectionView numberOfItemsInSection:0]; i++)
    {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *layoutAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [allAttributes addObject:layoutAttributes];
    }
    return allAttributes;
}


@end
