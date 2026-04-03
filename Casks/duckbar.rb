cask "duckbar" do
  version "0.4.1"
  sha256 "d1248fe2e0f6b9e7ebb0c1090beb09c6a03def553f8e2e584fb51a41a2a54578"

  url "https://github.com/rofeels/duckbar/releases/download/v#{version}/DuckBar-#{version}.zip"
  name "DuckBar"
  desc "macOS menu bar app for monitoring Claude Code sessions"
  homepage "https://github.com/rofeels/duckbar"

  depends_on macos: ">= :sonoma"

  app "DuckBar.app"

  zap trash: [
    "~/Library/Preferences/com.munbbok.duckbar.plist",
  ]
end
