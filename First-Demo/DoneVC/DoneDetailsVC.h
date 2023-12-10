//
//  DoneEditVC.h
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import <UIKit/UIKit.h>
#import "TodoModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface DoneDetailsVC : UIViewController

@property TodoModel *todoPassed;
@property NSInteger todoPassedIndex;

@end

NS_ASSUME_NONNULL_END
