engineering.ulule.com
=====================

Installation
------------

Install a python 3.x environment

::

    brew install python3 pyenv
    pyenv install 3.6.1

Insert pyenv in your ``$PATH``

::

    export PATH=~/.pyenv/shims:/usr/local/bin:/usr/bin:/bin:$PATH

Switch your local environment to ``3.6.1``

::

    pyenv local 3.6.1

Install the virtualenv

::

    pip install virtualenv
    virtualenv .env
    source .env/bin/activate

Install dependencies

::

    $ make dependencies

Configuration
-------------

The configuration file can be found in  `pelicanconf.py`.

Write an article
----------------

Write your article in `content/`, both markdown and reStructuredText are allowed.

When you write an article be sure to pass down at least these parameters:

Date syntax

::

  * Markdown: Date: YYYY-MM-DD
  * RST: :date: YYYY-MM-DD

Author syntax

::

  * Markdown: Author: John Doe Deer
  * RST: :author: John Doe Deer

Optional
........

If you want to add an url for your avatar just add a syntax with
``avatar`` (like the previous ones) with the url.

Preview an article
------------------

Once you wrote your article and you're happy about it then run:

::

    make build

It will output the generated content of your article inside `output/` directory.

Now you want to preview it, go inside `output` folder and run:

::

    make serve

Then you can open your `http://localhost:8000 <http://localhost:8000>`_ and preview your article.
