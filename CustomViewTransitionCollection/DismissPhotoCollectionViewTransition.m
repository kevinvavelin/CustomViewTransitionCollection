//
//  DismissPhotoCollectionViewTransition.m
//  CustomViewTransitionCollection
//
//  Created by Vavelin Kevin on 19/04/14.
//  Copyright (c) 2014 Vavelin Kevin. All rights reserved.
//

#import "DismissPhotoCollectionViewTransition.h"
#import "DetailViewController.h"
#import "CollectionViewController.h"
#import "DribbbleCell.h"

@implementation DismissPhotoCollectionViewTransition

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    DetailViewController *fromViewController = (DetailViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    CollectionViewController *toViewController = (CollectionViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    
    UIView *containerView = [transitionContext containerView];
    NSTimeInterval duration = [self transitionDuration:transitionContext];
    
    UIView *imageSnapshot = [fromViewController.shotsImg snapshotViewAfterScreenUpdates:NO];
    imageSnapshot.frame = [containerView convertRect:fromViewController.shotsImg.frame fromView:fromViewController.shotsImg.superview];
    fromViewController.shotsImg.hidden = YES;
        DribbbleCell *cell = [toViewController collectionViewCell:fromViewController.informations];
    cell.shotImageView.hidden = YES;
    
    toViewController.view.frame = [transitionContext finalFrameForViewController:toViewController];
    [containerView insertSubview:toViewController.view belowSubview:fromViewController.view];
    [containerView addSubview:imageSnapshot];
    
    [UIView animateWithDuration:duration animations:^{
        fromViewController.view.alpha = 0.0;
        
        imageSnapshot.frame = [containerView convertRect:cell.shotImageView.frame fromView:cell.shotImageView.superview];
    } completion:^(BOOL finished) {
        
        [imageSnapshot removeFromSuperview];
        fromViewController.shotsImg.hidden = NO;
        cell.shotImageView.hidden = NO;
        [transitionContext completeTransition:!transitionContext.transitionWasCancelled];
    }];
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}


@end
