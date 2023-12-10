//
//  TodoModel.h
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TodoModel : NSObject<NSCoding,NSSecureCoding>
@property NSString* todoName;
@property NSString* todoDescription;
@property NSString* todoPriority;
@property NSString* todoStatus;
@property NSDate* todoDate;

//-(void) encodeWithCoder:(NSCoder*)coder;

@end

NS_ASSUME_NONNULL_END
