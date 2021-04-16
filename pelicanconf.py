#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

import time

VERSIONING = int(time.time())

# Basic config
AUTHOR = u'Florent Messa'
SITENAME = u'Ulule'
SITEURL = ''
PATH = 'content'
TIMEZONE = 'Europe/Paris'

# Define theme and static path to img folder
THEME = 'themes/ulule'
STATIC_PATHS = [
    'img/',
    'themes/ulule/static/build/',
]

DEFAULT_DATE_FORMAT = '%d %B %Y'

# Remove all unwanted files
AUTHORS_SAVE_AS = ''
CATEGORIES_SAVE_AS = ''
TAGS_SAVE_AS = ''
ARCHIVES_SAVE_AS = ''
FEEDS_SAVE_AS = ''
AUTHOR_SAVE_AS = ''
THEME_SAVE_AS = ''
CATEGORY_SAVE_AS = ''
FEED_DOMAIN = ''
FEED_ATOM = ''
FEED_RSS = ''
FEED_ALL_ATOM = ''
FEED_ALL_RSS = ''
CATEGORY_FEED_ATOM = ''
CATEGORY_FEED_RSS = ''
AUTHOR_FEED_ATOM = ''
AUTHOR_FEED_RSS = ''
TAG_FEED_ATOM = ''
TAG_FEED_RSS = ''

DEFAULT_LANG = u'en'

# Social links
SOCIAL_LINKS = (
    ('twitter', 'https://twitter.com/ulule'),
    ('github', 'https://github.com/ulule'),
    ('facebook', 'https://facebook.com/ulule'),
)

# BASE_URL = 'http://ulule.engineering'
