//
//  TodoViewController.m
//  objectivCProject
//
//  Created by Abanob Wadie on 4/5/21.
//  Copyright © 2021 Abanob Wadie. All rights reserved.
//

#import "TodoViewController.h"
#import "AddAndUpdateViewController.h"
#import <UserNotifications/UserNotifications.h>

@interface TodoViewController ()
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet UITableView *todoTableView;

@property NSMutableArray *tasks;
@property NSMutableArray *original;
@end

@implementation TodoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    _tasks = [[def arrayForKey:@"tasks"] mutableCopy];
    
    NSMutableArray *temp = [NSMutableArray new];
    for (NSDictionary *task in _tasks) {
        NSString *status = [task objectForKey:@"status"];
        
        
        if (![status isEqualToString:@"2"] && ![status isEqualToString:@"3"]) {
            [temp addObject:task];

            [self showNotification:task];
        }
    }
    _tasks = temp;
    _original = _tasks;
    
    [_todoTableView reloadData];
}

-(void) showNotification: (NSDictionary*) task{
    NSDate *reminderDate = [task objectForKey:@"nsdate"];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];

    [calendar setTimeZone:[NSTimeZone localTimeZone]];

    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone fromDate:reminderDate];


    UNMutableNotificationContent *objNotificationContent = [[UNMutableNotificationContent alloc] init];
    objNotificationContent.title = [task objectForKey:@"name"];
    objNotificationContent.body = [task objectForKey:@"desc"];
    objNotificationContent.sound = [UNNotificationSound defaultSound];

    /// 4. update application icon badge number
    objNotificationContent.badge = @([[UIApplication sharedApplication] applicationIconBadgeNumber] + 1);


    UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:components repeats:NO];


    UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:@"ten" content:objNotificationContent trigger:trigger];
    /// 3. schedule localNotification
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        if (!error) {
            NSLog(@"Local Notification succeeded");
        }else {
            NSLog(@"Local Notification failed");
        }
    }];
}

- (IBAction)addAction:(id)sender {
    AddAndUpdateViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAndUpdateViewController"];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    vc.tasks = [[def arrayForKey:@"tasks"] mutableCopy];
    vc.addOrUpdate = 1;
    [self.navigationController pushViewController:vc animated:YES];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tasks.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    UILabel *name = [cell viewWithTag:1];
    UIImageView *icon = [cell viewWithTag:2];
    UIView *container = [cell viewWithTag:3];
    
    NSDictionary *task = [_tasks objectAtIndex:indexPath.row];
    name.text = [task objectForKey:@"name"];
    icon.image = [UIImage imageNamed:[task objectForKey:@"icon"]];
    
    container.layer.cornerRadius = container.frame.size.height / 2;
    cell.contentView.layer.cornerRadius = cell.contentView.frame.size.height / 2;
    
    if (indexPath.row == _tasks.count - 1) {
        _tasks = _original;
    }
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    _searchBar.text = @"";
    AddAndUpdateViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AddAndUpdateViewController"];
    vc.modalPresentationStyle = UIModalPresentationFullScreen;
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic = [_tasks objectAtIndex:indexPath.row];
    NSMutableArray *temp = [[def arrayForKey:@"tasks"] mutableCopy];
    vc.tasks = temp;
    vc.addOrUpdate = 2;
    vc.index = (int)[temp indexOfObject:dic];
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSDictionary *dic = [_tasks objectAtIndex:indexPath.row];
        [_tasks removeObjectAtIndex:indexPath.row];
        [_todoTableView reloadData];
        
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        NSMutableArray *arr = [[def arrayForKey:@"tasks"] mutableCopy];
        [arr removeObject:dic];
        [def setObject:arr forKey:@"tasks"];
    }
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText isEqualToString:@""]) {
        NSMutableArray *temp = [NSMutableArray new];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        _tasks = [[def arrayForKey:@"tasks"] mutableCopy];
        
        temp = [NSMutableArray new];
        for (NSDictionary *task in _tasks) {
            NSString *status = [task objectForKey:@"status"];
            
            if (![status isEqualToString:@"2"] && ![status isEqualToString:@"3"]) {
                [temp addObject:task];
            }
        }
        _tasks = temp;
        [_todoTableView reloadData];
    }else{
 
        NSMutableArray *temp = [NSMutableArray new];
        for (NSDictionary *task in _tasks) {
            NSString *name = [task objectForKey:@"name"];
                
            if ([name localizedCaseInsensitiveContainsString:searchText]) {
                [temp addObject:task];
            }
        }
        _tasks = temp;
        
        [_todoTableView reloadData];
    }
}

@end
