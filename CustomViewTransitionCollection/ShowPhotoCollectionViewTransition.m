//
//  ShowPhotoCollectionViewTransition.m
//  CustomViewTransitionCollection
//
//  Created by Vavelin Kevin on 19/04/14.
//  Copyright (c) 2014 Vavelin Kevin. All rights reserved.
//

#import "ShowPhotoCollectionViewTransition.h"
#import "CollectionViewController.h"
#import "DetailViewController.h"
#import "DribbbleCell.h"

@implementation ShowPhotoCollectionViewTransition


- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    CollectionViewController *fromViewController = (CollectionViewController*)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    DetailViewController *toViewController = (DetailViewController*)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    DribbbleCell *cell = (DribbbleCell*)[fromViewController.collectionView cellForItemAtIndexPath:[[fromViewController.collectionView indexPathsForSelectedItems] firstObject]];
    UIView *cellImageSnapshot = [cell.shotImageView snapshotViewAfterScreenUpdates:NO];
    cellImageSnapshot.frame = [containerView convertRect:cell.shotImageView.frame fromView:cell.shotImageView.superview];
    cell.shotImageView.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    toViewController.view.alpha = 0;
    toViewController.shotsImg.hidden = YES;
    
    [containerView addSubview:toViewController.view];
    [containerView addSubview:cellImageSnapshot];
    
    [UIView animateWithDuration:duration animations:^{
        toViewController.view.alpha = 1.0;
        CGRect frame = [containerView convertRect:toViewController.shotsImg.frame fromView:toViewController.view];
        cellImageSnapshot.frame = frame;
    } completion:^(BOOL finished) {
        toViewController.shotsImg.hidden = NO;
        cell.hidden = NO;
        [cellImageSnapshot removeFromSuperview];
        
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}


@end
