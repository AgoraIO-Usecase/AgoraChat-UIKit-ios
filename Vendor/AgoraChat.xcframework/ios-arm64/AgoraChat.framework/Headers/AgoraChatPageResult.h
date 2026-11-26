/**
 *  \
 *  @header AgoraChatPageResult.h
 *  @abstract The subsection result.
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

/**
 *  \
 *  The sub-section result.
 */
@interface AgoraChatPageResult<__covariant ObjectType> : NSObject

/**
 *  \
 *  The result list.
 */
@property (nonatomic, strong) NSArray<ObjectType> *_Nullable list;

/**
 *  \
 *  The count of the current list.
 */
@property (nonatomic) NSInteger count;

/**
 *  \
 *  Gets the result instance.
 *
 *  @param aList    The result list. 
 *  @param aCount   The count of current list.
 *
 *  @result         The instance of cursor result.
 */
+ (instancetype _Nonnull)pageResultWithList:(NSArray<ObjectType> * _Nullable)aList
                          andCount:(NSInteger)aCount;

@end
