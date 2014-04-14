//
//  EVA.h
//  SuperG
//
//

#import "SuperG.h"
#import <Foundation/Foundation.h>
#import <SystemConfiguration/SystemConfiguration.h>

/** Events API */
@interface EVA : SuperG

/** Checks what other apps are installed on the device */
+ (void) detectInstalledApplications;

/** Syncs the locally stored events with the remote server. Fires itself every 20 seconds */
+ (void) syncEvents;

/** TODO: add description*/
+ (void) invalidateSessionTimer;

/** Event fired automatically by SuperG SDK when the app is launched for the first time on a device. */
+ (void) appInstalled;

/** TODO: add description*/
+ (void) deviceInfoUpdate;

/** Get installation ID */
+ (NSString*) getInstallationId;

/** Event fired automatically by SuperG SDK when the app enters the foreground */
+ (void) applicationGetFocus;

/** Click event
@param clickedItem the item clicked on by the user
 */
+ (void) click:(NSString*)clickedItem;

/** Event to call when a user finishes a level
@param level The finished level.
@param game_mode string to describe a game mode.
@param score_type The type of score.
@param score_value The score the player has.
 */
+ (void) finish_level:(NSString*)level inMode:(NSString*)game_mode withScoreType: (NSString*)score_type andScoreValue: (NSString*)score_value;

/**
 Event to call when the user does an in-app purchase.
 @param currency The currency being used
 @param payment_method For example: Credit card, paypall, DCB, etc.
 @param price The price of the bought item
 @param purchased_item The item bought
*/
+(void)purchase: (NSString*)purchased_item WithCurrency: (NSString*)currency PaymentMethod:(NSString*)payment_method AndPrice:(NSString*)price;

/** Event to call when the user earns an achievement
@param achievementName Name of the achievement earned
 */
+(void) achievementEarned:(NSString*)achievementName;

/** 
 Event to call when a user starts a level.
 @param level The level that was started.
 @param game_mode String to describe a game mode.
 @param score_type String to describe a score type.
 @param score_value String having the score value.
 */
+ (void) start_level:(NSString*)level inMode:(NSString*)game_mode withScoreType: (NSString*)score_type andScoreValue: (NSString*)score_value;

/** 
 Event to call when the user does an up-sell. E.g. upgrades to premium.
@param currency the currency being used
@param payment_method for example: Credit card, paypall, DCB, etc.
*/
+(void)upSell:(NSString*)currency PaymentMethod:(NSString*)payment_method;

/** TODO: add description*/
+ (void) sessionTimer;
@end
