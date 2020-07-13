static UIDevice *currentDevice;
static UIDeviceOrientation deviceOrientation;
static id manager;
static UISwipeGestureRecognizer *swipeRecog1;
static UISwipeGestureRecognizer *swipeRecog2;
static UISwipeGestureRecognizer *swipeRecog3;
static UISwipeGestureRecognizer *swipeRecog4;

@interface UISwipeGestureRecognizer()
-(void)setMinimumPrimaryMovement:(double)arg1;
-(void)setMaximumPrimaryMovement:(double)arg1;
-(void)setMinimumSecondaryMovement:(double)arg1;
-(void)setMaximumSecondaryMovement:(double)arg1;
-(void)setMaximumDuration:(double)arg1;
@end
@interface UIDevice()
-(void)setOrientation:(long long)arg1 animated:(BOOL)arg2;
-(void)_enableDeviceOrientationEvents:(BOOL)arg1;
-(BOOL)deviceIsIpad;
@end
@interface UIWindow()
-(void)landscape;
-(void)landscapeLeft;
-(void)portrait;
-(void)portraitUpsideDown;
@end

%hook UIDevice
%new
-(BOOL)deviceIsIpad {
	if([(NSString *)[currentDevice model] hasPrefix:@"iPad"]) {
		return YES;
	} else {
		return NO;
	}
}
-(NSString *)name {
	currentDevice = [UIDevice currentDevice];
	[currentDevice _enableDeviceOrientationEvents:YES];
	deviceOrientation = [[UIDevice currentDevice] orientation];
	return %orig;
}
%end
%hook UIWindow
%new
-(void)landscape {
	[currentDevice setOrientation:UIDeviceOrientationLandscapeRight animated:YES];
}
%new
-(void)landscapeLeft {
	[currentDevice setOrientation:UIDeviceOrientationLandscapeLeft animated:YES];
}
%new
-(void)portrait {
	[currentDevice setOrientation:UIDeviceOrientationPortrait animated:YES];
}
%new
-(void)portraitUpsideDown {
	[currentDevice setOrientation:UIDeviceOrientationPortraitUpsideDown animated:YES];
}
-(void)becomeKeyWindow {
	%orig;
	swipeRecog1 = [[UISwipeGestureRecognizer alloc] initWithTarget:manager action:@selector(landscape)]; //landscape
	swipeRecog2 = [[UISwipeGestureRecognizer alloc] initWithTarget:manager action:@selector(landscapeLeft)]; //landscapeLeft
	swipeRecog3 = [[UISwipeGestureRecognizer alloc] initWithTarget:manager action:@selector(portrait)]; //portrait
	swipeRecog4 = [[UISwipeGestureRecognizer alloc] initWithTarget:manager action:@selector(portraitUpsideDown)]; //portraitUpsideDown (ipad only)
	[swipeRecog1 setNumberOfTouchesRequired:3];
	[swipeRecog2 setNumberOfTouchesRequired:3];
	[swipeRecog3 setNumberOfTouchesRequired:3];
	[swipeRecog4 setNumberOfTouchesRequired:3];
	if(deviceOrientation == UIDeviceOrientationPortrait) {
		[swipeRecog1 setDirection: UISwipeGestureRecognizerDirectionRight];
		[swipeRecog2 setDirection: UISwipeGestureRecognizerDirectionLeft];
		[swipeRecog3 setDirection: UISwipeGestureRecognizerDirectionUp];
	} else if (deviceOrientation == UIDeviceOrientationLandscapeRight) {
		[swipeRecog1 setDirection: UISwipeGestureRecognizerDirectionUp];
		[swipeRecog2 setDirection: UISwipeGestureRecognizerDirectionRight];
		[swipeRecog3 setDirection: UISwipeGestureRecognizerDirectionLeft];
	} else if (deviceOrientation == UIDeviceOrientationLandscapeLeft) {
		[swipeRecog1 setDirection: UISwipeGestureRecognizerDirectionLeft];
		[swipeRecog2 setDirection: UISwipeGestureRecognizerDirectionUp];
		[swipeRecog3 setDirection: UISwipeGestureRecognizerDirectionRight];
	} else if ([currentDevice deviceIsIpad] == YES && deviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
		[swipeRecog1 setDirection: UISwipeGestureRecognizerDirectionLeft];
		[swipeRecog2 setDirection: UISwipeGestureRecognizerDirectionRight];
		[swipeRecog3 setDirection: UISwipeGestureRecognizerDirectionUp];
		[swipeRecog4 setDirection: UISwipeGestureRecognizerDirectionDown];
	}
	[swipeRecog1 setMinimumPrimaryMovement:4];
	[swipeRecog1 setMaximumPrimaryMovement:200];
	[swipeRecog1 setMinimumSecondaryMovement:4];
	[swipeRecog1 setMaximumSecondaryMovement:200];
	[swipeRecog1 setMaximumDuration:5];
	[swipeRecog2 setMinimumPrimaryMovement:4];
	[swipeRecog2 setMaximumPrimaryMovement:200];
	[swipeRecog2 setMinimumSecondaryMovement:4];
	[swipeRecog2 setMaximumSecondaryMovement:200];
	[swipeRecog2 setMaximumDuration:5];
	[swipeRecog3 setMinimumPrimaryMovement:4];
	[swipeRecog3 setMaximumPrimaryMovement:200];
	[swipeRecog3 setMinimumSecondaryMovement:4];
	[swipeRecog3 setMaximumSecondaryMovement:200];
	[swipeRecog3 setMaximumDuration:5];
	[swipeRecog4 setMinimumPrimaryMovement:4];
	[swipeRecog4 setMaximumPrimaryMovement:200];
	[swipeRecog4 setMinimumSecondaryMovement:4];
	[swipeRecog4 setMaximumSecondaryMovement:200];
	[swipeRecog4 setMaximumDuration:5];
	[self addGestureRecognizer:swipeRecog1];
	[self addGestureRecognizer:swipeRecog2];
	[self addGestureRecognizer:swipeRecog3];
	[self addGestureRecognizer:swipeRecog4];
}
%end