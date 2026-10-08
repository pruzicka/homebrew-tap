class WallpaperPicker < Formula
  desc "Pick macOS wallpapers from a fanned deck of colour-chip cards"
  homepage "https://github.com/pruzicka/wallpaper-picker"
  url "https://github.com/pruzicka/wallpaper-picker.git",
      tag:      "v0.3.0",
      revision: "41a65bbf15419a9e7c34529eb17d9f7ea7daf8e3"
  license "GPL-3.0-only"
  head "https://github.com/pruzicka/wallpaper-picker.git", branch: "main"

  depends_on macos: :sonoma

  def install
    # Homebrew's build sandbox doesn't allow SwiftPM's own.
    ENV["SWIFT_BUILD_FLAGS"] = "--disable-sandbox"
    system "./bundle.sh"
    prefix.install "build/WallpaperPicker.app"

    # Runs the binary inside the app: a symlink wouldn't find its bundle.
    (bin/"wallpaper-picker").write <<~SH
      #!/bin/sh
      exec "#{opt_prefix}/WallpaperPicker.app/Contents/MacOS/WallpaperPicker" "$@"
    SH
    chmod 0755, bin/"wallpaper-picker"
  end

  def caveats
    <<~EOS
      Wallpaper Picker lives in the menu bar; open the picker with ⌃⌥W.

      Start it:
        open #{opt_prefix}/WallpaperPicker.app
      Choose your wallpaper folder (default ~/Pictures/Wallpapers):
        wallpaper-picker --dir=~/Pictures/Wallpapers
      To find it in Spotlight and Launchpad:
        ln -sf #{opt_prefix}/WallpaperPicker.app ~/Applications/
    EOS
  end

  test do
    assert_match "Usage: wallpaper-picker", shell_output("#{bin}/wallpaper-picker --help")
  end
end
