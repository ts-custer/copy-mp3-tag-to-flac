#!/usr/bin/python3

"""
A script to copy all audio tags including embedded cover picture of a mp3 file to a flac file.

Requires library "mutagen" (https://github.com/quodlibet/mutagen) !

Usage: copy_mp3_tag_to_flac.py <source file> <target file>
"""
from argparse import ArgumentParser
from typing import Dict
import mutagen
import mutagen.flac
from datetime import date

frame_id_mapping: Dict[str, str] = {  # 'APIC': 'PICTURE', # Picture is copied, too, but in another way
    # 'COMM': 'DESCRIPTION', # Comment of the flac file will be set to current date
    'TCOM': 'COMPOSER',
    'TIT2': 'TITLE',
    'TRCK': 'TRACKNUMBER',
    'TALB': 'ALBUM',
    'TPE1': 'ARTIST',
    'TCON': 'GENRE',
    'TYER': 'DATE',
    'TDRC': 'DATE'}


def main():
    parser = ArgumentParser(description=__doc__)
    parser.add_argument('source_file',
                        type=str,
                        help='Name of the source audio file')
    parser.add_argument('target_file',
                        type=str,
                        help='Name of the target audio file')
    args = parser.parse_args()

    mp3_file = mutagen.File(args.source_file)
    # TODO Check if it's really a mp3 file and if it contains tags
    flac_file = mutagen.File(args.target_file)
    # TODO Check if it's really a flac file

    frame_id_to_mutagen_key = {mutagen_key[:4]: mutagen_key for mutagen_key in mp3_file.tags.keys()}
    for frame_id, mutagen_key in frame_id_to_mutagen_key.items():
        copy_frame(mp3_file, flac_file, frame_id, mutagen_key)
    copy_picture(mp3_file, flac_file)
    set_description(flac_file)
    flac_file.save()


def copy_frame(mp3_file, flac_file, frame_id, mutagen_key):
    field_name = frame_id_mapping.get(frame_id)
    if field_name:
        content = mp3_file.tags.get(mutagen_key) and mp3_file.tags.get(mutagen_key).text[0]
        if content:
            flac_file[field_name] = str(content)


def copy_picture(mp3_file: mutagen.File, flac_file: mutagen.File):
    apic_list = mp3_file.tags.getall('APIC')
    if apic_list:
        first_apic = apic_list[0]
        if first_apic:
            set_picture(flac_file, first_apic.type, first_apic.mime, first_apic.desc, first_apic.data)


def set_picture(flac_file: mutagen.File, type, mime, description, apic_picture_data):
    picture = mutagen.flac.Picture()
    picture.type = type
    picture.mime = mime
    picture.desc = description
    picture.data = apic_picture_data
    update_picture(flac_file, picture)


def update_picture(flac_file: mutagen.File, picture: mutagen.flac.Picture):
    flac_file.clear_pictures()
    flac_file.add_picture(picture)


def set_description(flac_file, comment: str = str(date.today())):
    flac_file['DESCRIPTION'] = comment


if __name__ == '__main__':
    main()
