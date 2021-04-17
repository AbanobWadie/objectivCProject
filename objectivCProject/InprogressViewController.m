//
//  InprogressViewController.m
//  objectivCProject
//
//  Created by Abanob Wadie on 4/5/21.
//  Copyright © 2021 Abanob Wadie. All rights reserved.
//

#import "InprogressViewController.h"
#import "AddAndUpdateViewController.h"

@interface InprogressViewController ()
@property (weak, nonatomic) IBOutlet UITableView *inprogressTableView;

@property NSMutableArray *tasks;
@property BOOL sorted;

@property NSMutableArray *high;
@property NSMutableArray *medium;
@property NSMutableArray *low;
@end

@implementation InprogressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _sorted = NO;
    _high = [NSMutableArray new];
    _medium = [NSMutableArray new];
    _low = [NSMutableArray new];
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    _tasks = [[def arrayForKey:@"tasks"] mutableCopy];
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *task in _tasks) {
        NSString *status = [task objectForKey:@"status"];
        
        if (![status isEqualToString:@"1"] && ![status isEqualToString:@"3"]) {
            [temp addObject:task];
        }
    }
    _tasks = temp;
    
    [_inprogressTableView reloadData];
}

- (IBAction)sortAction:(id)sender {
    _high = [NSMutableArray new];
    _medium = [NSMutableArray new];
    _low = [NSMutableArray new];
    _sorted = !_sorted;
    
    for (NSDictionary *task in _tasks) {
        NSString *priority = [task objectForKey:@"icon"];
        
        switch ([priority intValue]) {
            case 1:
                [_high addObject:task];
                break;
                
            case 2:
                [_medium addObject:task];
                break;
                
            case 3:
                [_low addObject:task];
            default:
                break;
        }
    }
    
    [_inprogressTableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_sorted) {
        return 3;
    }else{
        return 1;
    }
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (_sorted) {
        switch (section) {
            case 0:
                return _high.count;
            case 1:
                return _medium.count;
            case 2:
                return _low.count;
            default:
                return _tasks.count;
        }
    }else{
        return _tasks.count;
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *name = [cell viewWithTag:1];
    UIImageView *icon = [cell viewWithTag:2];
    UIView *container = [cell viewWithTag:3];
    
    if (_sorted) {
        switch (indexPath.section) {
            case 0:{
                NSDictionary *task = [_high objectAtIndex:indexPath.row];
                name.text = [task objectForKey:@"name"];
                icon.image = [UIImage imageNamed:[task objectForKey:@"icon"]];
                break;
            }
            
            case 1:{
                NSDictionary *task = [_medium objectAtIndex:indexPath.row];
                name.text = [task objectForKey:@"name"];
                icon.image = [UIImage imageNamed:[task objectForKey:@"icon"]];
                break;
            }
            case 2:{
                NSDictionary *task = [_low objectAtIndex:indexPath.row];
                name.text = [task objectForKey:@"name"];
                icon.image = [UIImage imageNamed:[task objectForKey:@"icon"]];
                break;
            }
            default:
                break;
        }
    }else{
        NSDictionary *task = [_tasks objectAtIndex:indexPath.row];
        name.text = [task objectForKey:@"name"];
        icon.image = [UIImage imageNamed:[task objectForKey:@"icon"]];
    }
    
    
    container.layer.cornerRadius = container.frame.size.height / 2;
    cell.contentView.layer.cornerRadius = cell.contentView.frame.size.height / 2;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AddAndUpdateViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAndUpdateViewController"];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSMutableArray *temp = [[def arrayForKey:@"tasks"] mutableCopy];
    vc.tasks = temp;
    vc.addOrUpdate = 2;
    
    if (_sorted) {
        switch (indexPath.section) {
            case 0:{
                NSDictionary *dic = [_high objectAtIndex:indexPath.row];
                vc.index = (int)[temp indexOfObject:dic];
                break;
            }
                
            case 1:{
                NSDictionary *dic = [_medium objectAtIndex:indexPath.row];
                vc.index = (int)[temp indexOfObject:dic];
                break;
            }
                
            case 2:{
                NSDictionary *dic = [_low objectAtIndex:indexPath.row];
                vc.index = (int)[temp indexOfObject:dic];
                break;
            }
                
            default:
                break;
        }
    }else{
        NSDictionary *dic = [_tasks objectAtIndex:indexPath.row];
        vc.index = (int)[temp indexOfObject:dic];
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (_sorted) {
            switch (indexPath.section) {
                case 0:{
                    NSDictionary *dic = [_high objectAtIndex:indexPath.row];
                    [_high removeObjectAtIndex:indexPath.row];
                    
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    NSMutableArray *arr = [[def arrayForKey:@"tasks"] mutableCopy];
                    [arr removeObject:dic];
                    [def setObject:arr forKey:@"tasks"];
                    break;
                }
                    
                case 1:{
                    NSDictionary *dic = [_medium objectAtIndex:indexPath.row];
                    [_medium removeObjectAtIndex:indexPath.row];
                    
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    NSMutableArray *arr = [[def arrayForKey:@"tasks"] mutableCopy];
                    [arr removeObject:dic];
                    [def setObject:arr forKey:@"tasks"];
                    break;
                }
                    
                case 2:{
                    NSDictionary *dic = [_low objectAtIndex:indexPath.row];
                    [_low removeObjectAtIndex:indexPath.row];
                    
                    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
                    NSMutableArray *arr = [[def arrayForKey:@"tasks"] mutableCopy];
                    [arr removeObject:dic];
                    [def setObject:arr forKey:@"tasks"];
                    break;
                }
                    
                default:
                    break;
            }
        }else{
            NSDictionary *dic = [_tasks objectAtIndex:indexPath.row];
            [_tasks removeObjectAtIndex:indexPath.row];
            
            NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
            NSMutableArray *arr = [[def arrayForKey:@"tasks"] mutableCopy];
            [arr removeObject:dic];
            [def setObject:arr forKey:@"tasks"];
        }
        
        [_inprogressTableView reloadData];
        
        
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (_sorted) {
        switch (section) {
            case 0:
                return @"High";
            
            case 1:
                return @"Medium";
                
            case 2:
                return @"Low";
                
            default:
                return @"";
        }
    }else{
        return @"";
    }
    
}
@end
