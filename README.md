# Cfg

My dotfiles.
This setup was inspired by [The best way to store your dotfiles: A bare Git repository](https://www.atlassian.com/git/tutorials/dotfiles).

## Installing

Install by running:

```bash
sudo curl -Lks https://raw.githubusercontent.com/Pigotz/.cfg/master/setup.sh | /bin/bash
```

The script will clone this repository as bare, placing it in `~/.cfg`.

It will be possible to interact with the cfg repo by using the `config` command from anywhere in the filesystem, passing arguments like you would do with any git repository.

The working directory will be set to your home directory and it will track only its relevant files.

In order to track new files, your will need to explicitly add them with `config add ~/path/to/file`.

