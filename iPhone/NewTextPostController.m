//
//  NewTextPostController.m
//  Blogcastr
//
//  Created by Matthew Rushton on 5/1/11.
//  Copyright 2011 Blogcastr. All rights reserved.
//

#import <Three20/Three20.h>
#import "NewTextPostController.h"
#import "TwitterConnectController.h"
#import "ASIFormDataRequest.h"
#import "MBProgressHUD.h"
#import "BlogcastrStyleSheet.h"
#import "UINavigationBar+ButtonColor.h"


@implementation NewTextPostController


@synthesize managedObjectContext;
@synthesize session;
@synthesize facebook;
@synthesize blogcast;
@synthesize textView;
@synthesize twitterSwitch;
@synthesize facebookSwitch;
@synthesize progressHud;
@synthesize cancelActionSheet;
@synthesize cancelRequestActionSheet;
@synthesize alertView;
@synthesize request;

#pragma mark -
#pragma mark Initialization

- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    self = [super initWithStyle:style];
    if (self) {
		UIBarButtonItem *cancelButton;
		UIBarButtonItem *postButton;
        
		// Custom initialization.
		self.navigationItem.title = @"New Text Post";
		cancelButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleBordered target:self action:@selector(cancel)];
		cancelButton.title = @"Cancel";
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];
		postButton = [[UIBarButtonItem alloc] initWithImage:nil style:UIBarButtonItemStyleBordered target:self action:@selector(post)];
		postButton.title = @"Post";
		self.navigationItem.rightBarButtonItem = postButton;
		[postButton release];
    }
    return self;
}


#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
	UITextView *theTextView;
    UISwitch *theSwitch;
	
    [super viewDidLoad];

    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.tableView.backgroundColor = TTSTYLEVAR(backgroundColor);
	theTextView = [[UITextView alloc] initWithFrame:CGRectMake(2.0, 4.0, 296.0, 112.0)];
	theTextView.delegate = self;
	//MVR - slight hack with insets to make the top align a little nicer
	theTextView.contentInset = UIEdgeInsetsMake(-4.0, 0.0, 0.0, 0.0);
	theTextView.backgroundColor = [UIColor clearColor];	
	theTextView.font = [UIFont systemFontOfSize:15.0];
	theTextView.textColor = BLOGCASTRSTYLEVAR(blueTextColor);
	self.textView = theTextView;
	[theTextView release];
    theSwitch = [[UISwitch alloc] init];
    [theSwitch addTarget:self action:@selector(twitterSwitchChanged) forControlEvents:UIControlEventValueChanged];
	self.twitterSwitch = theSwitch;
	[theSwitch release];
	theSwitch = [[UISwitch alloc] init];
	self.facebookSwitch = theSwitch;
	[theSwitch release];
	//MVR - disable post button
	self.navigationItem.rightBarButtonItem.enabled = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!session.user.twitterAccessToken || !session.user.twitterTokenSecret)
        [twitterSwitch setOn:NO animated:NO];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 2;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if (section == 0)
        return 1;
    else if (section == 1)
        return 2;

    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0)
		return 120.0;
    else if (indexPath.section == 1)
		return 44.0;

	return 0;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell;

	// Configure the cell...

	//AS DESIGNED: only a few cells no need to make them reusable
	cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil] autorelease];
	if (indexPath.section == 0) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		[cell.contentView addSubview:textView];
	} else if (indexPath.section == 1) {
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		if (indexPath.row == 0) {
			cell.textLabel.text = @"Facebook";
			cell.accessoryView = facebookSwitch;		
		} else if (indexPath.row == 1) {
			cell.textLabel.text = @"Twitter";
			cell.accessoryView = twitterSwitch;
		}
	}

    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source.
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == 0)
		return @"Text";
    else if (section == 1)
		return @"Share";
	
	return nil;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
    /*
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
    */
}


#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
	self.textView = nil;
    self.facebookSwitch = nil;
    self.twitterSwitch = nil;
}

- (void)dealloc {
    [managedObjectContext release];
    [session release];
    [facebook release];
    [blogcast release];
    [textView release];
    [facebookSwitch release];
    [twitterSwitch release];
    _progressHud.delegate = nil;
	[_progressHud release];
	[_cancelActionSheet release];
	[_cancelRequestActionSheet release];
	[_alertView release];
    [request clearDelegatesAndCancel];
	[request release];
    [super dealloc];
}

