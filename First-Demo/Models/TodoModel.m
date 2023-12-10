//
//  TodoModel.m
//  First-Demo
//
//  Created by Mohammed Adel on 30/08/2023.
//

#import "TodoModel.h"

@implementation TodoModel

// encode with specific key.
- (void)encodeWithCoder:(nonnull NSCoder*)coder {
    [coder encodeObject:_todoName forKey:@"todoName"];
    [coder encodeObject:_todoDescription forKey:@"todoDescription"];
    [coder encodeObject:_todoDate forKey:@"todoDate"];
    [coder encodeObject:_todoPriority forKey:@"todoPriority"];
    [coder encodeObject:_todoStatus forKey:@"todoStatus"];
}

// decode with specific key.
// decode from binary to string Values for example.
- (id)initWithCoder:(nonnull NSCoder*)coder {
    self.todoName = [coder decodeObjectOfClass:[NSString class] forKey:@"todoName"];
    self.todoDescription = [coder decodeObjectOfClass:[NSString class] forKey:@"todoDescription"];
    self.todoDate = [coder decodeObjectOfClass:[NSDate class] forKey:@"todoDate"];
    self.todoPriority = [coder decodeObjectOfClass:[NSString class] forKey:@"todoPriority"];
    self.todoStatus = [coder decodeObjectOfClass:[NSString class] forKey:@"todoStatus"];

    return self;
}


+ (BOOL)supportsSecureCoding{
    return YES;
}


@end
