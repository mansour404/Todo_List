//
//  TodoAddVC.m
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import "TodoAddVC.h"
#import "TodoModel.h"
#import "TodosTVC.h"

@interface TodoAddVC ()
@property (weak, nonatomic) IBOutlet UITextField *todoNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *todoDescriptionTextField;
@property (weak, nonatomic) IBOutlet UISegmentedControl *todoPrioritySegementedControl;
@property (weak, nonatomic) IBOutlet UIDatePicker *todoDate;


@property NSUserDefaults* defaults; // user defaults.
@property NSMutableArray <TodoModel*> *todosArray; // Array hold objects, update it when insert or delete.
@property TodoModel* todo; // single todo object.

@end

@implementation TodoAddVC

// Note
/*
    NSError *error;
    NSData *data = [_defaults objectForKey:@"todos" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    _todosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
    
 [_defaults setObject:data forKey:@"todos"];
*/

// MARK: - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"Add Todo"];
    
    // init todo
    _todo = [TodoModel new];
    // creaat an onjbject from userDefaults -singletone desing pattern-
    _defaults = [NSUserDefaults standardUserDefaults];

    // Save todoArray in userDefaults.
    NSError* error;
    // convert todosArray to NSData(binary data), so first object of array must conform <NSCoding,NSSecureCoding>
    NSData* data = [_defaults objectForKey:@"todos"];
    NSSet* set = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    
    // unarchivedObjectOfClasses, No known class method for selector 'archivedObjectOfClasses:fromData:error:'
    _todosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
    
    //NSData* archiveData = [NSKeyedArchiver archivedDataWithRootObject:_todosArray requiringSecureCoding:YES error:&error];

    // set object to userDefaults
    [_defaults setObject:data forKey:@"todos"];
    
    // check todos Array in first time array if empty so i intialize it.
    if(_todosArray == nil){
        _todosArray = [NSMutableArray new];
    }

    
}

- (IBAction)saveTodoButtonTapped:(id)sender {
    NSString* name = _todoNameTextField.text;
  
    // trimming white spaces
    NSString* todoNameTrimmmed = [name stringByTrimmingCharactersInSet:
                                 [NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([todoNameTrimmmed  isEqual: @""]) {
        [self configureAlertWithTitle:@"Todo Field is Empty" message:@"Please insert empty field/s"];
    } else {
        _todo.todoName = _todoNameTextField.text;
        _todo.todoDescription = _todoDescriptionTextField.text;
        _todo.todoDate = _todoDate.date;
        switch (_todoPrioritySegementedControl.selectedSegmentIndex) {
            case 0:
                _todo.todoPriority = @"low";
                break;
            case 1:
                _todo.todoPriority = @"med";
                break;
            case 2:
                _todo.todoPriority = @"high";
                break;
        }
        
        // any todo created status will be @"todo" by default.
        _todo.todoStatus = @"todo";
        
        
        [_todosArray addObject:_todo];
        
        NSError *error;
        NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:_todosArray requiringSecureCoding:YES error:&error];
        [_defaults setObject:savedData forKey:@"todos"];
        // why delegate work even if it after controller has been poped.
        // run delegate here, reload tableView in TodosTVC. before back.
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    // Delegate
    [_ref updateTodoTableView];
  
}

// MARK: - configureAlertWithTitle Function
-(void) configureAlertWithTitle: (NSString*) _title message: (NSString* ) _message {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    
    [alert addAction:action];
    [ self presentViewController:alert animated:YES completion:nil];
}



@end
