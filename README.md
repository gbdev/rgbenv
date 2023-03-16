# rgbenv

This is a version manager for [RGBDS](https://github.com/gbdev/rgbds) that's a pure shell script.* Inspired by [pyenv](https://github.com/pyenv/pyenv) and [rbenv](https://github.com/rbenv/rbenv), it lets you easily switch between multiple versions of the RGBDS suite to suit different projects.

\* Bash script, at the moment. Compatibility with other shells is not guaranteed.

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

* A Unix-like environment with GNU coreutils
    * Linux or BSD preferable
    * On Windows, you may use [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) with a distro of choice or MSYS2 (Cygwin may work?)
* git
* curl
* RGBDS [build dependencies](https://rgbds.gbdev.io/install/#building-from-source)

You can use these commands to get them:
<ul>
<li>Debian: <pre><code># apt update
# apt install libpng-dev pkg-config build-essential bison git curl
</code></pre></li>
<li>Alpine Linux: <pre><code># apk add findutils coreutils grep git curl make pkgconfig gcc libc-dev libpng-dev bison
</code></pre></li>
</ul>

## How do I set it up?

<ol>
<li>Install whatever dependencies it needs, through the above section.</li>
<li>Download the rgbenv script, and place it in <code>/usr/local/bin/</code> (or any directory listed when you run <code>echo $PATH</code>) The fastest way is through: <pre><code># curl https://raw.githubusercontent.com/ZoomTen/rgbenv/master/rgbenv > /usr/local/bin/rgbenv</code></pre></li>
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
