# Setup with Pulseaudio

1. Installation

```sh
sudo xbps-install -S spotify-player
```

2. Get client_id from [spotify](https://developer.spotify.com/)  

3. Set client_id in env var

```sh
echo 'export SPOTIFY_CLIENT_ID="<client_id>"' >> $HOME/.bash_env
```

4. Modify `$HOME/.config/spotify-player/app.toml"

```toml
# client_id = ""
client_id_command = "echo $SPOTIFY_CLIENT_ID"
```

5. Find output device to use

```sh
pactl list short sinks
```

6. Set it as default device

```sh
pactl set-default-sink <sink_name>
```

7. If device shows as suspended

```sh
paplay /usr/share/sounds/alsa/Front_Center.wav
```

8. Rerun the command to list devices, should now show as Idle

```sh
pactl list short sinks
```

9. Symlink/copy .asoundrc to $HOME/.asoundrc


## Common Issues

### Need to install missing alsa pulseaudio plugin

Issue:

```sh
spotify_player: ALSA lib dlmisc.c:339:(snd_dlobj_cache_get0) Cannot open shared library libasound_module_pcm_pulse.so (/usr/lib64/alsa-lib/libasound_module_pcm_pulse.so: cannot open shared object file: No such file or directory)
```

Fix:

```sh
sudo xbps-install -y alsa-plugins-pulseaudio
```
