include theos/makefiles/common.mk

TWEAK_NAME = VolumeStep
VolumeStep_FILES = Tweak.xm
VolumeStep_FRAMEWORKS = UIKit

include $(THEOS_MAKE_PATH)/tweak.mk
