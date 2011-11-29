//
//  TTTreemapViewController.h
//  PhotoStream
//
//  Created by Christopher White on 11/28/11.
//  Copyright (c) 2011 Mad Races, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TreemapView.h"


@protocol TTTreemapViewDataSource;


@interface TTTreemapViewController : TTModelViewController <TreemapViewDelegate> {
    TreemapView *_treemapView;
    id<TTTreemapViewDataSource> _dataSource;
}

@property (nonatomic, strong) TreemapView* treemapView;

/**
 * The data source used to populate the table view.
 *
 * Setting dataSource has the side effect of also setting model to the value of the
 * dataSource's model property.
 */
@property (nonatomic, strong) id<TTTreemapViewDataSource> dataSource;

/**
 * Creates an delegate for the table view.
 *
 * Subclasses can override this to provide their own table delegate implementation.
 */
- (id<TreemapViewDelegate>)createDelegate;

/**
 * A view that is displayed over the table view.
 */
@property (nonatomic, retain) UIView* tableOverlayView;

@property (nonatomic, strong) UIView* loadingView;
@property (nonatomic, strong) UIView* errorView;
@property (nonatomic, strong) UIView* emptyView;

@end
