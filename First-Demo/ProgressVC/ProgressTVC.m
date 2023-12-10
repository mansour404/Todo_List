//
//  ProgressTVC.m
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import "ProgressTVC.h"
#import "TodoModel.h"
#import "TodoCell.h"
#import "ProgressEditVC.h"


@interface ProgressTVC ()
@property (weak, nonatomic) IBOutlet UITableView *progressTableView;

@property NSMutableArray <TodoModel*> *inPrograssTodosArray;

@property NSUserDefaults* defaults; // user defaults.
@property TodoModel* todo; // single todo object.

// For Organize Button
@property BOOL isOrganized;
@property NSMutableArray <TodoModel*> *todoLowArray;
@property NSMutableArray <TodoModel*> *todoMedArray;
@property NSMutableArray <TodoModel*> *todoHighArray;


@end

@implementation ProgressTVC

- (void)viewWillAppear:(BOOL)animated {
    [ super viewWillAppear: YES];
    NSError *error;
    
    // convert todosArray to NSData(binary data), so first object of array must conform <NSCoding,NSSecureCoding>
    NSData *data = [_defaults objectForKey:@"inProgressTodos" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    
    _inPrograssTodosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
    
    _todoLowArray = [NSMutableArray new];
    _todoMedArray = [NSMutableArray new];
    _todoHighArray = [NSMutableArray new];
    [self getALLPriorityArrays];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // tableView dataSource and delegate = self
    _progressTableView.dataSource = self;
    _progressTableView.delegate = self;
    _isOrganized = NO;
    
    // creaat an onjbject from userDefaults -singletone desing pattern-
    _defaults = [NSUserDefaults standardUserDefaults];
    _todo = [TodoModel new];
    NSError *error;
    
//    NSLog(@"%@", _inPrograssTodosArray.count);
    
    // convert todosArray to NSData(binary data), so first object of array must conform <NSCoding,NSSecureCoding>
    NSData *data = [_defaults objectForKey:@"inProgressTodos" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    
    // unarchivedObjectOfClasses, No known class method for selector 'archivedObjectOfClasses:fromData:error:'
    _inPrograssTodosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
}

// MARK: - Data Source and Delegate functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _isOrganized? 3 : 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //[self getALLPriorityArrays];
    if (_isOrganized) {
        switch (section) {
            case 0:
                return _todoLowArray.count;
                break;
            case 1:
                return _todoMedArray.count;
                break;
            case 2:
                return _todoHighArray.count;
                break;
            default:
                return 0;
        }
    } else {
        return _inPrograssTodosArray.count;
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (_isOrganized) {
        switch (section) {
            case 0:
                return @"low";
                break;
            case 1:
                return @"med";
                break;
            case 2:
                return @"high";
                break;
            default:
                return @"";
        }
    } else {
        return @"done todos";
    }
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"inProgressCell" forIndexPath:indexPath];
    
    if(_isOrganized) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone; // change selection style to none for for organized state
        switch(indexPath.section) {
            case 0:
                _todo =[_todoLowArray objectAtIndex:indexPath.row];
                cell.textLabel.text = _todo.todoName;
                cell.detailTextLabel.text = _todo.todoDescription;
                if ([_todo.todoPriority isEqual: @"low"]) {
                    cell.imageView.image=[UIImage imageNamed:@"0"];
                }else if ([_todo.todoPriority  isEqual: @"med"]) {
                    cell.imageView.image=[UIImage imageNamed:@"1"];
                }else if ([_todo.todoPriority  isEqual: @"high"]) {
                    cell.imageView.image=[UIImage imageNamed:@"2"];
                }
                return cell;
                break;
                
            case 1:
                _todo =[_todoMedArray objectAtIndex:indexPath.row];
                cell.textLabel.text = _todo.todoName;
                cell.detailTextLabel.text = _todo.todoDescription;
                if ([_todo.todoPriority isEqual: @"low"]) {
                    cell.imageView.image=[UIImage imageNamed:@"0"];
                }else if ([_todo.todoPriority  isEqual: @"med"]) {
                    cell.imageView.image=[UIImage imageNamed:@"1"];
                }else if ([_todo.todoPriority  isEqual: @"high"]) {
                    cell.imageView.image=[UIImage imageNamed:@"2"];
                }
                return cell;
                break;
            case 2:
                _todo =[_todoHighArray objectAtIndex:indexPath.row];
                cell.textLabel.text = _todo.todoName;
                cell.detailTextLabel.text = _todo.todoDescription;
                if ([_todo.todoPriority isEqual: @"low"]) {
                    cell.imageView.image=[UIImage imageNamed:@"0"];
                }else if ([_todo.todoPriority  isEqual: @"med"]) {
                    cell.imageView.image=[UIImage imageNamed:@"1"];
                }else if ([_todo.todoPriority  isEqual: @"high"]) {
                    cell.imageView.image=[UIImage imageNamed:@"2"];
                }
                return cell;
                break;
            default:
                return cell;
                break;
        }
    } else {
        cell.selectionStyle = UITableViewCellSelectionStyleGray; // change selection style to gray for not organized state
        _todo =[_inPrograssTodosArray objectAtIndex:indexPath.row];
        cell.textLabel.text = _todo.todoName;
        cell.detailTextLabel.text = _todo.todoDescription;
        
        if ([_todo.todoPriority isEqual: @"low"]) {
            cell.imageView.image=[UIImage imageNamed:@"0"];
        }else if ([_todo.todoPriority  isEqual: @"med"]) {
            cell.imageView.image=[UIImage imageNamed:@"1"];
        }else if ([_todo.todoPriority  isEqual: @"high"]) {
            cell.imageView.image=[UIImage imageNamed:@"2"];
        }
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // check condition to prevent open edit vc while table view is organized/sotred
    if (!_isOrganized) {
        // get specific todo by indexPath
        _todo =[_inPrograssTodosArray objectAtIndex:indexPath.row];
        
        // creat an instance of TodoEditVC
        ProgressEditVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ProgressEditVC"];
        
        // Delegate assign _ref to self
        [vc setRef:self];
        vc.todoPassed = _todo;
        vc.todoPassedIndex = indexPath.row;
        
        // push to navigationController
        [self.navigationController pushViewController:vc animated:YES];
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureAlertToDeleteTodoWithTitle:@"Delete Todo" message:@"Confirm delete todo!" editingStyle:editingStyle indexPath:indexPath];
}


// MARK: - Configure action Sheet
// Configure action sheet alert controller
-(void) configureAlertToDeleteTodoWithTitle: (NSString*) _title message: (NSString* ) _message editingStyle: (UITableViewCellEditingStyle) _editingStyle indexPath: (NSIndexPath *) _indexPath{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:_title message:_message preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    UIAlertAction* confirmDeleteAction = [UIAlertAction actionWithTitle:@"Confirm" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        if (_editingStyle == UITableViewCellEditingStyleDelete) {
            
            [self.inPrograssTodosArray removeObjectAtIndex:_indexPath.row];
            NSError *error;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.inPrograssTodosArray requiringSecureCoding:YES error:&error];
            [self.defaults setObject:data forKey:@"inProgressTodos"];
            
            [self.progressTableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.progressTableView reloadData];
        }
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmDeleteAction];
    [ self presentViewController:alert animated:YES completion:nil];
}

// MARK: - Conform updateTodoTableView Protocol
-(void)updateTodoTableView {

    NSError *error;
    // convert todosArray to NSData(binary data), so first object of array must conform <NSCoding,NSSecureCoding>
    NSData *data = [_defaults objectForKey:@"inProgressTodos" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];

    // unarchivedObjectOfClasses, No known class method for selector 'archivedObjectOfClasses:fromData:error:'
    _inPrograssTodosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
    [_progressTableView reloadData];
}

// MARK: - IBACtion
- (IBAction)organizeBarButtonTapped:(id)sender {
    _isOrganized = !_isOrganized;
    [_progressTableView reloadData];
}

// MARK: - Intialize Three array per Priority
-(void) getALLPriorityArrays {
    for (TodoModel* singleTodo in _inPrograssTodosArray) {
        if([singleTodo.todoPriority  isEqual: @"low"])
            [_todoLowArray addObject:singleTodo];
        else if ([singleTodo.todoPriority  isEqual: @"med"])
            [_todoMedArray addObject:singleTodo];
        else if ([singleTodo.todoPriority isEqual:@"high"])
            [_todoHighArray addObject:singleTodo];
    }
}

@end




