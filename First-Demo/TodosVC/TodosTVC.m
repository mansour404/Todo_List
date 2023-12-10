//
//  ViewControllerOne.m
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//


#import "TodosTVC.h"
#import "TodoCell.h"
#import "TodoAddVC.h"
#import "TodoEditVC.h"
#import "TodoModel.h"
#import "TodoAddVC.h"

@interface TodosTVC ()

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *todoTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *todoSearchBar;

// Properties
@property NSUserDefaults* defaults; // user defaults.
@property NSMutableArray <TodoModel*> *todosArray; // Array hold objects, update it when insert or delete.
@property TodoModel* todo; // single todo object.

// For search
@property BOOL isSearchFlag;
@property NSMutableArray <TodoModel*> *searchArray; // Array hold objects, update it when insert or delete.

@end

@implementation TodosTVC

// MARK: - ViewWillAppear
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
}

// MARK: - ViewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // tableView dataSource and delegate = self
    _todoTableView.dataSource = self;
    _todoTableView.delegate = self;
    
    // searchBar delegate = self
    _todoSearchBar.delegate = self;
    _isSearchFlag = NO;
    
    // creaat an onjbject from userDefaults -singletone desing pattern-
    _defaults = [NSUserDefaults standardUserDefaults];
    _todo = [TodoModel new];
    NSError *error;
    
    // convert todosArray to NSData(binary data), so first object of array must conform <NSCoding,NSSecureCoding>
    NSData *data = [_defaults objectForKey:@"todos" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    
    
    _todosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];

}

// MARK: - Data Source and Delegate functions
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // check is search or not.
    return _isSearchFlag? _searchArray.count : _todosArray.count;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TodoCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TodoCell" forIndexPath:indexPath];
   
    // check is Search or Not.
    if (_isSearchFlag) {
        _todo =[_searchArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone; // change selection style to none for searching state
    } else {
        _todo =[_todosArray objectAtIndex:indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleGray; // change selection style to gray for not search state
    }
    
    cell.todoTitleLabel.text = _todo.todoName;
    cell.todoDescriptionLabel.text = _todo.todoDescription;
    
    if ([_todo.todoPriority isEqual: @"low"]) {
        cell.todoImageView.image=[UIImage imageNamed:@"0"];
    }else if ([_todo.todoPriority  isEqual: @"med"]) {
        cell.todoImageView.image=[UIImage imageNamed:@"1"];
    }else if ([_todo.todoPriority  isEqual: @"high"]) {
        cell.todoImageView.image=[UIImage imageNamed:@"2"];
    }
    
    return  cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
   
    // check condition to prevent open edit view controller during searching.
    if (!_isSearchFlag) {
        // get specific todo by indexPath
        _todo =[_todosArray objectAtIndex:indexPath.row];
        
        // creat an instance of TodoEditVC
        TodoEditVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TodoEditVC"];
        
        // Delegate assign _ref to self
        [vc setRef:self];
        vc.todoPassed = _todo;
        vc.todoPassedIndex = indexPath.row;
        // push to navigationController
        [self.navigationController pushViewController:vc animated:YES];
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (_isSearchFlag) {
        return @"Filtered Tasks";
    } else {
        return @"Todo Tasks";
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    [self configureAlertToDeleteTodoWithTitle:@"Delete Todo" message:@"Confirm delete todo!" editingStyle:editingStyle indexPath:indexPath];
    
}


// MARK: - Search Bar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (![searchBar.text isEqual: @""]) { // if search bar field doesn't have any character
        _isSearchFlag = YES;
        [searchBar setTintColor:[UIColor blueColor]];
        _searchArray = [NSMutableArray new];
        TodoModel* oneTodo = [TodoModel new];
        
        for (int i=0; i< _todosArray.count; i++) {
            oneTodo = [_todosArray objectAtIndex:i];
            NSRange range = [oneTodo.todoName rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if(range.location !=NSNotFound){
                [_searchArray addObject:oneTodo];
            }
        }
    } else {
        _isSearchFlag = NO;
        [searchBar setTintColor:[UIColor clearColor]];
    }
    
    // need to update all dataSource and delegate mehtods, when search and when not search.
    [_todoTableView reloadData]; // You need to reload tableView
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
    if ([searchBar.text isEqual: @""]) {
        _isSearchFlag = NO;
        [_todoTableView reloadData];
    } else {
        _isSearchFlag = YES;
    }
    [_todoTableView reloadData];
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view resignFirstResponder];
    _isSearchFlag = NO;
    [_todoTableView reloadData];
}

// MARK: - IBAction Button
- (IBAction)gotoAddVCBarButtonItemTapped:(id)sender {
    TodoAddVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TodoAddVC"];
    
    // Delegate assign _ref to self
    [vc setRef:self];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)tableView:(UITableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath {

}


// MARK: - Conform updateTodoTableView Protocol
-(void)updateTodoTableView {
    
    NSError *error;
    
    // convert todosArray to NSData(binary data), so first object of array must conform <NSCoding,NSSecureCoding>
    NSData *data = [_defaults objectForKey:@"todos" ];
    NSSet *set = [NSSet setWithArray:@[[NSArray class],[TodoModel class]]];
    
    _todosArray = (NSMutableArray*)[NSKeyedUnarchiver unarchivedObjectOfClasses:set fromData:data error:&error];
    [_todoTableView reloadData];
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
            
                [self.todosArray removeObjectAtIndex:_indexPath.row];
                NSError *error;
                NSData *savedData = [NSKeyedArchiver archivedDataWithRootObject:self.todosArray requiringSecureCoding:YES error:&error];
                [self.defaults setObject:savedData forKey:@"todos"];

            [self.todoTableView deleteRowsAtIndexPaths:@[_indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.todoTableView reloadData];
    }];
    
    [alert addAction:cancelAction];
    [alert addAction:confirmDeleteAction];
    [ self presentViewController:alert animated:YES completion:nil];
}


@end
