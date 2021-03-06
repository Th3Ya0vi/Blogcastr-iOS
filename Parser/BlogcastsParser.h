//
//  BlogcastsParser.h
//  Blogcastr
//
//  Created by Matthew Rushton on 4/12/11.
//  Copyright 2011 Blogcastr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "User.h"


@interface BlogcastsParser : NSObject <NSXMLParserDelegate> {
	NSData *data;
	NSManagedObjectContext *managedObjectContext;
	//MVR - xml parser
    NSMutableString *mutableString;
	NSNumber *blogcastId;
	NSString *title;
	NSString *theDescription;
	User *user;
	NSNumber *userId;
	NSString *userUsername;
	NSString *userAvatarUrl;
	NSString *tags;
	NSString *imageUrl;
	NSNumber *imageWidth;
	NSNumber *imageHeight;
	NSNumber *numCurrentViewers;
	NSNumber *numPosts;
	NSNumber *numComments;
	NSNumber *numLikes;
	NSNumber *numViews;
	NSDate *startingAt;
	NSDate *blogcastUpdatedAt;
    NSString *url;
    NSString *shortUrl;
	BOOL inUser;
	BOOL inTags;
	BOOL inStats;
	NSMutableArray *blogcasts;
}

@property (nonatomic, retain) NSData *data;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
//AS DESIGNED: copy always returns an immutable string
@property (nonatomic, retain) NSString *mutableString;
@property (nonatomic, retain) NSNumber *blogcastId;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *theDescription;
@property (nonatomic, retain) User *user;
@property (nonatomic, retain) NSNumber *userId;
@property (nonatomic, retain) NSString *userUsername;
@property (nonatomic, retain) NSString *userAvatarUrl;
@property (nonatomic, retain) NSString *tags;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSNumber *imageWidth;
@property (nonatomic, retain) NSNumber *imageHeight;
@property (nonatomic, retain) NSNumber *numCurrentViewers;
@property (nonatomic, retain) NSNumber *numPosts;
@property (nonatomic, retain) NSNumber *numComments;
@property (nonatomic, retain) NSNumber *numLikes;
@property (nonatomic, retain) NSNumber *numViews;
@property (nonatomic, retain) NSDate *startingAt;
@property (nonatomic, retain) NSDate *blogcastUpdatedAt;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSString *shortUrl;
@property (nonatomic, retain) NSMutableArray *blogcasts;

- (BOOL)parse;

@end
