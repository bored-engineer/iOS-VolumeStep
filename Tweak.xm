#include <SpringBoard/VolumeControl.h>

%hook VolumeControl
//0.06 is default
-(void)_changeVolumeBy:(float)by {
	//Get settings dictionary
	NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:@"/private/var/mobile/Library/Preferences/com.innoying.volumestep.plist"];
	//Get enabled status
	BOOL Enabled = [settingsDict objectForKey:@"enabled"] ? [[settingsDict objectForKey:@"enabled"] boolValue] : YES;
	//If enabled
	if(Enabled){
		//Extract the split value
		float Split = [settingsDict objectForKey:@"Step"] ? [[settingsDict objectForKey:@"Step"] floatValue] : .5;
		NSLog(@"VolumeControl step reduced to: %.2f", (Split));
		//Convert from percentage than multiple
		by = by*Split;
	}
	//Run original
	%orig(by);
}
%end