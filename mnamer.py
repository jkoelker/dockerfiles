#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import os
import sys

import guessit

video_exts = ['3g2', '3gp', '3gp2', 'asf', 'avi', 'divx', 'flv', 'm4v', 'mk2',
              'mka', 'mkv', 'mov', 'mp4', 'mp4a', 'mpeg', 'mpg', 'ogg', 'ogm',
              'ogv', 'qt', 'ra', 'ram', 'rm', 'ts', 'wav', 'webm', 'wma',
              'wmv', 'iso', 'vob', 'm2ts']


def handle(dirpath, filename, dstpath):
    if 'sample' in filename.lower():
        return

    path = os.path.join(dirpath, filename)
    ext = os.path.splitext(path)[-1].lstrip('.')

    if ext not in video_exts:
        return

    print('Processing %s' % path)
    guess = guessit.guessit(path)

    name = '%s (%s)' % (guess['title'], guess['year'])

    if 'source' not in guess and 'remux' in filename.lower():
        guess['source'] = 'bluray'

    if 'source' in guess:
        guess['source'] = guess['source'].lower().replace('-', '')

    if 'source' in guess:
        name = '%s %s' % (name, guess['source'].lower())

    dst = os.path.join(dstpath, name)
    os.makedirs(dst)
    os.link(path, os.path.join(dst, '.'.join([name, ext])))


def main():
    description = 'Manage incoming movies'
    parser = argparse.ArgumentParser(description=description)

    parser.add_argument('src',
                        help='source directory to walk',
                        metavar='SOURCE')
    parser.add_argument('dst',
                        help='destinatin directory link to',
                        metavar='DESTINATION')

    args = parser.parse_args()

    for dirpath, dirnames, filenames in os.walk(args.src):
        for filename in filenames:
            handle(dirpath, filename, args.dst)

    return 0


if __name__ == '__main__':
    sys.exit(main())
