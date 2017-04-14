engineering.ulule.com
=====================

A repository with our latest tech blog posts:

* `Introduction to picfit, an image resizing server written in Go <https://github.com/ulule/engineering.ulule.com/blob/master/0001-introduction-to-picfit.rst>`_
* `Introducing deepcopier, a Go library to make copying of structs a bit easier <https://github.com/ulule/engineering.ulule.com/blob/master/0002-introducing-deepcopier.rst>`_


Engineering Static Blog Generator Installation
==============================================
You have to do use the CLI :

    $ pip install pelican markdown

# Configuration

All the configuration is based on the file `pelicanconf.py`.


# Article

Write your article in `content/`. (Markdown and RST are allowed)
When you write an article be sure to pass down at least these two parameters :

1. Date syntax :
  * Markdown: Date: YYYY-MM-DD
  * RST: `:date:` YYYY-MM-DD

2. Author syntax :
  * Markdown: Author: John Doe Deer
  * RST: :author: John Doe Deer

*optional*
*if you want to add an url for your avatar just add a syntax with "avatar" (like the previous ones) with the url.*

# Preview

Once you wrote your article and you're happy about it then to the `engineering` folder and do :

    $ pelican content/

It'll output the content of your content of your article inside `output/`.

Now you want to preview it, go inside `output` folder and do :

    $ python -m pelican.server

Then you can open your localhost:8000 and preview your article.


Here is a sample of Markdown file :

```
Title: ReadMe Tho
Date: 2010-12-03 10:20
Author: John Doe Deer

# Is da me the article

I'm a  inline `code` syntax

```

Here is a sample of RST file (the first line here will the title of the article) :


```
Let me introduce your to RST template
=====================================

:date: 2017-04-13
:author: John Deer Doe

Article-H2
----------

This is a readme.
```