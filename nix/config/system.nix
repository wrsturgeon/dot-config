ctx: {
  configurationRevision = ctx.self.rev or ctx.self.dirtyRev or null;
  defaults = {
    ".GlobalPreferences" = {
      "com.apple.mouse.scaling" = 0.5;
      "com.apple.sound.beep.sound" = null;
    };
    CustomSystemPreferences = { };
    CustomUserPreferences = { };
    LaunchServices.LSQuarantine = true;
    NSGlobalDomain = {
      AppleICUForce24HourTime = true;
      AppleInterfaceStyleSwitchesAutomatically = true;
      AppleMeasurementUnits = "Inches";
      AppleMetricUnits = 0;
      AppleScrollerPagingBehavior = true;
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      AppleShowScrollBars = "Always";
      AppleTemperatureUnit = "Fahrenheit";
      AppleWindowTabbingMode = "fullscreen";
      InitialKeyRepeat = 1;
      KeyRepeat = 1;
      NSAutomaticCapitalizationEnabled = false;
      NSAutomaticDashSubstitutionEnabled = true;
      NSAutomaticInlinePredictionEnabled = false;
      NSAutomaticPeriodSubstitution = false;
      NSAutomaticQuoteSubstitution = true;
      NSAutomaticSpellingCorrectionEnabled = false;
      NSAutomaticWindowAnimationEnabled = true;
      NSDisableAutomaticTermination = null;
      NSDocumentSaveNewDocumentsToCloud = false;
      NSNavPanelExpandedStateForSaveMode = true;
      NSNavPanelExpandedStateForSaveMode2 = true;
      NSScrollAnimationEnabled = false;
      NSTableViewDefaultSizeMode = 1;
      NSTextShowsControlCharacters = true;
      NSUseAnimatedFocusRing = true;
      NSWindowResizeTime = 0.1;
      NSWindowShouldDragOnGesture = true;
      PMPrintingExpandedStateForPrint = true;
      PMPrintingExpandedStateForPrint2 = true;
      _HIHideMenuBar = false;
      "com.apple.keyboard.fnState" = true;
      "com.apple.mouse.tapBehavior" = null;
      "com.apple.sound.beep.feedback" = 0;
      "com.apple.sound.beep.volume" = 1.0;
      "com.apple.springing.delay" = 0.1;
      "com.apple.springing.enabled" = true;
      "com.apple.swipescrolldirection" = true;
      "com.apple.trackpad.enableSecondaryClick" = true;
      "com.apple.trackpad.forceClick" = true;
      "com.apple.trackpad.scaling" = 3.0;
      "com.apple.trackpad.trackpadCornerClickBehavior" = 1;
    };
    SoftwareUpdate.AutomaticallyInstallMacOSUpdates = true;
  };
}
