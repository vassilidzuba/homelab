# Git

## Share a repo between two servers

use case: there is repo *homelab* in GiuHub, that we want to push to gitea.

The commands are 

    git clone https://github.com/vassilidzuba/homelab.git
    git remote add gitea http://odin:3000/vassili/homelab.git

then create an empty repo homelab in gitea, using the UI. After that:

    git push gitea main

note: it is possible to give the use on gitea the right to "push to create", which is disabled by default

After doing acommit locally, one need to do

    git push origin main
    git push gitea main