- (UIActionSheet *)cancelActionSheet {
	if (!_cancelActionSheet)
		_cancelActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Discard Post" otherButtonTitles: nil];
	
	return _cancelActionSheet;
}

- (UIActionSheet *)cancelRequestActionSheet {
	if (!_cancelRequestActionSheet)
		_cancelRequestActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Discard Post" otherButtonTitles:@"Cancel Upload", nil];
	
	return _cancelRequestActionSheet;
}

- (MBProgressHUD *)progressHud {
	if (!_progressHud) {
		//MVR - use superview to handle a display bug
		_progressHud = [[MBProgressHUD alloc] initWithView:self.view.superview];
		_progressHud.delegate = self;
	}
	
	return _progressHud;
}

- (UIAlertView *)alertView {
	if (!_alertView) {
		_alertView = [[UIAlertView alloc] init];
		[_alertView addButtonWithTitle:@"Ok"];
	}
	
	return _alertView;
}

#pragma mark -
#pragma mark ASIHTTPRequest delegate

- (void)newTextPostFinished:(ASIHTTPRequest *)theRequest {
	int statusCode;
	
	self.request = nil;
	//MVR - we need to dismiss the action sheet here for some reason
	if (self.cancelRequestActionSheet.visible)
		[self.cancelRequestActionSheet dismissWithClickedButtonIndex:0 animated:YES];
	//MVR - hide the progress HUD
	[self.progressHud hide:YES];
	statusCode = [theRequest responseStatusCode];
	if (statusCode != 200) {
		NSLog(@"Error new text post received status code %i", statusCode);
		//MVR - enable post button
		self.navigationItem.rightBarButtonItem.enabled = YES;
		[self errorAlertWithTitle:@"Post Failed" message:@"Oops! We couldn't make the text post."];
		return;
	}
	[self dismissModalViewControllerAnimated:YES];
}

- (void)newTextPostFailed:(ASIHTTPRequest *)theRequest {
	NSError *error;

	self.request = nil;
	//MVR - we need to dismiss the action sheet here for some reason
	if (self.cancelRequestActionSheet.visible)
		[self.cancelRequestActionSheet dismissWithClickedButtonIndex:0 animated:YES];
	//MVR - hide the progress HUD
	[self.progressHud hide:YES];
	//MVR - enable post button
	self.navigationItem.rightBarButtonItem.enabled = YES;
	error = [theRequest error];
	switch ([error code]) {
		case ASIConnectionFailureErrorType:
			NSLog(@"Error posting text: connection failed %@", [[error userInfo] objectForKey:NSUnderlyingErrorKey]);
			[self errorAlertWithTitle:@"Connection Failure" message:@"Oops! We couldn't make the text post."];
			break;
		case ASIRequestTimedOutErrorType:
			NSLog(@"Error posting text: request timed out");
			[self errorAlertWithTitle:@"Request Timed Out" message:@"Oops! We couldn't make the text post."];
			break;
		case ASIRequestCancelledErrorType:
			NSLog(@"Text post request cancelled");
			break;
		default:
			NSLog(@"Error posting text");
			break;
	}	
}

#pragma mark -
#pragma mark MBProgressHUDDelegate delegate

- (void)hudWasHidden:(MBProgressHUD *)theProgressHUD {
	//MVR - remove HUD from screen when the HUD was hidden
	[theProgressHUD removeFromSuperview];
}

#pragma mark -
#pragma mark Action sheet delegate

- (void)actionSheet:(UIActionSheet *)theActionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (theActionSheet == _cancelRequestActionSheet) {
		if (buttonIndex == 0) {
			[request cancel];
			[self dismissModalViewControllerAnimated:YES];
		} else if (buttonIndex == 1) {
			[request cancel];
		}
	} else if (theActionSheet == _cancelActionSheet) {
		if (buttonIndex == 0)
			[self dismissModalViewControllerAnimated:YES];
	}
}

/*
 - (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
 if (actionSheet == self.avatarActionSheet && buttonIndex == 2)
 [self.tableView deselectRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0] animated:YES];
 }
 */

#pragma mark -
#pragma mark UITextView delegate

