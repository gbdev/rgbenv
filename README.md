# rgbenv

This is a version manager for [RGBDS](https://github.com/gbdev/rgbds). It is a pure shell script.* Inspired by [pyenv](https://github.com/pyenv/pyenv) and [rbenv](https://github.com/rbenv/rbenv), it lets you easily switch between multiple versions of the RGBDS suite to suit different projects.

\* Bash script, at the moment. Compatibility with other shells is not guaranteed.

## Quickstart (Debian)

```sh
sudo apt install -y libpng-dev pkg-config build-essential bison git curl
sudo curl -o /usr/local/bin/rgbenv https://raw.githubusercontent.com/gbdev/rgbenv/master/rgbenv
sudo chmod +x /usr/local/bin/rgbenv
yes | rgbenv install 0.7.0
rgbenv use 0.7.0
echo 'export PATH=$HOME/.local/share/rgbenv/default/bin:$PATH' >> .bashrc
source .bashrc

rgbasm -V
```

## What does it do?

* Installs or uninstalls a specific version of the RGBDS suite.
* Lets you configure the default version to use.
* Lets you specify a version to be used with a specific project.

## How does it do that?

`PATH` is the variable used by the system to determine where to find some program. It contains a list of directories, separated by a colon each:
```
/usr/local/bin:/usr/bin:/bin:/usr/local/sbin
```
Left-most directories take priority. If a program isn't found there, it will search the directory next to it.

As an example, if you installed RGBDS 0.6.0 through your package manager, it would place the suite programs in `/usr/bin`. If you compiled, say, version 0.4.1 of RGBDS manually and placed it in `/usr/local/bin`, then *that* version would take precedence over 0.6.0.

What rgbenv does is override this variable so that its managed folder takes precedence over that of the system. In Unix-like systems, you can check which directory a program is to be run from (for example, `rgbasm`) using this command:
```sh
$ which rgbasm
```

## What do I need?

* A Unix-like environment
    * Linux or BSD preferable
    * On Windows, you may use either:
      * [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) with a distro of choice
      * [MSYS2](https://www.msys2.org/)
      * [Cygwin](https://cygwin.com/)
* git
* curl
* [RGBDS build dependencies](https://rgbds.gbdev.io/install/source/#2-build)

You can use these commands to get them:
<ul>
<li>Debian: <pre><code># apt update
# apt install libpng-dev pkg-config build-essential bison git curl
</code></pre></li>
<li>Alpine Linux: <pre><code># apk add git curl make libpng-dev bison gcc g++ libc-dev
</code></pre></li>
<li>OpenBSD: <pre><code># pkg_add png git bash curl bison
</code></pre>In case something goes wrong, try using GCC as the compiler:<pre><code># pkg_add g++ gcc
$ CC=egcc CXX=eg++ rgbenv install $YOUR_DESIRED_VERSION</code></pre></li>
<li>Windows MSYS2 (MinGW64): <pre><code>$ pacman -S git make bison pkgconf mingw-w64-x86_64-gcc mingw-w64-x86_64-libpng
</code></pre>If you're using another environment with MSYS2, replace <code>mingw-w64-x86_64</code> with the corresponding name. You may need to do <code>mkdir -p /usr/local/bin</code> first.</li>
<li>Windows Cygwin: From the setup program, select the latest versions of these packages:<ul>
<li>git</li>
<li>gcc-g++</li>
<li>libpng-devel</li>
<li>pkgconf</li>
<li>bison</li>
<li>make</li>
</ul></li>
</ul>

## How do I set it up?

<ol>
<li>Install whatever dependencies it needs, through the above section.</li>
<li>Download the rgbenv script, and place it in <code>/usr/local/bin/</code> (or any directory listed when you run <code>echo $PATH</code>) The fastest way is through: <pre><code># curl https://raw.githubusercontent.com/gbdev/rgbenv/master/rgbenv > /usr/local/bin/rgbenv</code></pre></li>
<li>Ensure the script is executable: <pre><code># chmod +x /usr/local/bin/rgbenv
</code></pre>(replace <code>/usr/local/bin/rgbenv</code> with where you put the rgbenv script)</li>
<li>Install the version you want, say 0.6.0:<pre><code>$ rgbenv install 0.6.0
</code></pre></li>
<li>When prompted to add <code>export PATH=...</code> to <code>.bash_profile</code>, do so, then run: <pre><code>$ source ~/.bash_profile
</code></pre><strong>Note: in some shells, you may need to specify <code>.profile</code> instead of <code>.bash_profile</code>.</strong></li>
<li>Set your version as the default: <pre><code>$ rgbenv use 0.6.0
</code></pre></li>
<li>Verify that RGBDS really is the version you picked: <pre><code>$ rgbasm -V
</code></pre></li>
</ol>

## How to set a project-specified version

On the current working directory, make a file named `.rgbds-version`. This shall be a text file containing only the version number to be used. For example:
```
$ cat .rgbds-version
0.6.0
```

## Quick commands

* `rgbenv use 0.5.1` - set default RGBDS version to 0.5.1
* `rgbenv no-use` - clear the defaults and use the system-provided RGBDS, if any
* `rgbenv exec -v 0.4.2 make` - run `make` using RGBDS 0.4.2
* `rgbenv exec make` - run `make` with the project-specified RGBDS version.

## Development

At the moment, rgbenv is hosted on GitHub.

To run the unit tests on your own machine, clone the rgbenv repo (instead of just downloading the script as above), and then run `make test`:

```
$ git clone https://github.com/gbdev/rgbenv
$ cd rgbenv
$ make test
```

As the unit tests use [Bats](https://github.com/bats-core/bats-core), the Bats repo will be cloned automatically inside the rgbenv directory if it is not present, and then Bats will be run from there.
