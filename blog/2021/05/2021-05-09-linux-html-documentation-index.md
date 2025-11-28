---
title: Linux HTML Documentation Index
date: 2021-05-09
---
On Ubuntu Linux, there is a package called "dhelp". dhelp allows viewing the man and info pages through a web browser. I find this very useful. man2html and info2www are required for dhelp. dhelp may work on other Linux systems but I cannot confirm this.

```bash
sudo apt install dhelp man2html info2www
```

dhelp package description:

>Read all documentation with a WWW browser. dhelp builds an index of
>all installed HTML documentation. You don't need a WWW server to read
>the documentation. dhelp offers a very fast search in the HTML documents.
>
>You can access the online help system with the dhelp program or with
>your browser. The URL to point your browser at is (if you have a WWW
>server installed) http://localhost/doc/HTML/index.html , else (if you
>do not) file://localhost/usr/share/doc/HTML/index.html.

