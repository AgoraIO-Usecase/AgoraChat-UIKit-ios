/**
 *  \
 *  @header AgoraChatLocationMessageBody.h
 *  @abstract Location message body
 *  @author Hyphenate
 *  @version 3.00
 */

#import <Foundation/Foundation.h>

#import "AgoraChatMessageBody.h"

/**
 *  \
 *  The location message body.
 */
@interface AgoraChatLocationMessageBody : AgoraChatMessageBody

/**
 *  \
 *  The location latitude.
 */
@property (nonatomic) double latitude;

/**
 *  \
 *  The location longitude.
 */
@property (nonatomic) double longitude;

/**
 *  \
 *  The address.
 */
@property (nonatomic, copy) NSString * _Nullable address;

/**
 *  \
 *  buildingName
 */
@property (nonatomic, copy) NSString *_Nullable buildingName;

/**
 *  \
 *  Initializes a location message body instance.
 *
 *  @param aLatitude   The latitude.
 *  @param aLongitude  The longitude.
 *  @param aAddress    The address.
 *
 *  @result The location message body instance.
 */
- (instancetype _Nonnull)initWithLatitude:(double)aLatitude
                       longitude:(double)aLongitude
                         address:(NSString * _Nullable)aAddress;
/*!
 *  \
 *  Initialize a location message body instance
 *
 *  @param aLatitude   Latitude
 *  @param aLongitude  Longitude
 *  @param aAddress    Address
 *  @param aBuildingName    BuildingName
 *
 *  @result Location message body instance
 */
- (instancetype _Nonnull)initWithLatitude:(double)aLatitude
                       longitude:(double)aLongitude
                         address:(NSString *_Nullable)aAddress
                    buildingName:(NSString *_Nullable)aBuildingName;

-(instancetype _Nonnull ) init NS_UNAVAILABLE;
@end
