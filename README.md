# nmap-docker
A containerised version [Nmap (Network Mapper)](https://nmap.org/).

# To Do
- Extract nmap scan output files saved within the containers.

## Building the container
```bash
docker build -t nmap-docker:latest
```
## Running the container
```bash
docker run --rm nmap-docker <NMAP_ARGS>
```

## Dockerfile Entrypoint
```dockerfile
ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/nmap", "--privileged"]
```

## Libcap and Nmap privileged execution
Modifications have been made to the 'nmap' binary inside the container that allows its to run privileged arguments such as: -sS (Syn Scans) or -u (UDP scans) without requiring the binary or container to be run as the root user.

This is acheived by modifiying the Linux capabilities / kernel attributes.

`CAP_NET_RAW` and `CAP_NET_BIND_SERVICE+eip` attributes gives Nmap the privileges it needs to run without checking for root user permissions.

```dockerfile
...
apk add --no-cache libcap && \
setcap cap_net_raw,cap_net_bind_service+eip $(which nmap)
...
```

Now that we have these two capabilities set, we can run Nmap without sudo privileges by using the `--privilege` flag to let Nmap know that it has these capabilities.
