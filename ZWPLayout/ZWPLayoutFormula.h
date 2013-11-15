#import <UIKit/UIKit.h>

@interface ZWPLayoutFormula : NSObject

#pragma mark - Properties

@property (nonatomic, assign, readonly) NSLayoutAttribute attribute;
@property (nonatomic, assign, readonly) NSLayoutRelation relation;
@property (nonatomic, assign, readonly) NSLayoutAttribute toAttribute;
@property (nonatomic, assign, readonly) CGFloat multiplier;
@property (nonatomic, assign, readonly) CGFloat constant;
@property (nonatomic, assign, readonly) NSUInteger priority;

#pragma mark - Initialization

+ (ZWPLayoutFormula *)formulaWithString:(NSString *)string;

@end
