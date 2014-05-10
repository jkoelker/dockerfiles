btsync
======

Create a volume container for the /sync data:

```bash
docker run -d -v /sync --name btsync-sync busybox true
```

If you are not mapping volumes from the host, then also make a data volume:

```bash
docker run -d -v /data --name btsync-data busybox tru
```

**NOTE** the path /data is arbitrary, and nothing in this Dockerfile relies
upon it

Then run the btsync container:

```bash
docker run -d --volumes-from btsync-sync -v /host/path:/container/path --name btsync jkoelker/btsync
```

**OR**

```bash
docker run -d --volumes-from btsync-sync --volumes-from btsync-data --name btsync jkoelker/btsync
```

The web ui will be availible on port ``8888`` for further configuration. The
``listen_port`` is set to ``8889``.
