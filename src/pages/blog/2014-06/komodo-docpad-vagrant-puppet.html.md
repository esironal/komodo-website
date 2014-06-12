---
title: Komodo Website Development Deploy
author: Carey Hoffman
date: 2014-05-28
tags: [virtualbox, vagrant, pupper, shared folder, SharedFoldersEnableSymlinksCreate, docpad]
description: Launch a development environment for the Komodo website (or any docpad site) using Vagrant, Puppet, Virtualbox
layout: blog
---

When [Nathan Rijksen][1] moved the [Komodo website to docpad][2]
it allowed for a much more fun way to make changes to the site.  You have to have
a development environment setup to test the changes locally but that's not an
issue. That is unless you're like me and work mainly in Windows.  It doesn't help
having had very little Node prior to getting started.  Of
course, I congiured a VM to work on the website, but doing that again any time I
came to a new environment or some how I hooped my VM seemed silly.  I had just
learned to use Puppet in with Vagrant so I path to easily set this up.

## The Pieces

Too pull this off I used 3 pieces.  Vagrant deployment utilty, Puppet ochestration,
and the VirtualBox Hypervisor.  Thankfully all these technologies play quite nicely
together, save for one minor issue that had me stumped.

###Vagrant
Vagrant was rediculously easy to use.  Their docs get your started in no time 

## The Process

Using Puppet with Vagrant, it was easy to keep the work separated into two disctinct
groups; VM configuration and environment configuration.

I used the Vagrantfile to configure the Machine before it started.  I kept it minimal.
I set a name and small memory footprint for the VM.

At some point after VBox version 4.16 was released, Oracle disabled symlink creation
in shared folders.  Makes sense.  Their implementation of Shared Folders allowed
symlinks to be created to folders outside the guest into the host.  That's no
fun but we're using Nodejs and npm soooo, we need symlinks.  Thankfully Oracle
allowed for this to be enabled using a VBoxInternal2 setting (USE GIT COMMIT
REFERECNE LINK HERE)7

Using Puppet to install packages made my life pretty easy.  Puppet has a great
resource in Puppet-Labs.  For the most part, you can find a branch of each project
on github.  I added them as submodules to the Komodo-Website repo to keep
things manageable.

## Work Flow

Now it's as easy as pulling the Komodo-website repo and running ```vagrant up```
in the repo root (where the Vagrantfile lives) and I have a dev environment for
the website.  That's assuming I already have Vbox installed and Vagrant.  The
former I always do. The latter, not quite as often.  

Given that it was 3 tools I was learning, there was definitely a learning curve.
Now that it's setup and I've got a basic understanding of how the tools
work it's been really easy to accomodate changes to the site.  Nathan [removed the Ruby dependancy by replacing SASS with Node-SASS][6].
This just meant removing the Ruby and bundler submodules in Puppet and deleting
them out of the puppet/development.pp manifest and rebuilding the site.  Granted,
the ease of use can be attributed to Nathan's choice of packaging tools and
packages.

## Issues Resolved

###"bower install" Failing when nothing else was failing
Puppet's not always forthcoming with the error output.  To figure out an issue with
```ko-bower-install``` class in ```development.pp``` I ended up appending '''2> help.log''' to
the command being run and finally found out that Puppet Exec commands are run as
root and Bower has issues with that:
'''If you're having permission errors when using bower without sudo, please spend a
few minutes learning more about how your system should work and make any necessary
repairs.'''

###Symlink errors during ```npm install``` AKA. STUMPED
This either means you didn't [set the VBox variable to enable Symlinks][5] OR you're
not running your Windows CMD window  as '''Administator'''.  The variable is set
in the Vagrantfile for the Komodo website already so you're probably doing the
latter.  Windows 

###default: Error: Connection timeout. Retrying...###
You'll see this while trying to ```vagrant up --provision``` your VM.  This is
only usually a problem if you're actively developing your Vagrant/Puppet setup
but chances are, people will find this and maybe (hopefull!) find it useful and
bend it to their will in which case, you will more than likely hit this error.

I found the [solution on (surprise!) Stackoverflow][3].  The answer from [harrie][4]
is a little bit of VBox commandline voodoo which I think is way more fun than any
of the other answers


## The Future

So for me, the future is very bright. I don't anticipate that I won't ever touch
a CMS again; as I said static site generators do not replace them, they merely
offer an alternative approach which will be relevant in some cases, and not in
others. And I look forward to seeing their relevancy increase.


  [1]: /authors/#NathanRijksen
  [2]: /blog/2014-05/the-state-of-static-site-generators/
  [3]: http://stackoverflow.com/questions/22575261/vagrant-stuck-connection-timeout-retrying
  [4]: http://stackoverflow.com/a/23095019/1596011
  [5]: https://www.virtualbox.org/ticket/10085#comment:14
  [6]: https://github.com/Komodo/komodo-website/commit/05e93bd5fc435f475c7048dc4b4fa7f9566e949c