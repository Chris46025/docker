- Run the boot2docker installer http://docs.docker.com/installation/mac/
- Use boot2docker 1.6.2,  looks like 1.7 got a nasty certificate bug https://github.com/boot2docker/boot2docker/issues/824


- `$ . config/build.sh`
- `$ . config/start.sh`

Safely power down your boot2docker VM when not using or restarting your laptop.
`$ boot2docker save`

And then bring it up safely.
`$ boot2docker up`