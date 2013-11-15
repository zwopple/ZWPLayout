#import <UIKit/UIKit.h>

@interface NSLayoutConstraint (ZWPLayout)

+ (instancetype)constraintWithLeftItem:(id)leftItem rightItem:(id)rightItem formula:(NSString *)formula, ...;

@end