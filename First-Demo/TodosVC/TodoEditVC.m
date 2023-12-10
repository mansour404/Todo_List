//
//  TodoEditVC.m
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import "TodoEditVC.h"
#import "TodosTVC.h"


@interface TodoEditVC () {
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
@property NSMutableArray <TodoModel*> *todosArray;


@property TodoModel* inPrograssTodo;
@property TodoModel* doneTodo;

// Two Extra Array for filtering todos by status
@property NSMutableArray <TodoModel*> *doneTodosArray;
@property NSMutableArray <TodoModel*> *inPrograssTodosArray;

@end


@implementation TodoEditVC


// MARK: - View did load
- (void)viewDidLoad {
    [super viewDidLoad];
    
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
 
    // it will always be index 1
    _todoStatusSegementedControl.selectedSegmentIndex = 0;
    
    
    
    //NSLog(@"%@", _todoStatusSegementedControl.selectedSegmentIndex);
    
    // hold data for todo if changed from todo to (inProgress or done)
    _inPrograssTodo =[TodoModel new];
    _doneTodo =[TodoModel new];
    
    // onjbject from userDefaults, Save todoArray in userDefaults.
    _defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSError* error;
    
    // 1-_todosArray
    data = [_defaults objectForKey:@"todos" ];
    set = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    _todosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
    
    
    // 2- inPrograssTodosArray
    inPrograssData = [_defaults objectForKey:@"inProgressTodos" ];
    inPrograssSet = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    _inPrograssTodosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:inPrograssSet fromData:inPrograssData error:&error];
    //[_defaults setObject:inPrograssData forKey:@"inProgressTodos"];
    
    // 3- doneTodosArray
    doneData = [_defaults objectForKey:@"doneTodos" ];
    doneSet = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    _doneTodosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:doneSet fromData:doneData error:&error];
    //[_defaults setObject:doneData forKey:@"doneTodos"];
    
    
    
    // check Arrays, in first time array is empty so i intialize it.
    //    if(_todosArray == nil){  // will not be nill
    //        _todosArray = [NSMutableArray new];
    //    }
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
            case 0:
                _todoPassed.todoStatus = @"todo";
                break;
            case 1:
                _todoPassed.todoStatus = @"inProgrees";
                break;
            case 2:
                _todoPassed.todoStatus = @"done";
                break;
            default:
                _todoPassed.todoStatus = @"todo";
                break;
        }
        
        if([_todoPassed.todoStatus isEqualToString:@"todo"]) {
            // 1- update todo in todos
            [_todosArray replaceObjectAtIndex:_todoPassedIndex withObject:_todoPassed]; // replace
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_todosArray requiringSecureCoding:YES error:&error];
            [_defaults setObject:data forKey:@"todos"];
            
        } else if ([_todoPassed.todoStatus isEqualToString:@"inProgrees"]){
            // 2- move todo to inprogress
            [_inPrograssTodosArray addObject: _todoPassed];
            [_todosArray removeObjectAtIndex:_todoPassedIndex]; // remove from todosArray
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_todosArray requiringSecureCoding:YES error:&error];
            [_defaults setObject:data forKey:@"todos"];

            NSData* data2 = [NSKeyedArchiver archivedDataWithRootObject:_inPrograssTodosArray requiringSecureCoding:YES error:&error];
            [_defaults setObject:data2 forKey:@"inProgressTodos"];
            
        } else /*([_todoPassed.todoStatus isEqualToString:@"done"]) */{
            // 3- move todo to indone
            [_doneTodosArray addObject: _todoPassed];
            [_todosArray removeObjectAtIndex:_todoPassedIndex]; // remove from todosArray
            NSData* data = [NSKeyedArchiver archivedDataWithRootObject:_todosArray requiringSecureCoding:YES error:&error];
            [_defaults setObject:data forKey:@"todos"];

            NSData* data2 = [NSKeyedArchiver archivedDataWithRootObject:_doneTodosArray requiringSecureCoding:YES error:&error];
            [_defaults setObject:data2 forKey:@"doneTodos"];
        }
        
    }

    // run delegate here, reload tableView in TodosTVC. before back.
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

