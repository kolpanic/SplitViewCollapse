SplitViewCollapse
=================

A collapsible NSSplitView that works with auto-layout for OS X Mavericks. Suggestions for improvement are welcome.

Note the comments in KMCollapsibleSplitView.m. In a nutshell, you need a fixed-width constraint on the right pane. You also have to remove the right pane's layout constraints when collapsing, otherwise the pane won't fully collapse. (Of course, you have to restore them before uncollapsing, so they're cached in awakeFromNib.)

With springs & struts, NSSplitView's -setPosition:ofDividerAtIndex: just works. With autolayout, you have to do the constraint removal and addition. (There's also NSSplitView's method -_setSubview:isCollapsed:, which works in both springs & struts and autolayout, but, since it's private, it's not Mac App Store-appropriate.)

Released to the public domain without warranty of any kind. Feel free to use it with or without credit.
