#import "ZWPLayoutViewConstraintsSet.h"

@implementation ZWPLayoutViewConstraintsSet

#pragma mark - Properties

- (void)setEnabled:(BOOL)enabled {
    if(_enabled != enabled) {
        _enabled = enabled;
        if(_enabled) {
            [self.view addConstraints:self.constraints];
        } else {
            [self.view removeConstraints:self.constraints];
        }
    }
}

#pragma mark - Initialization

- (instancetype)initWithView:(UIView *)view constraints:(NSArray *)constraints {
    if((self = [super init])) {
        _view = view;
        _constraints = [constraints copy];
        _enabled = NO;
    }
    return self;
}

@end
