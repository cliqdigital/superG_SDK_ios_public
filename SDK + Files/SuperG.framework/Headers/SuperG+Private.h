//
//  SuperG+Private.h
//  SuperG
//
//

#define BUTTONVIEWTAG 1234
#define PORTALVIEWTAG 2345

#import "SuperG.h"
#import <Foundation/Foundation.h>

@interface SuperG (Private)

@property(assign) id<SuperGSDKDelegate> delegate;

+ (SuperG*) instance;


@end
