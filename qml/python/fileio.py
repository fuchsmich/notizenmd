#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
import pyotherside
#import locale


def read(path):
    #pyotherside.send('log', locale.getpreferredencoding(False))
    try:
        with open(path, 'r', 'utf-8') as f:
            read_data = f.read()
            pyotherside.send('log', "read file {0}".format(path))
            return read_data
    except IOError:
        pyotherside.send('ioerror', "{0} file not readable".format(path))
        if not os.path.exists(os.path.dirname(path)):
            pyotherside.send('ioerror', "{0} dir does not exist"
                             .format(os.path.dirname(path)))
        elif not os.path.isfile(path):
            pyotherside.send('ioerror', "{0} file does not exist".format(path))
        return ""


def write(path, content):
    try:
        with open(path, 'w', 'utf-8') as f:
            f.write(content)
            pyotherside.send('log', "content saved")
    except IOError:
        pyotherside.send('ioerror', "{0} file not writeable".format(path))
        if not os.path.exists(os.path.dirname(path)):
            pyotherside.send('ioerror', "{0} dir does not exist"
                             .format(os.path.dirname(path)))
            if not os.path.isfile(path):
                pyotherside.send('ioerror',
                                 "{0} file does not exist".format(path))


def create(path):
    try:
        with open(path, 'w+'):
            pyotherside.send('log', "file {0} created.".format(path))
    except IOError:
        pyotherside.send('ioerror', "{0} file not writeable".format(path))
        if not os.path.exists(os.path.dirname(path)):
            pyotherside.send('ioerror', "{0} dir does not exist"
                             .format(os.path.dirname(path)))
