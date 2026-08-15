# Jason H Nicholson - Personal Website

## Publishing
This repo is source code for jasonhnicholson.com.

To publish the site, assuming no local render cache, run the following command:

```bash
quarto publish gh-pages --no-prompt
```

If publishing second or more time with a cache, run the following which saves the render time:

```bash
quarto publish gh-pages --no-render --no-prompt
```

## Extensions

### rchaput/acronyms

This extension is used for managing acronyms in the site. For more information, see [https://github.com/rchaput/acronyms](https://github.com/rchaput/acronyms) and [https://rchaput.github.io/acronyms/articles/options.html#insert_loa](https://rchaput.github.io/acronyms/articles/options.html#insert_loa)