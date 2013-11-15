#import "UIViewController+ZWPLayout.h"

@implementation UIViewController (ZWPLayout)

- (NSMutableDictionary *)zwp_constraintsSetsByTags {
    static void *constraintsSetsByTags = &constraintsSetsByTags;
    NSMutableDictionary *d = objc_getAssociatedObject(self, constraintsSetsByTags);
    if(!d) {
        d = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, constraintsSetsByTags, d, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return d;
}
- (NSMutableArray *)zwp_constraintsSetsForTag:(NSString *)tag {
    NSParameterAssert(tag);
    NSMutableDictionary *d = [self zwp_constraintsSetsByTags];
    NSMutableArray *a = d[tag];
    if(!a) {
        a = [NSMutableArray array];
        d[tag] = a;
    }
    return a;
}
- (void)addConstraintsSet:(ZWPLayoutViewConstraintsSet *)constraintsSet tag:(NSString *)tag {
    NSParameterAssert(constraintsSet);
    NSParameterAssert(tag);
    [[self zwp_constraintsSetsForTag:tag] addObject:constraintsSet];
    constraintsSet.enabled = NO;
}
- (void)removeConstraintsSetsWithTag:(NSString *)tag {
    NSParameterAssert(tag);
    for(ZWPLayoutViewConstraintsSet *constraintsSet in [self zwp_constraintsSetsForTag:tag]) {
        constraintsSet.enabled = NO;
    }
    [[self zwp_constraintsSetsForTag:tag] removeAllObjects];
}
- (void)enableConstraintsSetsWithTag:(NSString *)tag {
    NSParameterAssert(tag);
    for(ZWPLayoutViewConstraintsSet *constraintsSet in [self zwp_constraintsSetsForTag:tag]) {
        constraintsSet.enabled = YES;
    }
}
- (void)disableConstraintsSetsWithTag:(NSString *)tag {
    NSParameterAssert(tag);
    for(ZWPLayoutViewConstraintsSet *constraintsSet in [self zwp_constraintsSetsForTag:tag]) {
        constraintsSet.enabled = NO;
    }
}

@end
