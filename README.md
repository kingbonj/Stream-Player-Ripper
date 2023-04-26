# Stream-Player-Ripper
A Bash script that allows you to play and record multiple audio streams using the mplayer and streamripper tools.

![Screenshot 2023-04-26 22 13 24](https://user-images.githubusercontent.com/38471159/234704155-5d25f107-8c74-450e-9663-5b1ef37342cf.png)

## Prerequisites
Before using this script, you must have the following tools installed on your system:

```
mplayer
streamripper
```

## Usage

To use this script, simply run the following command:

`./streamplayer.sh [urls.txt]`

Replace `[urls.txt]` with the path to a file containing the URLs of the audio streams you wish to play and record. If you omit this argument, the script will look for a file called `urls.txt` in the current directory.

When the script is running, it will save recordings of the currently playing audio stream to folder `streamripper` in the same directory as the script. Each recording will be saved in a subfolder named after the date and time the recording started, in the format YYYY-MM-DD_HH-MM-SS. 

The file format of the rips will depend on the audio stream being recorded.


Once the script is running, you can use the following keys to control playback:

`.` : advance to the next audio stream and start playing it.

`,` : go back to the previous audio stream and start playing it.

`r` : toggle recording of the current audio stream using streamripper.

`q` : stop playing and recording, and exit the script.

When you're finished using the script, press `q` to exit. The script will automatically stop playing and recording and clean up any temporary files.






