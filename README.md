# reMarkable PDFlets

A "PDFlet" is a document on the reMarkable which triggers a script and updates the document, similar to a bookmarklet.

I use a systemd [path unit](https://www.freedesktop.org/software/systemd/man/systemd.path.html) and a simple shell script to directly build a PDF in order to achieve this.

- `weather` - displays weather from *wttr.in*.
- `twitter` - grabs latest Tweets.

![Weather](https://i.imgur.com/oCqzf3F.jpg)

![Twitter](https://i.imgur.com/Aawj3ia.jpg)

# Installation and Usage

Simply run `install.sh` from inside either `weather/` or `twitter/`.  Your device will reboot.

A new document will appear on your remarkable.  When you close and reopen this document, a script is run to regenerate it.

# Caveats

- `weather` and `twitter` need internet access
- I haven't found a way to refresh a document while it's open, which means you have to close and reopen to reload.
- Weather and Twitter are written in pure bash and busybox tools, which means they are ugly and maybe buggy

# Contributing

See `template/README.md`
