#import "ZWPLayoutFormula.h"
#import "ZWPLayoutMacros.h"

typedef NS_ENUM(NSInteger, ZWPLayoutFormulaToken) {
    ZWPLayoutFormulaTokenAttribute,
    ZWPLayoutFormulaTokenRelation,
    ZWPLayoutFormulaTokenMultiply,
    ZWPLayoutFormulaTokenAdd,
    ZWPLayoutFormulaTokenSubtract,
    ZWPLayoutFormulaTokenPriority,
    ZWPLayoutFormulaTokenNumber,
};


@interface ZWPLayoutFormula() {
}

#pragma mark - Properties

@property (nonatomic, assign) NSLayoutAttribute attribute;
@property (nonatomic, assign) NSLayoutRelation relation;
@property (nonatomic, assign) NSLayoutAttribute toAttribute;
@property (nonatomic, assign) CGFloat multiplier;
@property (nonatomic, assign) CGFloat constant;
@property (nonatomic, assign) NSUInteger priority;

@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSMutableArray *tokens;
@property (nonatomic, strong) NSMutableArray *tokensValues;
@property (nonatomic, assign) NSInteger scanLocation;

@end
@implementation ZWPLayoutFormula

#pragma mark - Initialization

+ (ZWPLayoutFormula *)formulaWithString:(NSString *)string {
    ZWPLayoutFormula *formula = [[self alloc] init];
    [formula evaluateWithString:string];
    return formula;
}

#pragma mark - Private Actions

