/**
 *  \
 *  @header     AgoraChatCursorResult.h
 *  @abstract   Subsection result
 *  @author     Hyphenate
 *  @version    3.00
 */

#import <Foundation/Foundation.h>

/**
 *  \
 * 
 *  The EmCursorResult interface, which displays query results such as conversations and group chats.
 */
@interface AgoraChatCursorResult<__covariant ObjectType> : NSObject

/**
 *  \
 *  The result list.
 */
@property (nonatomic, strong) NSArray<ObjectType> * _Nullable list;

/**
 *  \
 *  The cursor for retrieving the result of the next section.
 */
@property (nonatomic, copy) NSString * _Nullable cursor;

/**
 *  \
 *  Gets the result instance.
 *
 *  @param aList    The result list.
 *  @param aCusror  The cursor for retrieving the result of the next section.
 *
 *  @result An instance of the cursor result.
 */
+ (instancetype _Nonnull)cursorResultWithList:(NSArray<ObjectType> * _Nullable)aList
                           andCursor:(NSString * _Nullable)aCusror;

@end
