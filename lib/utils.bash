#!/usr/bin/env bash

set -euo pipefail

GH_REPO="https://github.com/danielfoehrKn/kubeswitch"
TOOL_NAME="kubeswitch"
TOOL_TEST="kubeswitch -h"
TOOL_NAME2="switcher"
TOOL_TEST2="switcher -h"

fail() {
	echo -e "asdf-$TOOL_NAME: $*"
	exit 1
}

curl_opts=(-fsSL)

# NOTE: You might want to remove this if kubeswitch is not hosted on GitHub releases.
if [ -n "${GITHUB_API_TOKEN:-}" ]; then
	curl_opts=("${curl_opts[@]}" -H "Authorization: token $GITHUB_API_TOKEN")
fi

sort_versions() {
	sed 'h; s/[+-]/./g; s/.p\([[:digit:]]\)/.z\1/; s/$/.z/; G; s/\n/ /' |
		LC_ALL=C sort -t. -k 1,1 -k 2,2n -k 3,3n -k 4,4n -k 5,5n | awk '{print $2}'
}

list_github_tags() {
	git ls-remote --tags --refs "$GH_REPO" |
		grep -o 'refs/tags/.*' | cut -d/ -f3- |
		sed 's/^v//' # NOTE: You might want to adapt this sed to remove non-version strings from tags
}

list_all_versions() {
	list_github_tags
}

download_release() {
	local version filename url platform arch
	version="$1"
	filename="$2"
	platform="unsupported" # filled by `case` below
	arch="unsupported"     # filled by `case` below

	case "$(uname)" in
	"Linux")
		platform="linux"
		;;
	"Darwin")
		platform="darwin"
		;;
	esac

	case "$(uname -m)" in
	"x86_64")
		arch="amd64"
		;;
	"aarch64")
		arch="arm64"
		;;
	"arm64")
		arch="arm64"
		;;
	esac

	asset="switcher_${platform}_${arch}"

	url="${GH_REPO}/releases/download/${version}/${asset}"

	echo "* Downloading $TOOL_NAME release $version..."
	curl "${curl_opts[@]}" -o "$filename" -C - "$url" || fail "Could not download $url"
}

install_version() {
	local install_type="$1"
	local version="$2"
	local install_path="${3%/bin}/bin"

	if [ "$install_type" != "version" ]; then
		fail "asdf-$TOOL_NAME supports release installs only"
	fi

	(
		mkdir -p "$install_path"
		cp -r "$ASDF_DOWNLOAD_PATH"/* "$install_path"

		local tool_cmd
		tool_cmd="$(echo "$TOOL_TEST" | cut -d' ' -f1)"
		test -x "$install_path/$tool_cmd" || fail "Expected $install_path/$tool_cmd to be executable."

		echo "$TOOL_NAME $version installation was successful!"

		local tool_cmd2
		tool_cmd2="$(echo "$TOOL_TEST2" | cut -d' ' -f1)"

		# create a relative symlink to the binary in the install directory
		ln -sfn "$install_path/$tool_cmd" "$install_path/$tool_cmd2" || fail "Could not create symlink $install_path/$tool_cmd2"
		test -x "$install_path/$tool_cmd2" || fail "Expected $install_path/$tool_cmd2 to be executable."

		echo "$TOOL_NAME2 $version installation was successful!"
	) || (
		rm -rf "$install_path"
		fail "An error occurred while installing $TOOL_NAME $version."
	)
}
