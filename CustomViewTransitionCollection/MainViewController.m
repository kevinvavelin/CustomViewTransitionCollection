//
//  MainViewController.m
//  CustomViewTransitionCollection
//
//  Created by Vavelin Kevin on 19/04/14.
//  Copyright (c) 2014 Vavelin Kevin. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()
{
    NSArray *_nameTransition;
}

@end

@implementation MainViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _nameTransition = @[@"Collection View"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_nameTransition count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"SegueCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    [cell.textLabel setText:[_nameTransition objectAtIndex:indexPath.row]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:[_nameTransition objectAtIndex:indexPath.row] sender:self];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
