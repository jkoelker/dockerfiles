sickrage
========

Create a volume container for the /config data:

```bash
docker run -d -v /config --name sickrage-config busybox true
```

Create a volume container for the /data data:

```bash
docker run -d -v /data --name sickrage-data busybox true
```

Build the image:

```bash
docker build -t <TAG_NAME> ./
```

Then run the sickrage container:

```bash
docker run -d --volumes-from sickrage-config --volumes-from sickrage-data --name sickrage <TAG_NAME>
```

The sickrage listen on its default port 8081. The initial startup
takes some time, so don't be surprised if its not immedately web
accessible.
