{ stdenv, fetchurl, autoPatchelfHook, makeWrapper, unzip, zlib, lib }:

stdenv.mkDerivation rec {
  pname = "kotlin-lsp";
  version = "262.6274.0";
  extensionVersion = "0.0.4";

  # The standalone tar.gz on download-cdn.jetbrains.com isn't always updated for
  # every build, but the VS Code Marketplace VSIX is. The VSIX bundles the same
  # intellij-server. JetBrains EAP builds carry a hard expiry (~30 days), so
  # tracking the freshest available source matters.
  src = fetchurl {
    url = "https://marketplace.visualstudio.com/_apis/public/gallery/publishers/JetBrains/vsextensions/kotlin-server/${extensionVersion}/vspackage?targetPlatform=linux-x64";
    name = "kotlin-server-${version}-linux-x64.zip";
    # Marketplace serves a gzip-encoded response unconditionally; --compressed
    # strips transport gzip in-flight so the stored artifact is the deterministic VSIX zip.
    curlOptsList = [ "--compressed" ];
    hash = "sha256-8DTptlDfDMStXRRaAXEM4OG/wU21owpC9ijtuWuojAA=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper unzip ];

  # The bundled JetBrains Runtime carries native libs for AWT/Swing, Wayland/X11,
  # audio, etc. None of these are reached when running headless over stdio, so we
  # let autoPatchelf skip them. zlib *is* used at runtime (JAR loading, libzip).
  buildInputs = [ stdenv.cc.cc.lib zlib ];
  autoPatchelfIgnoreMissingDeps = true;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/kotlin-lsp $out/bin
    cp -r server/* $out/share/kotlin-lsp/
    chmod +x $out/share/kotlin-lsp/bin/intellij-server

    # Pin idea.config.path / idea.system.path to a stable per-project cache
    # so the LSP doesn't re-import Gradle (~24s) every nvim session. JetBrains
    # products read IJ_JAVA_OPTIONS at launch and append it to the JVM args.
    makeWrapper $out/share/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp \
      --run '
        # Walk all the way to / and keep the OUTERMOST directory holding any
        # marker, so a multi-module Gradle build (which has build.gradle.kts
        # in subprojects too) collapses to the single settings.gradle.kts
        # root instead of branching into per-subdir caches.
        _root="$PWD"; _dir="$PWD"
        while [ "$_dir" != "/" ] && [ -n "$_dir" ]; do
          for _m in settings.gradle.kts settings.gradle build.gradle.kts build.gradle pom.xml; do
            if [ -e "$_dir/$_m" ]; then _root="$_dir"; break; fi
          done
          _dir="$(dirname "$_dir")"
        done
        _hash="$(printf "%s" "$_root" | sha256sum | cut -c1-16)"
        _cache="''${XDG_CACHE_HOME:-$HOME/.cache}/kotlin-lsp/$_hash"
        mkdir -p "$_cache/config" "$_cache/system"
        export IJ_JAVA_OPTIONS="''${IJ_JAVA_OPTIONS:-} -Didea.config.path=$_cache/config -Didea.system.path=$_cache/system"
      '

    runHook postInstall
  '';

  meta = with lib; {
    description = "Official JetBrains Kotlin Language Server";
    homepage = "https://github.com/Kotlin/kotlin-lsp";
    license = licenses.asl20;
    platforms = [ "x86_64-linux" ];
    mainProgram = "kotlin-lsp";
  };
}
