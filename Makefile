TARGET_CODESIGN = $(shell which ldid)

PLATFORM = iphoneos
NAME = wallpaperBG
VOLNAME = loader
RELEASE = Release-iphoneos
ARG = ios=1


P1_TMP         = $(TMPDIR)/$(NAME)
P1_STAGE_DIR   = $(P1_TMP)/stage
P1_APP_DIR 	   = $(P1_TMP)/Build/Products/$(RELEASE)/$(NAME).app

package:
	@set -o pipefail; \
		xcodebuild -jobs $(shell sysctl -n hw.ncpu) -project 'wallpaperBG.xcodeproj' -scheme wallpaperBG -configuration Release -arch arm64 -sdk $(PLATFORM) -derivedDataPath $(P1_TMP) \
		CODE_SIGNING_ALLOWED=NO DSTROOT=$(P1_TMP)/install ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO
		
	@rm -rf Payload
	@rm -rf $(P1_STAGE_DIR)/
	@mkdir -p $(P1_STAGE_DIR)/Payload
	@mv $(P1_APP_DIR) $(P1_STAGE_DIR)/Payload/$(NAME).app
	@echo $(P1_TMP)
	@echo $(P1_STAGE_DIR)

	@$(TARGET_CODESIGN) -Sentitlements.xml $(P1_STAGE_DIR)/Payload/$(NAME).app/
	
	@rm -rf $(P1_STAGE_DIR)/Payload/$(NAME).app/_CodeSignature
	@ln -sf $(P1_STAGE_DIR)/Payload Payload
	@rm -rf packages
	@mkdir -p packages

	@zip -r9 packages/$(NAME).tipa Payload

	@rm -rf Payload
	@rm -rf $(P1_TMP)

clean:
	@rm -rf $(P1_STAGE_DIR)
	@rm -rf packages
	@rm -rf out.dmg
	@rm -rf Payload
	@rm -rf $(P1_TMP)

