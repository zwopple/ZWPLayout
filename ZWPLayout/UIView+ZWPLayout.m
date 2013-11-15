#import "UIView+ZWPLayout.h"
#import "NSLayoutConstraint+ZWPLayout.h"
#import "ZWPLayoutMacros.h"

@implementation UIView (ZWPLayout)

#pragma mark - Formula

- (UIView *)zwp_layoutCommonSuperviewWithView:(UIView *)otherView {
    UIView *commonSuperview = nil;
    if(otherView != nil) {
        NSMutableSet *s1 = [NSMutableSet setWithObject:self];
        NSMutableSet *s2 = [NSMutableSet setWithObject:otherView];
        UIView *v1 = self;
        UIView *v2 = otherView;
        
        do {
            v1 = v1.superview;
            v2 = v2.superview;
            if(v1) {
                [s1 addObject:v1];
            }
            if(v2) {
                [s2 addObject:v2];
            }
            if([s1 intersectsSet:s2]) {
                [s1 intersectSet:s2];
                commonSuperview = [s1 anyObject];
                break;
            }
        } while(v1 && v2);
        
        ZWPLayoutAssert(commonSuperview != nil, @"No common superview");
    } else {
        commonSuperview = self.superview;
    }
    return commonSuperview;
}
- (ZWPLayoutViewConstraintsSet *)constrainToView:(UIView *)otherView formula:(NSString *)formula, ... {
    va_list args;
    va_start(args, formula);
    formula = [[NSString alloc] initWithFormat:formula arguments:args];
    va_end(args);
    
    ZWPLayoutAssert((self == otherView) == NO, @"Cannot constrain a view to itself");
    
    NSArray *subs = [formula componentsSeparatedByString:@","];
    NSMutableArray *constraints = [NSMutableArray array];
    for(NSString *sub in subs) {
        [constraints addObject:[NSLayoutConstraint constraintWithLeftItem:self rightItem:otherView formula:@"%@", sub]];
    }
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    ZWPLayoutViewConstraintsSet *constraintsSet = [[ZWPLayoutViewConstraintsSet alloc] initWithView:[self zwp_layoutCommonSuperviewWithView:otherView] constraints:constraints];
    constraintsSet.enabled = YES;
    
    return constraintsSet;
}
- (ZWPLayoutViewConstraintsSet *)constrainWithFormula:(NSString *)formula, ... {
    va_list args;
    va_start(args, formula);
    formula = [[NSString alloc] initWithFormat:formula arguments:args];
    va_end(args);
    
    return [self constrainToView:nil formula:formula];
}

#pragma mark - Helpers

- (void)zwp_convertConstraintsToFramesWithMapTable:(NSMapTable *)mapTable {
    if(!mapTable) {
        NSMapTable *mapTable = [NSMapTable strongToStrongObjectsMapTable];
        [mapTable setObject:@0 forKey:@"phase"];
        [self zwp_convertConstraintsToFramesWithMapTable:mapTable];
        [mapTable setObject:@1 forKey:@"phase"];
        [self zwp_convertConstraintsToFramesWithMapTable:mapTable];
    } else if([[mapTable objectForKey:@"phase"] integerValue] == 0) {
        CGRect r = self.frame;
        [mapTable setObject:[NSValue valueWithCGRect:r] forKey:self];
        for(UIView *subview in self.subviews) {
            [subview zwp_convertConstraintsToFramesWithMapTable:mapTable];
        }
        self.autoresizesSubviews = NO;
    } else if([[mapTable objectForKey:@"phase"] integerValue] == 1) {
        [self removeAllConstraints];
        self.autoresizingMask = 0;
        self.translatesAutoresizingMaskIntoConstraints = YES;
        self.frame = [(NSValue *)[mapTable objectForKey:self] CGRectValue];
        for(UIView *subview in self.subviews) {
            [subview zwp_convertConstraintsToFramesWithMapTable:mapTable];
        }
    }
}
- (void)convertConstraintsToFrames {
    [self zwp_convertConstraintsToFramesWithMapTable:nil];
}
- (void)removeAllConstraints {
    [self removeConstraints:self.constraints];
}

@end
