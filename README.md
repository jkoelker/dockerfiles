PiTorrent
=========

Build the image:

```bash
docker build -t <TAG_NAME> ./
```

Then run the container:

```bash
docker run -d -v /path/to/rtorrent.sock:/rtorrent.sock --name pitorrent <TAG_NAME>
```

PiTorrent will listen on its default port 3000.
