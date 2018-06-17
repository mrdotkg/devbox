# DevBox

### Installation
```SHELL
vagrant up
```
The build process feedback can be found in file `~/vm_build.log` inside devbox.

```SHELL
git version 2.7.4
Python 2.7.12
pip 8.1.1 from /usr/lib/python2.7/dist-packages (python 2.7)
Python 3.5.2
pip 8.1.1 from /usr/lib/python3/dist-packages (python 3.5)
curl 7.47.0 (x86_64-pc-linux-gnu) libcurl/7.47.0 GnuTLS/3.4.10 zlib/1.2.8 libidn/1.32 librtmp/2.3
PHP 7.0.30-0ubuntu0.16.04.1 (cli) ( NTS )
Server version: Apache/2.4.18 (Ubuntu) Server built: 2018-04-18T14:53:04
mysql Ver 14.14 Distrib 5.7.22, for Linux (x86_64) using EditLine wrapper
ii  phpmyadmin                       4:4.5.4.1-2ubuntu2                         all          MySQL web administration tool
nodejs v10.4.1
npm 6.1.0
bower 1.8.4
gulp [03:13:15] CLI version 3.9.1
aws-cli/1.15.40 Python/3.5.2 Linux/4.4.0-122-generic botocore/1.10.40
Terraform v0.11.7
```

### Available provisions
* localhost [http://192.168.33.10/](http://192.168.33.10/)
* phpmyadmin [http://192.168.33.10/phpmyadmin](http://192.168.33.10/phpmyadmin)

### Remote SSH into devbox
```SHELL
ssh-keygen -t rsa
```
You will see something like this
```SHELL
Your identification has been saved in /Users/kumar/.ssh/id_rsa.
Your public key has been saved in /Users/kumar/.ssh/id_rsa.pub.
```
Copy the content of `id_rsa.pub` and append it to `~/.ssh/authorized_keys` in the vm
```SHELL
vagrant ssh
vagrant@devbox:~$ copied_public_key >> ~/.ssh/authorized_keys
```
Replace **_copied_public_key_** with with your own public key.

### Alias for easy ssh
```SHELL
dev() {
    cd /path/to/devbox
    vagrant ssh
}
```
This will add `dev` command alias to ssh into devbox

### References

* https://unix.stackexchange.com/questions/23291/how-to-ssh-to-remote-server-using-a-private-key
* https://stackoverflow.com/a/8967864/2189773