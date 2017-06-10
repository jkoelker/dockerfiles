Eagle CAD
=========

```bash
docker run -v /tmp/.X11-unix:/tmp/.X11-unix \
           -v "$HOME:/home/eagle" \
           -v "/run/user:/run/user" \
           -e DISPLAY="$DISPLAY" \
           -e DBUS_SESSION_BUS_ADDRESS="$DBUS_SESSION_BUS_ADDRESS" \
           --rm \
           --user="$UID" \
           --name eagle \
           eagle:latest
```
