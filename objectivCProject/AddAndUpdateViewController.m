//
//  AddAndUpdateViewController.m
//  objectivCProject
//
//  Created by Abanob Wadie on 4/5/21.
//  Copyright © 2021 Abanob Wadie. All rights reserved.
//

#import "AddAndUpdateViewController.h"

@interface AddAndUpdateViewController ()
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UITextField *nameTxt;
@property (weak, nonatomic) IBOutlet UITextView *descTxt;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *prioritySelection;
@property (weak, nonatomic) IBOutlet UITextField *reminderDateTxt;
@property (weak, nonatomic) IBOutlet UISwitch *inprogressSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *doneSwitch;
@property (weak, nonatomic) IBOutlet UIButton *addAndUpdateBtn;
@property (weak, nonatomic) IBOutlet UIButton *fileBtn;

@property (weak, nonatomic) IBOutlet UIStackView *dateView;
@property (weak, nonatomic) IBOutlet UIStackView *statusView;
@property (weak, nonatomic) IBOutlet UIStackView *inprogressView;

@property NSString *status;
@property NSDate *nsdate;
@property NSURL *file;
@end

@implementation AddAndUpdateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self style];
    
    if (_addOrUpdate == 1) {
        _status = @"1";
        
        [_dateView setHidden:YES];
        [_statusView setHidden:YES];
    }else{
        _titleLbl.text = @"Edit task";
        [_addAndUpdateBtn setTitle:@"Edit" forState:UIControlStateNormal];
        
        NSDictionary *task = [_tasks objectAtIndex:_index];
        
        _nameTxt.text = [task objectForKey:@"name"];
        _descTxt.text = [task objectForKey:@"desc"];
        _dateLbl.text = [task objectForKey:@"date"];
        
        NSString *priority = [task objectForKey:@"icon"];
        switch ([priority intValue]) {
            case 1:
                [_prioritySelection setSelectedSegmentIndex:0];
                break;
                
            case 2:
                [_prioritySelection setSelectedSegmentIndex:1];
                break;
                
            case 3:
                [_prioritySelection setSelectedSegmentIndex:2];
            default:
                break;
        }
        
        _reminderDateTxt.text = [task objectForKey:@"reminderDate"];
        _nsdate = [task objectForKey:@"nsdate"];
        
        _status = [task objectForKey:@"status"];
        switch ([_status intValue]) {
            case 2:
                [_inprogressSwitch setOn:YES];
                [_inprogressSwitch setEnabled:NO];
                [_inprogressSwitch setAlpha:0.5];
                break;
                
            case 3:
                [_doneSwitch setOn:YES];
                [_doneSwitch setEnabled:NO];
                [_doneSwitch setAlpha:0.5];
                
                [_inprogressView setHidden:YES];
                break;
            default:
                break;
        }
    }
}

- (IBAction)fileAction:(id)sender {
    if (_addOrUpdate == 1) {
        UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[] inMode:UIDocumentPickerModeOpen];
        [picker setAllowsMultipleSelection:NO];
        [picker setDelegate:self];
        [self presentViewController:picker animated:YES completion:nil];
        
    }else{
        NSDictionary *task = [_tasks objectAtIndex:_index];
        _file = [task objectForKey:@"file"];
        
        UIDocumentPickerViewController *picker = [[UIDocumentPickerViewController alloc] initWithDocumentTypes:@[] inMode:UIDocumentPickerModeOpen];
        [picker setAllowsMultipleSelection:NO];
        [picker setDelegate:self];
        [picker setDirectoryURL:_file];
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (IBAction)inprogressAction:(id)sender {
    [_doneSwitch setOn:NO];
    _status = @"2";
}

- (IBAction)doneAction:(id)sender {
    [_inprogressSwitch setOn:NO];
    _status = @"3";
}

- (IBAction)addAndUpdateAction:(id)sender {
    NSDate *date = [NSDate new];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"dd/MM/yyyy hh:mm"];
    NSString *dateStr = [formatter stringFromDate:date];
    
    NSString *priority = @"1";
    switch (_prioritySelection.selectedSegmentIndex) {
        case 0:
            priority = @"1";
            break;
            
        case 1:
            priority = @"2";
            break;
            
        case 2:
            priority = @"3";
        default:
            break;
    }
    
    NSDictionary *task = [[NSDictionary alloc] initWithObjects:@[_nameTxt.text, _descTxt.text, dateStr, priority, _reminderDateTxt.text, _nsdate, _status] forKeys:@[@"name", @"desc", @"date", @"icon", @"reminderDate", @"nsdate", @"status"]];
    
    if (_addOrUpdate == 1){
        if (_tasks == nil) {
            _tasks = [NSMutableArray new];
        }
        [_tasks addObject:task];
    }else{
        [_tasks removeObjectAtIndex:_index];
        [_tasks insertObject:task atIndex:_index];
    }
    
    NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
    [def setObject:_tasks forKey:@"tasks"];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) style{
    _nameTxt.layer.cornerRadius = _nameTxt.frame.size.height / 2;
    _nameTxt.layer.borderWidth = 2;
    [_nameTxt setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)]];
    [_nameTxt setLeftViewMode:UITextFieldViewModeAlways];
    
    _descTxt.layer.cornerRadius = _descTxt.frame.size.height / 9;
    _descTxt.layer.borderWidth = 2;
    
    _reminderDateTxt.layer.cornerRadius = _reminderDateTxt.frame.size.height / 2;
    _reminderDateTxt.layer.borderWidth = 2;
    [_reminderDateTxt setLeftView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 50)]];
    [_reminderDateTxt setLeftViewMode:UITextFieldViewModeAlways];
    
    UIDatePicker *picker = [UIDatePicker new];
    [picker setDatePickerMode:UIDatePickerModeTime];
    [picker setDate:[NSDate date]];
    [picker addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventTouchUpInside];
    [picker addTarget:self action:@selector(setDate:) forControlEvents:UIControlEventValueChanged];
    [_reminderDateTxt setInputView:picker];
    
    _addAndUpdateBtn.layer.cornerRadius = _addAndUpdateBtn.frame.size.height / 2;
}

-(void) setDate: (id)sender {
    UIDatePicker *picker = (UIDatePicker*) _reminderDateTxt.inputView;
    _reminderDateTxt.text = [self formatDate:picker.date];
    _nsdate = picker.date;
}

-(NSString*) formatDate: (NSDate*) date{
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"hh:mm"];
    return [formatter stringFromDate:date];
}

-(void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentsAtURLs:(NSArray<NSURL *> *)urls{
    _file = urls.firstObject;
    [_fileBtn setTitle:_file.absoluteString forState:UIControlStateNormal];
}

-(void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
