//
//  BlogcastsController.h
//  Blogcastr
//
//  Created by Matthew Rushton on 4/2/11.
//  Copyright 2011 Blogcastr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Three20/Three20.h>
#import "TabToolbarController.h"
#import "RequestServer.h"
#import "Session.h"
#import "User.h"
#import "MBProgressHUD.h"

@interface BlogcastsController : UITableViewController <TabToolbarControllerProtocol, NSFetchedResultsControllerDelegate> {
	TabToolbarController *tabToolbarController;
	NSManagedObjectContext *managedObjectContext;
	NSFetchedResultsController *_fetchedResultsController;
	Session *session;
	User *user;
	TTTableHeaderDragRefreshView *dragRefreshView;
	TTTableFooterInfiniteScrollView *infiniteScrollView;
	//MVR - for the drag refresh view
	BOOL isRefreshing;
	BOOL isUpdating;
	BOOL isUpdatingFooter;
	NSNumber *_maxId;
	NSNumber *_minId;
	UIAlertView *_alertView;
	NSTimer *timer;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, readonly) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) Session *session;
@property (nonatomic, retain) User *user;
//AS DESIGNED: keep a weak reference to avoid retian cycles
@property (nonatomic, assign) TabToolbarController *tabToolbarController;
@property (nonatomic, retain) TTTableHeaderDragRefreshView *dragRefreshView;
@property (nonatomic, retain) TTTableFooterInfiniteScrollView *infiniteScrollView;
@property (nonatomic, retain) NSNumber *maxId;
@property (nonatomic, retain) NSNumber *minId;
@property (nonatomic, retain) UIAlertView *alertView;

- (NSURLConnection *)getUrl:(NSString *)url;
- (void)updateBlogcasts;
- (void)updateBlogcastsCell;
- (void)updateBlogcastsFooter;
- (void)showProgressHudWithLabelText:(NSString *)labelText animationType:(MBProgressHUDAnimation)animationType;
- (void)reloadTableView;
- (BOOL)save;
- (NSString *)avatarUrlForSize:(NSString *)size;
- (void)errorAlertWithTitle:(NSString *)title message:(NSString *)message;

@end
