#import <Foundation/Foundation.h>

@interface ZWPLayoutViewConstraintsSet : NSObject

#pragma mark - Properties

@property (nonatomic, weak, readonly) UIView *view;
@property (nonatomic, strong, readonly) NSArray *constraints;
@property (nonatomic, assign) BOOL enabled;

#pragma mark - Initialization

- (instancetype)initWithView:(UIView *)view constraints:(NSArray *)constraints;

@end
