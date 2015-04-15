#import <UIKit/UIKit.h>
#import <objc/runtime.h>

static BOOL GetBooleanSetting(NSString *key, BOOL defaultValue)
{
    Boolean exists;
    Boolean result = CFPreferencesGetAppBooleanValue((CFStringRef)key, CFSTR("com.innoying.volumestep"), &exists);
    return exists ? result : defaultValue;
}


static double GetDoubleSetting(NSString *key, double defaultValue)
{
    id value = (id)CFPreferencesCopyAppValue((CFStringRef)key, CFSTR("com.innoying.volumestep"));
    double result = [value respondsToSelector:@selector(doubleValue)] ? [value doubleValue] : defaultValue;
    [value release];
    return result;
}

%hook VolumeControl
-(void)_changeVolumeBy:(float)by {

    bool enabled = GetBooleanSetting(@"enabled", YES);
    float multiplier = GetDoubleSetting(@"multiplier", 0.5f);
    if (enabled) {
        by = by * multiplier;
        %log(@"Volume-Step VolumeControl enabled, changing step");
    }
    %orig(by);
}
%end

static void PreferencesCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo)
{
    CFPreferencesAppSynchronize(CFSTR("com.innoying.volumestep"));
}

%ctor
{
    %init();
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, PreferencesCallback, CFSTR("com.innoying.volumestep.config-changed"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
