#if NS_BLOCK_ASSERTIONS
#define ZWPLayoutAssert(condition, message) \
do { \
if(!(condition)) { \
[NSException raise:message format:nil]; \
} \
} while(0);
#else
#define ZWPLayoutAssert NSAssert
#endif