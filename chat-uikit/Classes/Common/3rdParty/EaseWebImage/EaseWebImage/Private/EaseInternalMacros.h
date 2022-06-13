/*
 * This file is part of the EaseWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import <os/lock.h>
#import <libkern/OSAtomic.h>
#import "Easemetamacros.h"

#ifndef Ease_LOCK_DECLARE
#define Ease_LOCK_DECLARE(lock) os_unfair_lock lock;
#endif

#ifndef Ease_LOCK_INIT
#define Ease_LOCK_INIT(lock) lock = OS_UNFAIR_LOCK_INIT;
#endif

#ifndef Ease_LOCK
#define Ease_LOCK(lock) os_unfair_lock_lock(&lock);
#endif

#ifndef Ease_UNLOCK
#define Ease_UNLOCK(lock) os_unfair_lock_unlock(&lock);
#endif

#ifndef Ease_OPTIONS_CONTAINS
#define Ease_OPTIONS_CONTAINS(options, value) (((options) & (value)) == (value))
#endif

#ifndef Ease_CSTRING
#define Ease_CSTRING(str) #str
#endif

#ifndef Ease_NSSTRING
#define Ease_NSSTRING(str) @(Ease_CSTRING(str))
#endif

#ifndef Ease_SEL_SPI
#define Ease_SEL_SPI(name) NSSelectorFromString([NSString stringWithFormat:@"_%@", Ease_NSSTRING(name)])
#endif

#ifndef weakify
#define weakify(...) \
Ease_keywordify \
metamacro_foreach_cxt(Ease_weakify_,, __weak, __VA_ARGS__)
#endif

#ifndef strongify
#define strongify(...) \
Ease_keywordify \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
metamacro_foreach(Ease_strongify_,, __VA_ARGS__) \
_Pragma("clang diagnostic pop")
#endif

#define Ease_weakify_(INDEX, CONTEXT, VAR) \
CONTEXT __typeof__(VAR) metamacro_concat(VAR, _weak_) = (VAR);

#define Ease_strongify_(INDEX, VAR) \
__strong __typeof__(VAR) VAR = metamacro_concat(VAR, _weak_);

#if DEBUG
#define Ease_keywordify autoreleasepool {}
#else
#define Ease_keywordify try {} @catch (...) {}
#endif

#ifndef onExit
#define onExit \
Ease_keywordify \
__strong Ease_cleanupBlock_t metamacro_concat(Ease_exitBlock_, __LINE__) __attribute__((cleanup(Ease_executeCleanupBlock), unused)) = ^
#endif

typedef void (^Ease_cleanupBlock_t)(void);

#if defined(__cplusplus)
extern "C" {
#endif
    void Ease_executeCleanupBlock (__strong Ease_cleanupBlock_t *block);
#if defined(__cplusplus)
}
#endif
