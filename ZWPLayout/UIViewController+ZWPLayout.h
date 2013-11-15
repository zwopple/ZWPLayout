#import <UIKit/UIKit.h>

@interface UIViewController (ZWPLayout)

- (void)addConstraintsSet:(ZWPLayoutViewConstraintsSet *)constraintsSet tag:(NSString *)tag;
- (void)removeConstraintsSetsWithTag:(NSString *)tag;
- (void)enableConstraintsSetsWithTag:(NSString *)tag;
- (void)disableConstraintsSetsWithTag:(NSString *)tag;

@end
