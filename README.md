# Copy mp3 tag to flac

## Python script `copy_mp3_tag_to_flac.py`

The Python script `copy_mp3_tag_to_flac.py` copies the tag of a .mp3 file to a .flac file
* It takes two arguments: The source (.mp3) file and the target (.flac) file, e.g.
```
$ copy_mp3_tag_to_flac.py  myOldLowQuality.mp3  myNewLosslessQuality.flac
```

#### Prerequisites
* Python 3.6 or above
* Installed "mutagen" library (https://github.com/quodlibet/mutagen)


## Bash script `copy_audio_tags.sh`

The Bash script `copy_audio_tags.sh` copies the mp3 tags of *all* files of one directory to *all* flac files of another directory!
* It calls/uses `copy_mp3_tag_to_flac.py`

#### Usage

On your console you must be in the directory that contains the .flac files which audio tags are to be updated. Maybe you must first navigate into it:
```
$ cd <directory_with_flac_files>`
```
Then you can execute the script with:
```
$ copy_audio_tags.sh <source_directory> [-t]
```
The source directory is the directory with the .mp3 files which audio tags are to be copied.

You can set option `-t` to execute the script in test mode - then it will only do some printouts but will not save anything.

