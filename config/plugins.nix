{ ... }: let
  # Import plugin categories
  languageFeatures = import ./plugins/language-features.nix { };
  uiVisual = import ./plugins/ui-visual.nix { };
  editing = import ./plugins/editing.nix { };
  navigation = import ./plugins/navigation.nix { };
in {
  # Merge all plugin configurations
  plugins = languageFeatures.plugins 
    // uiVisual.plugins 
    // editing.plugins 
    // navigation.plugins;
}
