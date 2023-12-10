//
//  ProgressEditVC.h
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import <UIKit/UIKit.h>
#import "TodoModel.h"
#import "canUpdateTableView.h"


NS_ASSUME_NONNULL_BEGIN

@interface ProgressEditVC : UIViewController

@property TodoModel *todoPassed;
@property NSInteger todoPassedIndex;

@property id<canUpdateTableView> ref;

@end

NS_ASSUME_NONNULL_END
