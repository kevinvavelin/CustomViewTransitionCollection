//
//  DetailViewController.m
//  CustomViewTransitionCollection
//
//  Created by Vavelin Kevin on 19/04/14.
//  Copyright (c) 2014 Vavelin Kevin. All rights reserved.
//

#import "DetailViewController.h"
#import "CollectionViewController.h"
#import "DismissPhotoCollectionViewTransition.h"

@interface DetailViewController () <UINavigationControllerDelegate>


@property (strong, nonatomic) IBOutlet UILabel *usernameLabel;
@property(nonatomic, strong) UIPercentDrivenInteractiveTransition *popInteractive;
@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [_shotsImg setImage:[_informations valueForKey:@"image"]];
    [_usernameLabel setText:[_informations valueForKey:@"name"]];
    [self.navigationItem setTitle:[_informations valueForKey:@"name"]];
    
    UIScreenEdgePanGestureRecognizer *popEdgeGesture = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(popGesture:)];
    [popEdgeGesture setEdges:UIRectEdgeLeft];
    [self.view addGestureRecognizer:popEdgeGesture];
}

-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController setDelegate:self];
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (self.navigationController.delegate == self)
    {
        self.navigationController.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Pop Gesture

-(void)popGesture:(UIScreenEdgePanGestureRecognizer *)recognizer
{
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    
    switch (recognizer.state)
    {
        case UIGestureRecognizerStateBegan:
        {
            self.popInteractive = [[UIPercentDrivenInteractiveTransition alloc] init];
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self.popInteractive updateInteractiveTransition:progress];
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        {
            if (progress > 0.5)
            {
                [self.popInteractive finishInteractiveTransition];
            } else {
                [self.popInteractive cancelInteractiveTransition];
            }
            self.popInteractive = nil;

        }
            break;
            
        default:
            break;
    }

}

#pragma mark UINavigationController Delegate Method

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (fromVC == self && [toVC isKindOfClass:[CollectionViewController class]])
    {
        return [[DismissPhotoCollectionViewTransition alloc] init];
    } else {
        return nil;
    }
}

- (id<UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                         interactionControllerForAnimationController:(id<UIViewControllerAnimatedTransitioning>)animationController
{
    if ([animationController isKindOfClass:[DismissPhotoCollectionViewTransition class]])
    {
        return self.popInteractive;
    } else {
        return nil;
    }
}


@end
