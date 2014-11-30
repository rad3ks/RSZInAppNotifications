InAppNotifications
==================

InAppNotifications module is a simple mechanism to present notifications when application is active. You can read more about this project on my [blog](http://rszeja.me).

![Example](http://cl.ly/image/0N0m3u1p2H09/in_app_notifications_recording_min.gif)

# Installation

Use CocoaPods:

	pod 'RSZInAppNotifications'

or add *RSZInAppNotifications* folder to your project.

# Usage 

`RSZPresenter` requires `UIWindow` instance to work. Add the following code to `-application:didFinishLaunchingWithOptions:`

	[RSZPresenter setPresentingWindow:self.window];

Now you can create notification (assuming you have it's view):

	RSZNotification *notification = [RSZNotification notificationWithAssociatedView:view onTapBlock:block];

and then present it:

	[RSZPresenter presentNotification:notification];

That's it! 
