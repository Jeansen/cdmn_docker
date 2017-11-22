#!/usr/bin/env bash

/usr/sbin/sshd -D &
xrdb -load /Xresources
urxvt -pe cdmn

