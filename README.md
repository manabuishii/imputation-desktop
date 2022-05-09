# imputation-desktop
Linux Desktop for imputation

## Test on container

```console
docker run --name desktoptest --rm -p 6080:80 -v $PWD/scripts:/scripts -v /dev/shm:/dev/shm dorowu/ubuntu-desktop-lxde-vnc
```

after VNC login

```console
/scripts/install.sh
```
