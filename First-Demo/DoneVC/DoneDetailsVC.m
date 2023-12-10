//
//  DoneEditVC.m
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import "DoneDetailsVC.h"

@interface DoneDetailsVC ()

// Outlets
@property (weak, nonatomic) IBOutlet UITextField *todoNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *todoDescriptionTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *todoPrioritySegementedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *todoStatusSegementedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *todoDate;


@end

@implementation DoneDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationItem setTitle:@"Done Todo"];
    
    // set values to UI element by passing _todoPassed element.
    _todoNameTextField.text =_todoPassed.todoName;
    _todoDescriptionTextField.text = _todoPassed.todoDescription;
    _todoDate.date = _todoPassed.todoDate;
    
    if([_todoPassed.todoPriority  isEqual: @"low"]){
        _todoPrioritySegementedControl.selectedSegmentIndex = 0;
    }else if([_todoPassed.todoPriority  isEqual: @"med"]){
        _todoPrioritySegementedControl.selectedSegmentIndex = 1;
    }else if([_todoPassed.todoPriority  isEqual: @"high"]){
        _todoPrioritySegementedControl.selectedSegmentIndex = 2;
    }
    
    if ([_todoPassed.todoStatus isEqual: @"todo"]) {
        _todoStatusSegementedControl.selectedSegmentIndex = 0;
    } else if ([_todoPassed.todoStatus isEqual: @"inProgrees"]) {
        _todoStatusSegementedControl.selectedSegmentIndex = 1;
    } else if ([_todoPassed.todoStatus isEqual: @"done"]) {
        _todoStatusSegementedControl.selectedSegmentIndex = 2;
    }
    
}


@end
