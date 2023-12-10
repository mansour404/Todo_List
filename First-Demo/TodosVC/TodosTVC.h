//
//  ViewControllerOne.m
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//


#import <UIKit/UIKit.h>
#import "canUpdateTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TodosTVC : UIViewController <UITableViewDataSource, UITableViewDelegate, canUpdateTableView, UISearchBarDelegate>



@end

NS_ASSUME_NONNULL_END
