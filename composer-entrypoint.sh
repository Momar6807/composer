#!/bin/sh

exec cls
set -e

exec composer "$1"
exec cls
