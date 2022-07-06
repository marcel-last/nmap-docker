# nmap-docker
A containerised version [Nmap (Network Mapper)](https://nmap.org/).

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
Modifications have been made to the 'nmap' binary that allows its to run privileged arguments such as: -sS (Syn Scans) or -u (UDP scans) without having the process or container run as root.

This is acheived by modifiying the Linux capabilities / kernel attributes.
`CAP_NET_RAW` and `CAP_NET_BIND_SERVICE+eip` attributes gives Nmap the privileges it needs to run without checking for root user permissions.

```dockerfile
RUN
...
apk add --no-cache libcap
setcap cap_net_raw,cap_net_bind_service+eip $(which nmap)
...

 ENTRYPOINT ["/sbin/tini", "--", "/usr/bin/nmap", "--privileged"]
```

Now that we have these two capabilities set, we can run Nmap without sudo privileges by using the `--privilege` flag to let Nmap know that it has these capabilities.
