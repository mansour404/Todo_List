//
//  ProgressEditVC.m
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import "ProgressEditVC.h"

@interface ProgressEditVC () {
    NSData* data;
    NSSet* set;
    NSData* inPrograssData;
    NSSet* inPrograssSet;
    NSData* doneData;
    NSSet* doneSet;
}

// UI Property
@property (weak, nonatomic) IBOutlet UITextField *todoNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *todoDescriptionTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *todoPrioritySegementedControl;
@property (weak, nonatomic) IBOutlet UISegmentedControl *todoStatusSegementedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *todoDate;

// Variables
@property NSUserDefaults* defaults;
@property NSMutableArray <TodoModel*> *inPrograssTodosArray;
@property NSMutableArray <TodoModel*> *doneTodosArray;

//@property TodoModel* inPrograssTodo;
//@property TodoModel* doneTodo;

@end

@implementation ProgressEditVC

- (void)viewDidLoad {
    [super viewDidLoad];

    // Set UI attribute Values
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
    
    if ([_todoPassed.todoStatus isEqual: @"inProgrees"]) {
        _todoStatusSegementedControl.selectedSegmentIndex = 1;
    } else if ([_todoPassed.todoStatus isEqual: @"done"]) {
        _todoStatusSegementedControl.selectedSegmentIndex = 2;
    }
    
    
    
//    _inPrograssTodo =[TodoModel new];
//    _doneTodo =[TodoModel new];
    _defaults = [NSUserDefaults standardUserDefaults];
    NSError *error;
    
    inPrograssData = [_defaults objectForKey:@"inProgressTodos" ];
    inPrograssSet = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    _inPrograssTodosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:inPrograssSet fromData:inPrograssData error:&error];
    
    doneData = [_defaults objectForKey:@"doneTodos" ];
    doneSet = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    _doneTodosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:doneSet fromData:doneData error:&error];

    
 
    if(_inPrograssTodosArray == nil){
        _inPrograssTodosArray = [NSMutableArray new];
    }
    if(_doneTodosArray == nil){
        _doneTodosArray = [NSMutableArray new];
    }
}

// MARK: - Edit Button
- (IBAction)editTodoButtonTapped:(id)sender {
    NSError* error;
    NSString* name = _todoNameTextField.text;
    
    // trimming white spaces
    NSString* todoNameTrimmmed = [name stringByTrimmingCharactersInSet:
                                  [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([todoNameTrimmmed  isEqual: @""]) {
        [self configureAlertWithTitle:@"Todo Field is Empty" message:@"Please insert empty field/s"];
    } else {
        _todoPassed.todoName = _todoNameTextField.text;
        _todoPassed.todoDescription = _todoDescriptionTextField.text;
        _todoPassed.todoDate = _todoDate.date;
        switch (_todoPrioritySegementedControl.selectedSegmentIndex) {
            case 0:
                _todoPassed.todoPriority = @"low";
                break;
            case 1:
                _todoPassed.todoPriority = @"med";
                break;
            case 2:
                _todoPassed.todoPriority = @"high";
                break;
        }
        
        // MARK: Save Status Segemente and Update Arrays.
        switch (_todoStatusSegementedControl.selectedSegmentIndex) {
            case 1:
                _todoPassed.todoStatus = @"inProgrees";
                break;
            case 2:
                _todoPassed.todoStatus = @"done";
                break;
            default:
                _todoPassed.todoStatus = @"inProgrees";
                break;
        }
        
        if([_todoPassed.todoStatus isEqualToString:@"inProgrees"]) {
            // 1- update todo in PrograssTodosArray
            [_inPrograssTodosArray replaceObjectAtIndex:_todoPassedIndex withObject:_todoPassed]; // replace
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_inPrograssTodosArray requiringSecureCoding:YES error:&error];
            [_defaults setObject:data forKey:@"inProgressTodos"];
            
        } else/*([_todoPassed.todoStatus isEqualToString:@"done"])*/{
            // 2- move todo to doneTodos
            [_doneTodosArray addObject: _todoPassed];
            [_inPrograssTodosArray removeObjectAtIndex:_todoPassedIndex]; // remove from todosArray
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_inPrograssTodosArray requiringSecureCoding:YES error:&error];
            [_defaults setObject:data forKey:@"inProgressTodos"];

            NSData* data2 = [NSKeyedArchiver archivedDataWithRootObject:_doneTodosArray requiringSecureCoding:YES error:&error];
            [_defaults setObject:data2 forKey:@"doneTodos"];
        }
        
    }

    // run delegate here, reload tableView in ProgressTVC. before back.
    // Delegate
    [_ref updateTodoTableView];
    [self.navigationController popViewControllerAnimated:YES];
}

// MARK: - ConfigureAlertWithTitle Function
-(void) configureAlertWithTitle: (NSString*) _title message: (NSString* ) _message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    [ self presentViewController:alert animated:YES completion:nil];
}

@end