- (void)textViewDidChange:(UITextView *)theTextView {
	if (!textView.text || [textView.text isEqualToString:@""])
		self.navigationItem.rightBarButtonItem.enabled = NO;
	else
		self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark -
#pragma mark FacebookConnectDelegate methods

- (void)facebookIsConnecting {
    //MVR - display HUD
	[self showProgressHudWithLabelText:@"Connecting Facebook..." animated:NO animationType:MBProgressHUDAnimationFade];
}

- (void)facebookDidConnect {
    //MVR - hide the progress HUD
	[self.progressHud hide:YES];
}

- (void)facebookDidNotConnect:(BOOL)cancelled {
    [facebookSwitch setOn:NO animated:NO];
}

- (void)facebookConnectFailed:(NSError *)error {
    NSLog(@"Facebook connect failed");
    //MVR - hide the progress HUD
	[self.progressHud hide:YES];
    [self errorAlertWithTitle:@"Connect Failed" message:@"Oops! We couldn't connect your Facebook account."];
    [facebookSwitch setOn:NO animated:NO];
}

#pragma mark -
#pragma mark Actions

- (void)post {
	ASIFormDataRequest *theRequest;
	
	//MVR - dismiss keyboard
	[textView resignFirstResponder];
	//MVR - disable post button
	self.navigationItem.rightBarButtonItem.enabled = NO;
	[self showProgressHudWithLabelText:@"Posting text..." animated:YES animationType:MBProgressHUDAnimationZoom];
	theRequest = [ASIFormDataRequest requestWithURL:[self newTextPostUrl]];
	//MVR - post request should never timeout
	theRequest.timeOutSeconds = 0;
	[theRequest setDelegate:self];
	[theRequest setDidFinishSelector:@selector(newTextPostFinished:)];
	[theRequest setDidFailSelector:@selector(newTextPostFailed:)];
	[theRequest addPostValue:session.user.authenticationToken forKey:@"authentication_token"];
	[theRequest addPostValue:textView.text forKey:@"text_post[text]"];
    if (facebookSwitch.on)
        [theRequest addPostValue:@"1" forKey:@"facebook_share"];
    if (twitterSwitch.on)
        [theRequest addPostValue:@"1" forKey:@"tweet"];
	[theRequest addPostValue:@"iPhone" forKey:@"text_post[from]"];
	[theRequest startAsynchronous];
	self.request = theRequest;
}

- (void)twitterSwitchChanged {
    //MVR - connect to Twitter if not connected
    if (!session.user.twitterAccessToken || !session.user.twitterTokenSecret) {
        UINavigationController *theNavigationController;
        TwitterConnectController *twitterConnectController;
        
        twitterConnectController = [[TwitterConnectController alloc] initWithStyle:UITableViewStyleGrouped];
        twitterConnectController.managedObjectContext = managedObjectContext;
        twitterConnectController.session = session;
        twitterConnectController.navigationItem.leftBarButtonItem = twitterConnectController.cancelButton;
        theNavigationController = [[UINavigationController alloc] initWithRootViewController:twitterConnectController];
        [twitterConnectController release];
        theNavigationController.navigationBar.tintColor = TTSTYLEVAR(navigationBarTintColor);
        [self presentModalViewController:theNavigationController animated:YES];
        [theNavigationController release];
    }
}

- (void)cancel {
	//MVR - if empty just dismiss the controller
	if (!textView.text || [textView.text isEqualToString:@""]) {
		[self dismissModalViewControllerAnimated:YES];
		return;
	}
	if (request)
		[self.cancelRequestActionSheet showInView:self.navigationController.view];
	else
		[self.cancelActionSheet showInView:self.navigationController.view];
}

#pragma mark -
#pragma mark Helpers

- (NSURL *)newTextPostUrl {
	NSString *string;
	NSURL *url;
	
#ifdef DEVEL
	string = [NSString stringWithFormat:@"http://sandbox.blogcastr.com/blogcasts/%d/text_posts.xml", [blogcast.id intValue]];
#else //DEVEL
	string = [NSString stringWithFormat:@"http://blogcastr.com/blogcasts/%d/text_posts.xml", [blogcast.id intValue]];
#endif //DEVEL
	url = [NSURL URLWithString:string];
	
	return url;
}

- (void)showProgressHudWithLabelText:(NSString *)labelText animated:(BOOL)animated animationType:(MBProgressHUDAnimation)animationType {
	self.progressHud.labelText = labelText;
	if (animated)
		self.progressHud.animationType = animationType;
	//MVR - use superview to handle a display bug
	[self.view.superview addSubview:self.progressHud];
	[self.progressHud show:animated];
}

- (void)errorAlertWithTitle:(NSString *)title message:(NSString *)message {
	//MVR - update and display the alert view
	self.alertView.title = title;
	self.alertView.message = message;
	[self.alertView show];
}

@end

