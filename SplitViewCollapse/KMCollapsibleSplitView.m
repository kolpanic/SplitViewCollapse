//
//  KMCollapsibleSplitView.m
//  Cinemagraph Pro
//
//  Created by Karl Moskowski on 12/18/2013.
//  Copyright (c) 2013 Karl Moskowski. All rights reserved.
//

// NOTES:
// Ensure there's a FIXED RIGHT PANE WIDTH, otherwise the right pane will resize with the window.

#import "KMCollapsibleSplitView.h"

@interface KMCollapsibleSplitView () <NSSplitViewDelegate>

@property (weak, nonatomic) NSView *leftPane;
@property (weak, nonatomic)  NSView *rightPane;
@property (strong, nonatomic) NSArray *rightPaneConstraints;
@property (assign, nonatomic) CGFloat originalSplitterPosition;

@end

@implementation KMCollapsibleSplitView

- (void) awakeFromNib {
	[self setDelegate:self];
	self.leftPane = [[self subviews] objectAtIndex:0];
	self.rightPane = [[self subviews] objectAtIndex:1];
	self.originalSplitterPosition = (self.frame.size.width - self.rightPane.frame.size.width);
    
	// save the right pane's constraints so they can be restored after removal
	self.rightPaneConstraints = [self.rightPane constraints];
}

- (IBAction) toggleRightPane:(id)sender {
	BOOL shouldCollapse = (self.rightPane.frame.size.width > 0.0);
    
	// remove the right pane's constraints when collapsing, and restore them when uncollapsing
	for (NSLayoutConstraint *constraint in self.rightPaneConstraints) {
		if (shouldCollapse) {
			[self.rightPane removeConstraint:constraint];
		} else {
			[self.rightPane addConstraint:constraint];
		}
	}
    
	[self.animator setPosition:(shouldCollapse ? self.frame.size.width : self.originalSplitterPosition) ofDividerAtIndex:0];
}

#pragma mark - NSSplitViewDelegate

// Ensure the split view can't be resized manually
- (NSRect) splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex {
	return NSZeroRect;
}

@end
