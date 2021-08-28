# autorestic-docker

| Mount | Description ||
| /autorestic/config/autorestic.yml | autorestic configuration file | Required |
| /autorestic/locations | All locations defined as from in the config file.	Required |
| /autorestic/backends | All paths defined for backends with type: local in the config file |
| /autorestic/cache | Your restic cache folder | Optional |

# autorestic commands

See https://autorestic.vercel.app/cli/general

```
autorestic -c /autorestic/config/autorestic.yml check
autorestic -c /autorestic/config/autorestic.yml info
autorestic -c /autorestic/config/autorestic.yml backup -a
```

# restic commands
See:
* https://autorestic.vercel.app/cli/exec
* https://restic.readthedocs.io/en/stable/manual_rest.html

```
autorestic -c /autorestic/config/autorestic.yml exec -a -- snapshots  --json
```
