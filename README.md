deluge-web
==========

Create a volume container for the /config data:

```bash
docker run -d -v /config --name deluge-config busybox true
```

Build the image:

```bash
docker build -t <TAG_NAME> ./
```

Then run the deluge-web container:

```bash
docker run -d --volumes-from deluge-config --name deluge-web <TAG_NAME>
```

The deluge webui will listen on port 8080.
