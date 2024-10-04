#!/bin/bash
brew install --cask 1password
brew install --cask alacritty	
brew install --cask git-credential-manager
brew install --cask google-cloud-sdk
brew install --cask microsoft-teams	
brew install --cask visual-studio-code
brew install --cask font-monaspace
brew install --cask google-chrome
brew install --cask slack
brew install --cask nikitabobko/tap/aerospace
brew install Azure/kubelogin/kubelogin
brew install golang
brew install starship
brew install hashicorp/tap/terraform
brew install kubernetes-cli
brew install helm			
brew install azure-cli
brew install imagemagick
brew install tree
brew install istioctl
brew install colima
brew install docker
brew install siege
brew install kind
brew install koekeishiya/formulae/skhd
brew services start skhd

# disable window opening animations
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false

# ctrl+cmd to drag windows
defaults write -g NSWindowShouldDragOnGesture -bool true

# switch tilde and +/-
cat << 'EOF' > ~/.tilde-switch && chmod +x ~/.tilde-switch
hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000035,"HIDKeyboardModifierMappingDst":0x700000064},{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}'
EOF
sudo /usr/bin/env bash -c "cat > /Library/LaunchDaemons/org.custom.tilde-switch.plist" << EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>org.custom.tilde-switch</string>
    <key>Program</key>
    <string>${HOME}/.tilde-switch</string>
    <key>RunAtLoad</key>
    <true/>
    <key>KeepAlive</key>
    <false/>
  </dict>
</plist>
EOF
sudo launchctl load -w -- /Library/LaunchDaemons/org.custom.tilde-switch.plist