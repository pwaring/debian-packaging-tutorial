% Debian Packaging
% Paul Waring (paul@xk7.net)
% January 19, 2013

# Prerequesites

Make sure you have the `build-essential` and `devscripts` packages installed:

    sudo apt-get install build-essential devscripts
    
This will pull in a number of dependencies, so you may have to wait a few minutes.

# Environment

In order to build packages with the correct metadata, two environment variables need to be set: `DEBFULLNAME` and `DEBEMAIL`. You can set these in your `~/.bashrc` like so:

    export DEBFULLNAME='Paul Waring'
    export DEBEMAIL='paul@xk7.net'

For these changes to take effect, start a new terminal or execute `source ~/.bashrc`.

# Package Creation

Create and enter a temporary directory to build the package in.

    mkdir /tmp/debian-tutorial
    cd /tmp/debian-tutorial

Download the source - in this case from Github:

    wget https://github.com/fabpot/Twig/tarball/v1.9.2

Debian assumes specific file names, of the format:

    [PACKAGE_NAME]_[VERSION].orig.tar.gz
    twig_1.9.2.orig.tar.gz

So let's rename the file now:

    mv v1.9.2 twig_1.9.2.orig.tar.gz

Now extract the file, but we must remember to strip the first component of the file path (which will be something like `fabpot-Twig-75d3d9f`).

    mkdir twig-1.9.2
    tar --strip-components=1 -xzvf twig_1.9.2.orig.tar.gz -C twig-1.9.2

Produce directories for the various files.

    cd twig-1.9.2
    mkdir debian
    mkdir debian/source
    cd debian

Now we need to create some of the files required. First, let's produce the basic ones which we don't need to change.

    echo '8' > compat
    echo '3.0 (quilt)' > source/format

For the rules file, we are going to cheat slightly and use one which I prepared earlier.

    wget http://tinyurl.com/debrules -O rules
    chmod 755 rules

Add the following line after the `dh_installdirs` rule of the `install` target. Remember to start the line with a tab, as this is a makefile.

    cp -r lib/Twig debian/twig/usr/share/php/twig/

Create the `.dirs` file, which lists all directories created for this package, one per line, and has the same name as the package.

    touch twig.dirs

Add the following line - only one directory required for this package.

    usr/share/php/twig

Now we need a skeleton changelog file. Change to the parent directory.

    cd ../
    dch --create

This will create a file `debian/changelog` and start an editor process. Make sure you add `-1` to the version, as this is a Debian-specific requirement.

Open a file `debian/control` in your favourite editor.

    Source: twig
    Maintainer: Paul Waring <paul@xk7.net>
    Section: misc
    Priority: optional
    Standards-Version: 3.9.3
    Build-Depends: debhelper (>= 8)

    Package: twig
    Architecture: all
    Depends: php5 (>= 5.3), ${misc:Depends}
    Description: PHP template library

There are some additional lines you can add, such as checksums, homepage etc.

Explanations of some of these lines:

`Package:` Name of the package.

`Architecture:` If files are the same on all architectures (which is the case for a library consisting of PHP files), set this to `all`. Can be set to `any` if it is a binary package which works on all architectures, or a list of architectures, e.g. `amd64 i386`.

Now we need to specify the licence.

    cd debian/
    wget http://tinyurl.com/debcopy -O copyright

Finally, let's build the package:

    cd ../
    debuild -us -uc

`-us -uc` means 'do not sign the changes file or the non-existent `.dsc` file'.

Install the `.deb` file. Make sure dependencies have been installed first!

    cd ../
    sudo dpkg -i twig_1.9.2-1_all.deb

Head to the installation directory to see if the files are there:

    cd /usr/share/php/twig
    ls -l

Check the list of installed packages:

    sudo apt-cache search twig

Remove the package:

    sudo apt-get purge twig

Verify that the files and package have been deleted:

    cd /usr/share/php/twig
    sudo apt-cache search twig

# File Intend to Package (ITP) bug

An ITP bug alerts other users to the fact that you are intending to package a particular piece of software, so that others can offer help, mentoring or sponsorship. All bugs of this type are filed against the special `wnpp` package. You should also check to see whether anyone has already filed an ITP bug for the same package, so that you do not duplicate efforts. Using the `reportbug` command will help you find potential duplicate bugs.

This step is optional if you are intending to produce a package for private use, e.g. of a closed source web application.

Here's one I prepared earlier: http://bugs.debian.org/645883
