{ stdenv, fetchurl, autoPatchelfHook, makeWrapper, zlib, lib }:

stdenv.mkDerivation rec {
  pname = "kotlin-lsp";
  version = "262.4739.0";

  src = fetchurl {
    url = "https://download-cdn.jetbrains.com/kotlin-lsp/${version}/kotlin-server-${version}.tar.gz";
    hash = "sha256-RpcREMm4ozYM4/31Q3Rn9MRH2tN61z2/gdZK9neeQQU=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

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
    cp -r ./* $out/share/kotlin-lsp/
    chmod +x $out/share/kotlin-lsp/bin/intellij-server

    makeWrapper $out/share/kotlin-lsp/bin/intellij-server $out/bin/kotlin-lsp

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
