//
//  OAlbumManager.m
//  imageShareApp
//
//  Created by José Servet Font on 03/11/13.
//  Copyright (c) 2013 ByBDesigns. All rights reserved.
//

#import "OAlbumManager.h"

#import <AssetsLibrary/AssetsLibrary.h>

static OAlbumManager *gSharedInstance = nil;

@interface OAlbumManager (privateMethods)

- (id) initSharedInstance;
+ (OAlbumManager *) sharedInstance;

- (void) scanAlbumsWithBlock:(albumResultBlock)_block;

@end

@implementation OAlbumManager
{
	NSMutableArray *mDelegateArray;
}

- (id) init
{
	return nil;
}

+ (void) scanAlbumsWithBlock:(albumResultBlock)_block
{
	OAlbumManager *manager = [OAlbumManager sharedInstance];
	
	[manager scanAlbumsWithBlock:_block];
}

@end

@implementation OAlbumManager (privateMethods)

- (id) initSharedInstance
{
	self = [super init];
	if(self!=nil)
	{
		mDelegateArray = [[NSMutableArray alloc] initWithCapacity:0];
	}
	
	return self;
}

+ (OAlbumManager *) sharedInstance
{
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		gSharedInstance = [[OAlbumManager alloc] initSharedInstance];
	});
	
	return gSharedInstance;
}

- (void) scanAlbumsWithBlock:(albumResultBlock)_block
{
	ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
	NSMutableArray *albumArray = [NSMutableArray arrayWithCapacity:0];
	__block NSError *error = nil;
	
	[library enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos | ALAssetsGroupAlbum | ALAssetsGroupPhotoStream
						   usingBlock:^(ALAssetsGroup *group, BOOL *stop)
							{
								if(group!=nil)
									[albumArray addObject:group];
							}
						 failureBlock:^(NSError *_error)
							{
								error = _error;
							}];
	
	[albumArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
		ALAssetsGroup *gr1 = (ALAssetsGroup *)obj1;
		ALAssetsGroup *gr2 = (ALAssetsGroup *)obj2;
		
		return [[gr1 valueForProperty:ALAssetsGroupPropertyName] compare:[gr2 valueForProperty:ALAssetsGroupPropertyName]];
	}];
	
	if(_block!=nil)
		_block([NSArray arrayWithArray:albumArray], error);
}

@end
