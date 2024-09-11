# tl;dr
Simple script for building a Debian package for the OBS plugin "backgroundremoval"

# Situation
* Debian packages OBS (obs-studio) but lacks the popular plugin "backgroundremoval" (for removing/bluring background in video sources)
* The author of the plugin "[backgroundremoval](https://github.com/locaal-ai/obs-backgroundremoval/)" doesn't provide .deb packages for Debian (but for Ubuntu)
* I don't like installing things with flatpak (images exist on flathub for both OBS and that plugin)

# Solution
I copied over the build script and Dockerfile from [https://github.com/Froosh/build-obs-backgroundremoval](https://github.com/Froosh/build-obs-backgroundremoval)
and adapted them for Debian (bookworm). I compiled .debs for both amd64 (x86_64) and arm64 (aarch64) and created a release with them attached.

If you want to build a .deb yourself, just clone this repo and run `./build.sh` - the only real prerequisite is podman, so if it is not installed, this script will
just say that and exit. Otherwise, after a few minutes you should have a fresh .deb sitting right there.

# Notes
* I published a 'v1.0' release and I expect this one to be the only release ever - but you never know....so, feel free to create an issue or PR
* As Froosh published those files under GPL2, I picked GPL2 for this repository as well.
