deluged
=======

Create a volume container for the /config data:

```bash
docker run -d -v /config --name deluged-config busybox true
```

If you are not mapping volumes from the host, then also make a data volume:

```bash
docker run -d -v /data --name deluged-data busybox true
```

**NOTE** the path /data is arbitrary, and nothing in this Dockerfile relies
upon it

Build the image:

```bash
docker build -t <TAG_NAME> ./
```

Then run the deluged container:

```bash
docker run -d --volumes-from deluged-config -v /host/path:/container/path --name deluged <TAG_NAME>
```

**OR**

```bash
docker run -d --volumes-from deluged-config --volumes-from deluged-data --name deluged <TAG_NAME>
```

The deluge daemon will listen on port 58846, a user ``deluge`` and a random
password will be created on first start if the ``deluge`` user doesn't exist
in the /config/auth file. Check the logs to see what password was generated:

```bash
docker logs deluged
```

Then use these credentials to connect via any deluge client.
