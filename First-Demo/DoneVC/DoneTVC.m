//
//  DoneVC.m
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import "DoneTVC.h"
#import "TodoModel.h"
#import "DoneDetailsVC.h"

@interface DoneTVC ()

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *doneTableView;

// Properties
@property NSUserDefaults* defaults; // user defaults.
@property NSMutableArray <TodoModel*> *doneTodosArray; // Array hold objects, can delte only in DoneTVC
@property TodoModel* todo; // single todo object.


// For Organize Button in tab bar
@property BOOL isOrganized;
@property NSMutableArray <TodoModel*> *todoLowArray;
@property NSMutableArray <TodoModel*> *todoMedArray;
@property NSMutableArray <TodoModel*> *todoHighArray;


@end

@implementation DoneTVC

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    NSError *error;
    
    // convert todosArray to NSData(binary data), so first object of array must conform <NSCoding,NSSecureCoding>
    NSData *data = [_defaults objectForKey:@"doneTodos" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    
    _doneTodosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
    [_doneTableView reloadData];
    _todoLowArray = [NSMutableArray new];
    _todoMedArray = [NSMutableArray new];
    _todoHighArray = [NSMutableArray new];
    [self getALLPriorityArrays];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // tableView dataSource and delegate = self
    _doneTableView.dataSource = self;
    _doneTableView.delegate = self;
    _isOrganized = NO;
    
    
    // creaat an onjbject from userDefaults -singletone desing pattern-
    _defaults = [NSUserDefaults standardUserDefaults];
    _todo = [TodoModel new];
    NSError *error;
    
    // convert todosArray to NSData(binary data), so first object of array must conform <NSCoding,NSSecureCoding>
    NSData *data = [_defaults objectForKey:@"doneTodos" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    _doneTodosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
    
}

// MARK: - Data Source and Delegate functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _isOrganized? 3 : 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
        return _doneTodosArray.count;
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
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"doneCell" forIndexPath:indexPath];
    
    if(_isOrganized) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone; // change selection style to none for for organized state
        switch(indexPath.section) {  // Becareful for section not row.
            case 0:
                _todo =[_todoLowArray objectAtIndex:indexPath.row];
                cell.textLabel.text = _todo.todoName;
                cell.detailTextLabel.text = _todo.todoDescription;
                if ([_todo.todoPriority isEqual: @"low"]) {
                    cell.imageView.image=[UIImage imageNamed:@"0"];
                } else if ([_todo.todoPriority  isEqual: @"med"]) {
                    cell.imageView.image=[UIImage imageNamed:@"1"];
                } else if ([_todo.todoPriority  isEqual: @"high"]) {
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
                } else if ([_todo.todoPriority  isEqual: @"med"]) {
                    cell.imageView.image=[UIImage imageNamed:@"1"];
                } else if ([_todo.todoPriority  isEqual: @"high"]) {
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
                } else if ([_todo.todoPriority  isEqual: @"med"]) {
                    cell.imageView.image=[UIImage imageNamed:@"1"];
                } else if ([_todo.todoPriority  isEqual: @"high"]) {
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
        _todo = [_doneTodosArray objectAtIndex:indexPath.row];
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
        _todo =[_doneTodosArray objectAtIndex:indexPath.row];
        
        // creat an instance of TodoEditVC
        DoneDetailsVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"DoneDetailsVC"];
        vc.todoPassed = _todo;
        vc.todoPassedIndex = indexPath.row;
        // push to navigationController
        [self.navigationController pushViewController:vc animated:YES];
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureAlertToDeleteTodoWithTitle:@"Delete Todo" message:@"Confirm delete Todo!" editingStyle:editingStyle indexPath:indexPath];
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
            
            [self.doneTodosArray removeObjectAtIndex:_indexPath.row];
            NSError *error;
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.doneTodosArray requiringSecureCoding:YES error:&error];
            [self.defaults setObject:data forKey:@"doneTodos"];
            
            [self.doneTableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.doneTableView reloadData];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmDeleteAction];
    [ self presentViewController:alert animated:YES completion:nil];
}

// MARK: - IBACtion
- (IBAction)organizeBarButtonTapped:(id)sender {
    _isOrganized = !_isOrganized;
    [_doneTableView reloadData];
}


// MARK: - Intialize Three array per Priority
-(void) getALLPriorityArrays {
    for (TodoModel* singleTodo in _doneTodosArray) {
        if([singleTodo.todoPriority  isEqual: @"low"])
            [_todoLowArray addObject:singleTodo];
        else if ([singleTodo.todoPriority  isEqual: @"med"])
            [_todoMedArray addObject:singleTodo];
        else if ([singleTodo.todoPriority isEqual:@"high"])
            [_todoHighArray addObject:singleTodo];
    }
}

@end
