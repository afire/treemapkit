//
//  TTTreemapViewDelegate.h
//  PhotoStream
//
//  Created by Christopher White on 11/28/11.
//  Copyright (c) 2011 Mad Races, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TreemapView.h"


@class TTTreemapViewController;

/**
 * A default table view delegate implementation.
 *
 * This implementation takes care of measuring rows for you, opening URLs when the user
 * selects a cell, and suspending image loading to increase performance while the user is
 * scrolling the table.  TTTableViewController automatically assigns an instance of this
 * delegate class to your table, but you can override the createDelegate method there to provide
 * a delegate implementation of your own.
 *
 * If you would like to change the background color of the section headers, specify the
 * tableHeaderTintColor property in your global style sheet.
 *
 * This is also where the table view menu is hidden if the user starts scrolling.
 *
 * TODO(jverkoey 04/13/2010): Rename this object because it's not a protocol, and therefor
 * shouldn't be affixed the "Delegate" title.
 */
@interface TTTreemapViewDelegate : NSObject <TreemapViewDelegate>

- (id)initWithController:(TTTreemapViewController*)controller;

@property (nonatomic, readonly) TTTreemapViewController* controller;

@end
