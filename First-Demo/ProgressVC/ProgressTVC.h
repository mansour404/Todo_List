//
//  ProgressTVC.h
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import <UIKit/UIKit.h>
#import "canUpdateTableView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ProgressTVC : UIViewController <UITableViewDataSource, UITableViewDelegate, canUpdateTableView>

@end

NS_ASSUME_NONNULL_END
