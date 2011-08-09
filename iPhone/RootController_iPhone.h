//
//  RootController_iPhone.h
//  Blogcaster
//
//  Created by Matthew Rushton on 8/10/10.
//  Copyright 2010 Blogcastr. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <Three20/Three20.h>
#import "Session.h"
#import "SignInController.h"


@interface RootController_iPhone : UINavigationController <SignInControllerProtocol> {
	NSManagedObjectContext *managedObjectContext;
	Session *session;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Session *session;

- (void)signIn;
- (void)signOut;

@end
