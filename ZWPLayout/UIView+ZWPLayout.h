#import <UIKit/UIKit.h>
#import "ZWPLayoutViewConstraintsSet.h"

@interface UIView (ZWPLayout)

#pragma mark - Formula

- (ZWPLayoutViewConstraintsSet *)constrainToView:(UIView *)otherView formula:(NSString *)formula, ...;
- (ZWPLayoutViewConstraintsSet *)constrainWithFormula:(NSString *)formula, ...;

#pragma mark - Helpers

- (void)convertConstraintsToFrames;
- (void)removeAllConstraints;

@end