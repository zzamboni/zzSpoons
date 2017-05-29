# {{ title }}

**Note: this is not the official Hammerspoon Spoons repository - you can find it at
[http://www.hammerspoon.org/Spoons](http://www.hammerspoon.org/Spoons)**

This is [zzamboni](https://github.com/zzamboni/)'s own, unofficial
repository of Hammerspoon Spoons.  I keep things here that are either
for personal use, or that have not
been [submitted/merged](https://github.com/Hammerspoon/Spoons/pulls)
into the official repository. I make them available here so you can
use them if you like.

## How to use them

**Automatically (preferred):** Download and install
the [SpoonInstall](SpoonInstall.html) spoon, and use it to
automatically download, install and configure the other spoons. Please see
[my Hammerspoon configuration](https://github.com/zzamboni/dot-hammerspoon) for
working examples of how to use it.

**Manually:** download and open the zip files for the spoons you
want. Hammerspoon will install them, and you can then configure them
in your `init.lua` file.

---

## Project Links
| Resource        | Link                             |
| --------------- | -------------------------------- |
{% for link in links %}
| {{ link.name }} | [{{ link.url }}]({{ link.url }}) |
{% endfor %}

## API Documentation
| Module                                                             | Description           |
| ------------------------------------------------------------------ | --------------------- |
{% for module in data %}
| [{{ module.name }}]({{ module.name }}.md)                          | {{ module.desc }}     |
{% endfor %}
