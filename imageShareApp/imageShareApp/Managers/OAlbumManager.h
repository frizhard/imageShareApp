//
//  OAlbumManager.h
//  imageShareApp
//
//  Created by José Servet Font on 03/11/13.
//  Copyright (c) 2013 ByBDesigns. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^albumResultBlock)(NSArray *_albumArray, NSError *_error);

@interface OAlbumManager : NSObject

+ (void) scanAlbumsWithBlock:(albumResultBlock)_block;

@end
