//
//  CollectionViewController.h
//  CustomViewTransitionCollection
//
//  Created by Vavelin Kevin on 19/04/14.
//  Copyright (c) 2014 Vavelin Kevin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DribbbleCell.h"

@interface CollectionViewController : UICollectionViewController

-(DribbbleCell *)collectionViewCell:(NSDictionary *)informationsCell;

@end
