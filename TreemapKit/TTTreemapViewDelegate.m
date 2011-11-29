//
//  TTTreemapViewDelegate.m
//  PhotoStream
//
//  Created by Christopher White on 11/28/11.
//  Copyright (c) 2011 Mad Races, Inc. All rights reserved.
//

#import "TTTreemapViewDelegate.h"

@implementation TTTreemapViewDelegate {
    TTTreemapViewController*  _controller;
}

@synthesize controller = _controller;

- (id)initWithController:(TTTreemapViewController*)controller
{
    self = [super init];
    if (self) {
        _controller = controller;
    }
    return self;
}


@end
