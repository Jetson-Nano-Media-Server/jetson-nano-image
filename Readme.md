# Nvidia Jetson Minimalist Images

!!! DISCLAIMER !!!  
This repository is for personal use. It removes all options except Ubuntu 20.04 for Jetson Nano 2/4GB.
Refer to the [original repository](https://github.com/pythops/jetson-image) for other models and more updates.

## Supported boards

- [x] Jetson nano
- [x] Jetson nano 2gb

## Spec

**Supported Ubuntu releases**: 20.04  
**L4T versions**: 32.x

## Build the jetson image

> [!NOTE]
> Building the jetson image has been tested only on Linux machines.

Building the jetson image is fairly easy. All you need to have is the following tools installed on your machine.

- [podman](https://github.com/containers/podman)
- [just](https://github.com/casey/just)
- [jq](https://github.com/stedolan/jq)
- [qemu-user-static](https://github.com/multiarch/qemu-user-static)

Start by cloning the repo from github

```bash
git clone --depth=1 https://github.com/pythops/jetson-image # or in this case https://github.com/MilanTodorovic/jetson-image
cd jetson-image
```

Then create a new rootfs with Ubuntu 20.04:

```
just build-jetson-rootfs 20.04
```

This will create the rootfs in the `rootfs` directory.

> [!TIP]
> You can modify the `Containerfile.rootfs.*` files to add any tool or configuration that you will need in the final image.

Next, use the following command to build the Jetson image:

```
$ just build-jetson-image -b <board> -r <revision> -d <device>
```

> [!TIP]
> If you wish to add some specific nvidia packages that are present in the `common` section from [this link](https://repo.download.nvidia.com/jetson/)
> such as `libcudnn8` for instance, then edit the file`l4t_packages.txt` in the root directory, add list each package name on separate line.

For example, to build an image for `jetson-nano` board:

```bash
$ just build-jetson-image -b jetson-nano -d SD -l 32
```

Run with `-h` for more information

```bash
just build-jetson-image -h
```

> [!NOTE]
> Not every jetson board can be updated to the latest l4t version.
>
> Check this [link](https://developer.nvidia.com/embedded/jetson-linux-archive) for more information.

The Jetson image will be built and saved in the current directory in a file named `jetson_nano_ubuntu20.img`

## Flashing the image into your board

To flash the jetson image, just run the following command:

```
$ sudo just flash-jetson-image <jetson image file> <device>
```

Where `device` is the name of the sdcard/usb identified by your system.
For instance, if your sdard is recognized as `/dev/sda`, then replace `device` by `/dev/sda`

> [!NOTE]
> There are numerous tools out there to flash images to sd card that you can use. I stick with `dd` as it's simple and does the job.

## Nvidia Libraries

Once you boot the board with the new image, then you can install Nvidia libraries using `apt`

```bash
$ sudo apt install -y libcudnn8 libcudnn8-dev ...
```

## Result

For the `jetson orin nano` for instance with the new image, only 220MB of RAM is used, which leaves plenty of RAM for your projects !

![](https://github.com/user-attachments/assets/7404e20f-3ccd-42c7-b8d6-e93c635aa6f0)

## License

AGPLv3
