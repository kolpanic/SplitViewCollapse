//
//  KMCollapsibleSplitView.m
//  Cinemagraph Pro
//
//  Created by Karl Moskowski on 12/18/2013.
//  Copyright (c) 2013 Karl Moskowski. All rights reserved.
//

// Collapses the right pane with animation, preserving its fixed-width (if set)

#import "KMCollapsibleSplitView.h"
@import QuartzCore;

@interface KMCollapsibleSplitView () <NSSplitViewDelegate>

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *rightPaneWidthConstraint;
@property (weak, nonatomic) IBOutlet NSView *rightPane;

@property (assign, nonatomic) CGFloat originalRightPaneWidth;
@property (assign, nonatomic) CGFloat dividerPosition;

@end

@implementation KMCollapsibleSplitView

#pragma mark - Set Up

+ (id) defaultAnimationForKey:(NSString *)key {
	if ([key isEqualToString:@"dividerPosition"]) {
		CAAnimation *animation = [CABasicAnimation animation];
		animation.duration = 0.1;
		return animation;
	}
	return [super defaultAnimationForKey:key];
}

- (void) awakeFromNib {
	[self setDelegate:self];
    self.animateCollapse = YES;
}

#pragma mark - Actions

- (IBAction) toggleRightPane:(id)sender {
	if (self.originalRightPaneWidth <= 0.0) {
		self.originalRightPaneWidth = self.rightPane.frame.size.width;
	}
	_dividerPosition = (self.frame.size.width - self.rightPane.frame.size.width);

	BOOL isCollapsed = [self isSubviewCollapsed:self.rightPane];

	if (!isCollapsed && self.rightPaneWidthConstraint) {
		[self.rightPane removeConstraint:self.rightPaneWidthConstraint];
	}
	if (self.animateCollapse) {
		[NSAnimationContext runAnimationGroup:^(NSAnimationContext *context) {
			self.animator.dividerPosition = self.frame.size.width - (isCollapsed ? self.originalRightPaneWidth : 0.0);
		} completionHandler:^{
			if (isCollapsed && self.rightPaneWidthConstraint) {
				[self.rightPane addConstraint:self.rightPaneWidthConstraint];
			}
		}];
	} else {
		self.dividerPosition = self.frame.size.width - (isCollapsed ? self.originalRightPaneWidth : 0.0);
        if (isCollapsed && self.rightPaneWidthConstraint) {
            [self.rightPane addConstraint:self.rightPaneWidthConstraint];
        }
	}
}

#pragma mark - Accessors

- (void) setDividerPosition:(CGFloat)value {
	_dividerPosition = value;
	[self setPosition:value ofDividerAtIndex:0];
}

- (NSView *) rightPane {
	return _rightPane ? : (_rightPane = [[self subviews] objectAtIndex:1]);
}

#pragma mark - NSSplitViewDelegate

- (BOOL) splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex {
	return YES;
}

- (NSRect) splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex {
	return NSZeroRect;
}

- (BOOL) splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
	return [subview isEqual:self.rightPane];
}

@end
