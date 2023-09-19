<div align="center">

# asdf-kubeswitch [![Build](https://github.com/daveneeley/asdf-kubeswitch/actions/workflows/build.yml/badge.svg)](https://github.com/daveneeley/asdf-kubeswitch/actions/workflows/build.yml) [![Lint](https://github.com/daveneeley/asdf-kubeswitch/actions/workflows/lint.yml/badge.svg)](https://github.com/daveneeley/asdf-kubeswitch/actions/workflows/lint.yml)

[kubeswitch](https://github.com/danielfoehrKn/kubeswitch) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [asdf-kubeswitch  ](#asdf-kubeswitch--)
- [Contents](#contents)
- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

- `bash`, `curl`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add kubeswitch
# or
asdf plugin add kubeswitch https://github.com/daveneeley/asdf-kubeswitch.git
```

kubeswitch:

```shell
# Show all installable versions
asdf list-all kubeswitch

# Install specific version
asdf install kubeswitch latest

# Set a version globally (on your ~/.tool-versions file)
asdf global kubeswitch latest

# Now kubeswitch 'switcher' is available
kubeswitch -h

#Required: source the shell function
# see https://github.com/danielfoehrKn/kubeswitch/blob/master/docs/installation.md for more options
echo 'source <(switcher init bash)' >> ~/.bashrc
source ~/.bashrc

```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/daveneeley/asdf-kubeswitch/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Dave Neeley](https://github.com/daveneeley/)
