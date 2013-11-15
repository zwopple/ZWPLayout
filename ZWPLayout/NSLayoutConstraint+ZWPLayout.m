#import "NSLayoutConstraint+ZWPLayout.h"
#import "ZWPLayoutFormula.h"
#import "ZWPLayoutMacros.h"

@implementation NSLayoutConstraint (ZWPLayout)

+ (instancetype)constraintWithLeftItem:(id)leftItem rightItem:(id)rightItem formula:(NSString *)formula, ... {
    va_list args;
    va_start(args, formula);
    formula = [[NSString alloc] initWithFormat:formula arguments:args];
    va_end(args);
    ZWPLayoutFormula *f = [ZWPLayoutFormula formulaWithString:formula];
    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:leftItem
                                                                  attribute:f.attribute
                                                                  relatedBy:f.relation
                                                                     toItem:rightItem
                                                                  attribute:(rightItem) ? f.toAttribute : NSLayoutAttributeNotAnAttribute
                                                                 multiplier:f.multiplier
                                                                   constant:f.constant];
    constraint.priority = f.priority;
    return constraint;
}

@end