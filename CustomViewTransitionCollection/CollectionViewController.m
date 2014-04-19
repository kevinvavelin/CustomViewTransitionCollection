//
//  CollectionViewController.m
//  CustomViewTransitionCollection
//
//  Created by Vavelin Kevin on 19/04/14.
//  Copyright (c) 2014 Vavelin Kevin. All rights reserved.
//

#import "CollectionViewController.h"
#import "DetailViewController.h"
#import "ShowPhotoCollectionViewTransition.h"

@interface CollectionViewController () <UIAlertViewDelegate, UITextFieldDelegate, UINavigationControllerDelegate>
{
    NSString *_playerName;
    dispatch_queue_t getDataQ;
    dispatch_queue_t getImageQ;
    NSMutableArray *_shotsArray;
    NSDictionary *_informationsObject;
}

@end

@implementation CollectionViewController

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
    getDataQ = dispatch_queue_create("DataQ", DISPATCH_QUEUE_SERIAL);
    getImageQ = dispatch_queue_create("ImageQ", DISPATCH_QUEUE_SERIAL);
    if(_playerName == nil)
    {
        UIAlertView *popupName = [[UIAlertView alloc] initWithTitle:@"Player name" message:@"Enter your player name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
        [popupName setAlertViewStyle:UIAlertViewStylePlainTextInput];
        [popupName show];
    }
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

- (IBAction)closeView:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark UICollectionView Delegate and DataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [_shotsArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"ShotsCell";
    DribbbleCell *cell = (DribbbleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[DribbbleCell alloc] init];
    }
    [cell.shotImageView setImage:[[_shotsArray objectAtIndex:indexPath.row] valueForKey:@"image"]];
    [cell.userLabel setText:[[_shotsArray objectAtIndex:indexPath.row] valueForKey:@"name"]];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _informationsObject = [_shotsArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"showDetail" sender:self];
}

-(DribbbleCell *)collectionViewCell:(NSDictionary *)informationsCell
{
    NSInteger index = [_shotsArray indexOfObject:informationsCell];
    if(index == NSNotFound)
    {
        return nil;
    }
    return (DribbbleCell *)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
}

#pragma mark UIAlertView Delegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if(![[alertView textFieldAtIndex:0].text isEqualToString:@""])
    {
        _playerName = [alertView textFieldAtIndex:0].text;
        [self loadDribbble:_playerName];
    }
}

#pragma mark Load Dribble Object

-(void)loadDribbble:(NSString *)player
{
    dispatch_async(getDataQ, ^{
        NSError *error;
        NSString *followingURL = [NSString stringWithFormat:@"http://api.dribbble.com/players/%@/shots/following", player];
        NSURL *dribbbleURL = [NSURL URLWithString:followingURL];
        NSData *dribbbleData = [NSData dataWithContentsOfURL:dribbbleURL];
        if(dribbbleData)
        {
            _shotsArray = [NSMutableArray array];
            NSDictionary *dribbbleShots = [NSJSONSerialization JSONObjectWithData:dribbbleData options:NSJSONReadingAllowFragments error:&error];
            NSLog(@"Dribbble = %@", dribbbleShots);
            NSArray *shots = [dribbbleShots valueForKey:@"shots"];
            for(NSDictionary *shotsInformations in shots)
            {
                NSMutableDictionary *informations = [NSMutableDictionary dictionary];
                dispatch_async(getImageQ, ^{
                    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[shotsInformations valueForKey:@"image_url"]]];
                    UIImage *image = [UIImage imageWithData:imgData];
                    [informations setValue:image forKey:@"image"];
                    [informations setValue:[[shotsInformations valueForKey:@"player"] valueForKey:@"username"] forKey:@"name"];
                    [_shotsArray addObject:informations];
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.collectionView reloadData];
                    });
                });
            }
        } else {
            UIAlertView *popupName = [[UIAlertView alloc] initWithTitle:@"Player namowe" message:@"Enter your player name" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Confirm", nil];
            [popupName setAlertViewStyle:UIAlertViewStylePlainTextInput];
            [popupName show];
        }
    });
}

#pragma mark Prepare Segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue destinationViewController] isKindOfClass:[DetailViewController class]])
    {
        DetailViewController *detailVC = (DetailViewController *)[segue destinationViewController];
        [detailVC setInformations:_informationsObject];
    }
}


#pragma mark UINavigationController Delegate Methods

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    if (fromVC == self && [toVC isKindOfClass:[DetailViewController class]])
    {
        return [[ShowPhotoCollectionViewTransition alloc] init];
    }
    else {
        return nil;
    }
}

@end
