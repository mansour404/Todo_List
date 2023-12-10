//
//  TodoCell.h
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *todoTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *todoDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *todoImageView;

@end

NS_ASSUME_NONNULL_END
