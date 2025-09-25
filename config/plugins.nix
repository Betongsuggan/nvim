{ ... }: let
  # Import plugin categories
  languageFeatures = import ./plugins/language-features.nix { };
  uiVisual = import ./plugins/ui-visual.nix { };
  editing = import ./plugins/editing.nix { };
  navigation = import ./plugins/navigation.nix { };
  testingDebug = import ./plugins/testing-debug.nix { };
in {
  # Merge all plugin configurations
  plugins = languageFeatures.plugins 
    // uiVisual.plugins 
    // editing.plugins 
    // navigation.plugins
    // testingDebug.plugins;
  
  # Merge keymaps from all modules
  keymaps = (languageFeatures.keymaps or [])
    ++ (uiVisual.keymaps or [])
    ++ (editing.keymaps or [])
    ++ (navigation.keymaps or [])
    ++ (testingDebug.keymaps or []);
    
  # Merge extraConfigLua from all modules  
  extraConfigLua = builtins.concatStringsSep "\n" [
    (languageFeatures.extraConfigLua or "")
    (uiVisual.extraConfigLua or "")
    (editing.extraConfigLua or "")
    (navigation.extraConfigLua or "")
    (testingDebug.extraConfigLua or "")
  ];
}
