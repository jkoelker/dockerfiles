#!/usr/bin/env python3
# -*- coding: utf-8 -*-

import argparse
import os
import sys

import guessit
from guessit.patterns import extension as ext_patterns


def handle(dirpath, filename, dstpath):
    if 'sample' in filename.lower():
        return

    path = os.path.join(dirpath, filename)
    ext = os.path.splitext(path)[-1].lstrip('.')

    if ext not in ext_patterns.video_exts + ['m2ts']:
        return

    print('Processing %s' % path)
    guess = guessit.guess_movie_info(path, info=['filename', 'video'])
    guess['title'] = guess['title'].title()

    name = '%s (%s)' % (guess['title'], guess['year'])

    if 'format' not in guess and 'remux' in filename.lower():
        guess['format'] = 'bluray'

    if 'format' in guess:
        name = '%s %s' % (name, guess['format'].lower())

    name = name.encode('utf-8')
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