- (void)evaluateWithString:(NSString *)string {
    self.string = string;
    [self tokenize];
    [self parse];
    self.tokens = nil;
    self.tokensValues = nil;
}
- (void)tokenize {
    // constants
    static NSDictionary *tokensLookup = nil;
    static NSDictionary *attributesLookup = nil;
    static NSDictionary *relationsLookup = nil;
    static dispatch_once_t tokensLookupOnce = 0;
    dispatch_once(&tokensLookupOnce, ^{
        tokensLookup = @{@"left": @(ZWPLayoutFormulaTokenAttribute),
                         @"right": @(ZWPLayoutFormulaTokenAttribute),
                         @"top": @(ZWPLayoutFormulaTokenAttribute),
                         @"bottom": @(ZWPLayoutFormulaTokenAttribute),
                         @"leading": @(ZWPLayoutFormulaTokenAttribute),
                         @"trailing": @(ZWPLayoutFormulaTokenAttribute),
                         @"width": @(ZWPLayoutFormulaTokenAttribute),
                         @"height": @(ZWPLayoutFormulaTokenAttribute),
                         @"centerX": @(ZWPLayoutFormulaTokenAttribute),
                         @"centerY": @(ZWPLayoutFormulaTokenAttribute),
                         @"baseline": @(ZWPLayoutFormulaTokenAttribute),
                         @"=": @(ZWPLayoutFormulaTokenRelation),
                         @">=": @(ZWPLayoutFormulaTokenRelation),
                         @"<=": @(ZWPLayoutFormulaTokenRelation),
                         @"*": @(ZWPLayoutFormulaTokenMultiply),
                         @"+": @(ZWPLayoutFormulaTokenAdd),
                         @"-": @(ZWPLayoutFormulaTokenSubtract),
                         @"@": @(ZWPLayoutFormulaTokenPriority)};
        
        attributesLookup = @{@"left": @(NSLayoutAttributeLeft),
                             @"right": @(NSLayoutAttributeRight),
                             @"top": @(NSLayoutAttributeTop),
                             @"bottom": @(NSLayoutAttributeBottom),
                             @"leading": @(NSLayoutAttributeLeading),
                             @"trailing": @(NSLayoutAttributeTrailing),
                             @"width": @(NSLayoutAttributeWidth),
                             @"height": @(NSLayoutAttributeHeight),
                             @"centerX": @(NSLayoutAttributeCenterX),
                             @"centerY": @(NSLayoutAttributeCenterY),
                             @"baseline": @(NSLayoutAttributeBaseline)};
        
        relationsLookup = @{@"=": @(NSLayoutRelationEqual),
                            @">=": @(NSLayoutRelationGreaterThanOrEqual),
                            @"<=": @(NSLayoutRelationLessThanOrEqual)};
    });
    
    // tokens
    self.tokens = [NSMutableArray array];
    self.tokensValues = [NSMutableArray array];
    
    // string scanner
    NSScanner *scanner = [[NSScanner alloc] initWithString:self.string];
    [scanner setCharactersToBeSkipped:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    while(![scanner isAtEnd]) {
        float floatValue = 0.0;
        if([scanner scanFloat:&floatValue]) {
            [self.tokens addObject:@(ZWPLayoutFormulaTokenNumber)];
            [self.tokensValues addObject:@(floatValue)];
            continue;
        }
        
        BOOL foundToken = NO;
        for(NSString *key in tokensLookup.allKeys) {
            if([scanner scanString:key intoString:nil]) {
                NSNumber *token = tokensLookup[key];
                [self.tokens addObject:token];
                switch(token.integerValue) {
                    case ZWPLayoutFormulaTokenAttribute:
                        [self.tokensValues addObject:attributesLookup[key]];
                        break;
                    case ZWPLayoutFormulaTokenRelation:
                        [self.tokensValues addObject:relationsLookup[key]];
                        break;
                    default:
                        [self.tokensValues addObject:key];
                        break;
                }
                foundToken = YES;
                break;
            }
        }
        if(foundToken) {
            continue;
        }
        
        ZWPLayoutAssert(NO, @"malformed formula scanning did not find valid token");
    }
}
- (void)parse {
    NSNumber *attribute = nil;
    NSNumber *relation = nil;
    NSNumber *multiplier = @(1.0);
    NSNumber *toAttribute = nil;
    NSNumber *constant = @(0.0);
    NSNumber *priority = @(UILayoutPriorityRequired);
    
    // scan attribute
    ZWPLayoutAssert([self scanAttributeIntoNumber:&attribute], @"missing left attribute");
    
    // scan relation
    ZWPLayoutAssert([self scanRelationIntoNumber:&relation], @"missing relation following left attribute");
    
    // multiplier -> attribute ||-> constant
    if([self scanMultiplierIntoNumber:&multiplier]) {
        ZWPLayoutAssert([self scanAttributeIntoNumber:&toAttribute], @"missing right attribute following multiplier");
        [self scanConstantIntoNumber:&constant];
    }
    // attribute ||-> constant
    else if([self scanAttributeIntoNumber:&toAttribute]) {
        [self scanConstantIntoNumber:&constant];
    }
    // constant
    else {
        ZWPLayoutAssert([self scanConstantIntoNumber:&constant], @"missing constant following relation");
    }
    
    // priority
    [self scanPriorityIntoNumber:&priority];
    
    // must be at end
    ZWPLayoutAssert([self scannerAtEnd], @"formula has unrecognized tokens at end");
    
    self.attribute = attribute.integerValue;
    self.relation = relation.integerValue;
    self.multiplier = multiplier.doubleValue;
    self.toAttribute = (toAttribute) ? toAttribute.integerValue : attribute.integerValue;
    self.constant = constant.doubleValue;
    self.priority = priority.unsignedIntegerValue;
    
}

- (BOOL)scannerAtEnd {
    return (self.scanLocation >= self.tokens.count);
}
- (BOOL)scanToken:(ZWPLayoutFormulaToken)token intoValue:(__autoreleasing id *)value {
    if([self scannerAtEnd]) {
        return NO;
    }
    
    ZWPLayoutFormulaToken scannedToken = [self.tokens[self.scanLocation] integerValue];
    if(scannedToken == token) {
        if(value) {
            *value = self.tokensValues[self.scanLocation];
        }
        self.scanLocation += 1;
        return YES;
    }
    return NO;
}
- (BOOL)scanAttributeIntoNumber:(__autoreleasing NSNumber **)number {
    return [self scanToken:ZWPLayoutFormulaTokenAttribute intoValue:number];
}
- (BOOL)scanRelationIntoNumber:(__autoreleasing NSNumber **)number {
    return [self scanToken:ZWPLayoutFormulaTokenRelation intoValue:number];
}
- (BOOL)scanMultiplierIntoNumber:(__autoreleasing NSNumber **)number {
    NSInteger restoreScanLocation = self.scanLocation;
    
    // scan value
    NSNumber *value = nil;
    if([self scanToken:ZWPLayoutFormulaTokenNumber intoValue:&value]) {
        // scan multiplier sign
        if([self scanToken:ZWPLayoutFormulaTokenMultiply intoValue:nil]) {
            if(number) {
                *number = value;
            }
            return YES;
        }
    }
    
    self.scanLocation = restoreScanLocation;
    return NO;
}
- (BOOL)scanConstantIntoNumber:(__autoreleasing NSNumber **)number {
    NSInteger restoreScanLocation = self.scanLocation;
    
    // scan add / subtract
    BOOL add = [self scanToken:ZWPLayoutFormulaTokenAdd intoValue:nil];
    BOOL subtract = (!add && [self scanToken:ZWPLayoutFormulaTokenSubtract intoValue:nil]);
    
    // scan value
    NSNumber *value = nil;
    if([self scanToken:ZWPLayoutFormulaTokenNumber intoValue:&value]) {
        if(subtract) {
            value = @(-value.doubleValue);
        }
        if(number) {
            *number = value;
        }
        return YES;
    }
    
    ZWPLayoutAssert(!add, @"missing number value after add");
    ZWPLayoutAssert(!subtract, @"missing number value after subtract");
    
    self.scanLocation = restoreScanLocation;
    return NO;
}
- (BOOL)scanPriorityIntoNumber:(__autoreleasing NSNumber **)number {
    NSInteger restoreScanLocation = self.scanLocation;
    
    if([self scanToken:ZWPLayoutFormulaTokenPriority intoValue:nil]) {
        NSNumber *value = nil;
        ZWPLayoutAssert([self scanToken:ZWPLayoutFormulaTokenNumber intoValue:&value], @"missing number following priority");
        ZWPLayoutAssert((value.integerValue >= 1 && value.integerValue <= 1000), ([NSString stringWithFormat:@"priority must be between 1-1000 got %@", value]));
        if(number) {
            *number = value;
        }
        return YES;
    }
    
    self.scanLocation = restoreScanLocation;
    return NO;
}

@end