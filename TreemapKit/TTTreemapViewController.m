//
//  TTTreemapViewController.m
//  PhotoStream
//
//  Created by Christopher White on 11/28/11.
//  Copyright (c) 2011 Mad Races, Inc. All rights reserved.
//

#import "TTTreemapViewController.h"
#import "TreemapView.h"
#import "TTTreemapViewDataSource.h"
#import "TTTreemapViewDelegate.h"

@implementation TTTreemapViewController {
    id<TreemapViewDelegate>   _treemapDelegate;
    UIView *_tableOverlayView;
    UIView* _loadingView;
    UIView* _errorView;
    UIView* _emptyView;
}

@synthesize treemapView = _treemapView;
@synthesize dataSource = _dataSource;
@synthesize tableOverlayView = _tableOverlayView;
@synthesize loadingView = _loadingView;
@synthesize errorView = _errorView;
@synthesize emptyView = _emptyView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    [super loadView];
    
    [self treemapView];
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    /*
    if (_lastInterfaceOrientation != self.interfaceOrientation) {
        _lastInterfaceOrientation = self.interfaceOrientation;
        [_tableView reloadData];
        
    } else if ([_tableView isKindOfClass:[TTTableView class]]) {
        TTTableView* tableView = (TTTableView*)_tableView;
        tableView.highlightedLabel = nil;
        tableView.showShadows = _showTableShadows;
    }
    
    if (_clearsSelectionOnViewWillAppear) {
        [_tableView deselectRowAtIndexPath:[_tableView indexPathForSelectedRow] animated:animated];
    }
    */
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TTModelViewController


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)beginUpdates 
{
    [super beginUpdates];
    //[_tableView beginUpdates];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)endUpdates 
{
    [super endUpdates];
    //[_tableView endUpdates];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)canShowModel 
{    
    NSArray *values = [_dataSource valuesForTreemapView:_treemapView];
    return [values count] > 0;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didLoadModel:(BOOL)firstTime {
    [super didLoadModel:firstTime];
    [_dataSource treemapViewDidLoadModel:_treemapView];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)didShowModel:(BOOL)firstTime {
    [super didShowModel:firstTime];
    if (![self isViewAppearing] && firstTime) {
        //[_tableView flashScrollIndicators];
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)updateTreemapDelegate 
{
    if (!_treemapView.delegate) {
        _treemapDelegate = [self createDelegate];
        
        // You need to set it to nil before changing it or it won't have any effect
        _treemapView.delegate = nil;
        _treemapView.delegate = _treemapDelegate;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showModel:(BOOL)show {
    //[self hideMenu:YES];
    if (show) {
        [self updateTreemapDelegate];
        _treemapView.dataSource = _dataSource;
        
    } else {
        _treemapView.dataSource = nil;
    }
    [_treemapView reloadData];
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString*)defaultTitleForLoading 
{
    return TTLocalizedString(@"Loading...", @"");
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showLoading:(BOOL)show {
    if (show) {
        if (!self.model.isLoaded || ![self canShowModel]) {
            NSString* title = _dataSource
            ? [_dataSource titleForLoading:NO]
            : [self defaultTitleForLoading];
            if (title.length) {
                TTActivityLabel* label =
                [[TTActivityLabel alloc] initWithStyle:TTActivityLabelStyleWhiteBox];
                label.text = title;
                label.backgroundColor = _treemapView.backgroundColor;
                self.loadingView = label;
            }
        }
        
    } else {
        self.loadingView = nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showError:(BOOL)show {
    if (show) {
        if (!self.model.isLoaded || ![self canShowModel]) {
            NSString* title = [_dataSource titleForError:_modelError];
            NSString* subtitle = [_dataSource subtitleForError:_modelError];
            UIImage* image = [_dataSource imageForError:_modelError];
            if (title.length || subtitle.length || image) {
                TTErrorView* errorView = [[TTErrorView alloc] initWithTitle:title
                                                                    subtitle:subtitle
                                                                       image:image];
                errorView.backgroundColor = _treemapView.backgroundColor;
                self.errorView = errorView;
                
            } else {
                self.errorView = nil;
            }
            _treemapView.dataSource = nil;
            [_treemapView reloadData];
        }
        
    } else {
        self.errorView = nil;
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)showEmpty:(BOOL)show {
    if (show) {
        NSString* title = [_dataSource titleForEmpty];
        NSString* subtitle = [_dataSource subtitleForEmpty];
        UIImage* image = [_dataSource imageForEmpty];
        if (title.length || subtitle.length || image) {
            TTErrorView* errorView = [[TTErrorView alloc] initWithTitle:title
                                                                subtitle:subtitle
                                                                   image:image];
            errorView.backgroundColor = _treemapView.backgroundColor;
            self.emptyView = errorView;
            
        } else {
            self.emptyView = nil;
        }
        _treemapView.dataSource = nil;
        [_treemapView reloadData];
        
    } else {
        self.emptyView = nil;
    }
}

- (TreemapView*)treemapView {
    if (nil == _treemapView) {
        _treemapView = [[TreemapView alloc] initWithFrame:self.view.bounds];
        _treemapView.autoresizingMask = UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        //_treemapView.dataSource = [[PSStreamTreeMapDataSource alloc] init];
        _treemapView.delegate = self;
        _treemapView.backgroundColor = [UIColor blackColor];
        self.view.backgroundColor = [UIColor blackColor];
        
        /*
         _tableView = [[TTTableView alloc] initWithFrame:self.view.bounds style:_tableViewStyle];
         _tableView.autoresizingMask =  UIViewAutoresizingFlexibleWidth
         | UIViewAutoresizingFlexibleHeight;
         
         UIColor* separatorColor = _tableViewStyle == UITableViewStyleGrouped
         ? TTSTYLEVAR(tableGroupedCellSeparatorColor)
         : TTSTYLEVAR(tablePlainCellSeparatorColor);
         if (separatorColor) {
         _tableView.separatorColor = separatorColor;
         }
         
         _tableView.separatorStyle = _tableViewStyle == UITableViewStyleGrouped
         ? TTSTYLEVAR(tableGroupedCellSeparatorStyle)
         : TTSTYLEVAR(tablePlainCellSeparatorStyle);
         
         UIColor* backgroundColor = _tableViewStyle == UITableViewStyleGrouped
         ? TTSTYLEVAR(tableGroupedBackgroundColor)
         : TTSTYLEVAR(tablePlainBackgroundColor);
         if (backgroundColor) {
         _tableView.backgroundColor = backgroundColor;
         self.view.backgroundColor = backgroundColor;
         }
         */
        [self.view addSubview:_treemapView];
    }
    return _treemapView;
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setTreemapView:(TreemapView*)treemapView {
    if (treemapView != _treemapView) {
        _treemapView = treemapView;
        if (!_treemapView) {
            //self.tableBannerView = nil;
            //self.tableOverlayView = nil;
        }
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setDataSource:(id<TTTreemapViewDataSource>)dataSource {
    if (dataSource != _dataSource) {
        _dataSource = dataSource;
        _treemapView.dataSource = nil;
        
        self.model = dataSource.model;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (id<TreemapViewDelegate>)createDelegate {
    return [[TTTreemapViewDelegate alloc] initWithController:self];
}

- (CGRect)rectForOverlayView {
    return _treemapView.frame;
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)addToOverlayView:(UIView*)view 
{
    if (!_tableOverlayView) {
        CGRect frame = [self rectForOverlayView];
        _tableOverlayView = [[UIView alloc] initWithFrame:frame];
        _tableOverlayView.autoresizesSubviews = YES;
        _tableOverlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth
        | UIViewAutoresizingFlexibleHeight;
        NSInteger treemapIndex = [_treemapView.superview.subviews indexOfObject:_treemapView];
        if (treemapIndex != NSNotFound) {
            [_treemapView.superview addSubview:_tableOverlayView];
        }
    }
    
    view.frame = _tableOverlayView.bounds;
    view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_tableOverlayView addSubview:view];
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)resetOverlayView 
{
    if (_tableOverlayView && !_tableOverlayView.subviews.count) {
        [_tableOverlayView removeFromSuperview];
        _tableOverlayView = nil;
    }
}

///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setLoadingView:(UIView*)view 
{
    if (view != _loadingView) {
        if (_loadingView) {
            [_loadingView removeFromSuperview];
            _loadingView = nil;
        }
        _loadingView = view;
        if (_loadingView) {
            [self addToOverlayView:_loadingView];
            
        } else {
            [self resetOverlayView];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setErrorView:(UIView*)view 
{
    if (view != _errorView) {
        if (_errorView) {
            [_errorView removeFromSuperview];
            _errorView = nil;
        }
        _errorView = view;
        
        if (_errorView) {
            [self addToOverlayView:_errorView];
            
        } else {
            [self resetOverlayView];
        }
    }
}


///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setEmptyView:(UIView*)view 
{
    if (view != _emptyView) {
        if (_emptyView) {
            [_emptyView removeFromSuperview];
            _emptyView = nil;
        }
        _emptyView = view;
        if (_emptyView) {
            [self addToOverlayView:_emptyView];
            
        } else {
            [self resetOverlayView];
        }
    }
}

- (void)treemapView:(TreemapView *)treemapView tapped:(NSInteger)index
{
    NSLog(@"meh");
}

@end
