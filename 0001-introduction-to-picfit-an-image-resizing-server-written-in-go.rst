Introduction to picfit, an image resizing server written in Go
==============================================================

The motivation
--------------

The idea behind picfit_ came from the need of exporting image processing
(resize, thumbnail, etc.) to an independent web service which will be
able to manage my files no matter the storage
engine used (s3, file system, etc.).

When you are dealing with resizing on demand, you have to store keys of
generated images to a data storage to avoid generating the same image twice.
With a unique interface, picfit allows you to use or
implement your favorite data storage.

At `ulule.com <http://www.ulule.com>`_, picfit_ allows us to remove
a large amount of code for avatars and project images processing and
avoid synchronous calls to retrieve generated images, which can have
an impact on your application performance.


Why using Go lang over <insert another cool language here>?
-----------------------------------------------------------

Go language has been chosen because it allows to generate a binary file
and make deployments easier, have better concurrency mechanism
(I'm looking at you GIL) with a simple language.
Another advantage for Go was the large number of developers
were excited about it.

There are plenty of great articles on why you should use Go
and why you should avoid it ☺

Installation
------------

The best way to use picfit_ locally for testing it, before any
installation on a real server, is to use Vagrant_ with a virtual machine.

1. First, make sure you have installed Vagrant_ and VirtualBox_

2. Clone the picfit_ repository ::

    $ git clone https://github.com/thoas/picfit

3. Install Ansible_ to use provisioning files from the picfit repository,
   depending your OS, it can be done like so:

::

    $ pip install ansible


4. Start the virtual machine, Vagrant will run provisioning automatically,
   it can be long so grab a coffee or a tea ☺

::

    $ vagrant up


On the virtual machine, picfit_ runs on port **8080** behind Varnish
on port **80**.

In the Vagrantfile_, the port **80** is forwarded on the virtual machine
to the port **8080** on your machine, picfit_ will be available using HTTP:

::

    http://127.0.0.1:8080

Usage
-----

To call the service you should provide the following parameters:

::

    http://localhost:3001/{method}?url={url}&path={path}&w={width}&h={height}&upscale={upscale}&sig={sig}&op={operation}&fmt={format}


* path — The filepath to load the image using your source
  storage (optional, if you haven’t configured a source storage)
* method — The operation to perform: **display**, **redirect** or **get**
* sig - The signature key which is the representation of your query string
  and your secret key (optional, if you haven’t configured a secret key)
* url — The url of the image which will be retrieved by HTTP (optional, if path is provided)
* width — The desired width of the image,
  if 0 is provided the service will calculate the ratio with **height**
* height — The desired height of the image,
  if 0 is provided the service will calculate the ratio with **width**
* upscale — If your image is smaller than your desired dimensions,
  the service will upscale it by default to fit your dimensions,
  you can disable this behavior by providing 0 (optional)
* format — The output format to save the image, by default the format
  will be the source format, for example a GIF image
  source will be saved as GIF (optional)

Basic examples
--------------

Let’s take as a basic experiment, a logo that everyone knows well.

.. image:: https://cdn-images-1.medium.com/max/1600/1*V-OWuu3-GgNFkDOQgrmrzg.png

::

    http://www.google.fr/images/srpr/logo11w.png (538x190)

1. Resize the image to **200 width** and calculate the **height** ratio

.. image:: https://cdn-images-1.medium.com/max/1600/1*9RKGTfQCXyWB6RVyjc1zlg.png

::

    http://localhost:8080/display?url=http://www.google.fr/images/srpr/logo11w.png&w=200&h=0&op=resize

2. Resize the image to **200 width** and **100 height**

.. image:: https://cdn-images-1.medium.com/max/1600/1*ufchoQbRFdg4tczAS6lGRA.png

::

    http://localhost:8080/display?url=http://www.google.fr/images/srpr/logo11w.png&w=200&h=100&op=resize

3. Thumbnail the image to **300 width** and **50 height**, it will perform a crop operation from the center of it

.. image:: https://cdn-images-1.medium.com/max/1600/1*pIvIQj0nd90qCjKnd87gVg.png

::

    http://localhost:8080/display?url=http://www.google.fr/images/srpr/logo11w.png&w=300&h=50&op=thumbnail

4. Resize the image to **600 width** and calculate the ratio to find the perfect height, the image will be degraded

.. image:: https://cdn-images-1.medium.com/max/1600/1*B_smig-gRy4HZ-fmJETLkg.png

::

    http://localhost:8080/display?url=http://www.google.fr/images/srpr/logo11w.png&w=600&h=0&op=resize

If you want picfit_ to not upscale the image to the specific size
(in case when your size is higher than the original image size),
you can disable the upscale behavior.

.. image:: https://cdn-images-1.medium.com/max/1600/1*phQamw5IO1eV7345KIw1Sg.png

::

    http://localhost:8080/display?url=http://www.google.fr/images/srpr/logo11w.png&w=600&h=0&op=resize&upscale=0


Configuring a source storage
----------------------------

Now we know picfit can retrieve an image from any URL using HTTP, we will
configure an Amazon S3 storage to retrieve our uploaded images and
store generated images to a different Amazon S3 storage.

We will call our source Amazon S3 bucket **source-bucket** located a datacenter
in europe and our destination Amazon S3 bucket **dest-bucket**
located to another datacenter in USA.

Provisioning files from the picfit repository comes with an installation
of Redis as a key/value store on the 6380 port.

The key/value store will be needed when you want to avoid to generate
a resized image twice. For each request picfit will generate an unique key
to identify the operation made and store the result on the key/value store.

1. Edit the **config.json** of picfit located to **/etc/picfit**

.. code-block:: json

    {
      "kvstore": {
        "type": "redis",
        "host": "127.0.0.1",
        "port": "6380",
        "password": "",
        "prefix": "picfit:",
        "db": 0
      },
      "port": 8080,
      "storage": {
        "src": {
          "type": "s3",
          "access_key_id": "[ACCESS_KEY_ID]",
          "secret_access_key": "[SECRET_ACCESS_KEY]",
          "bucket_name": "source-bucket",
          "acl": "public-read",
          "region": "eu-west-1",
          "location": ""
        },
        "dst": {
          "type": "s3",
          "access_key_id": "[ACCESS_KEY_ID]",
          "secret_access_key": "[SECRET_ACCESS_KEY]",
          "bucket_name": "dest-bucket",
          "acl": "public-read-write",
          "region": "us-west-1",
          "location": "cache"
        }
      }
    }

Generated images will be stored on the destination storage in the **cache** location.
Our source storage (which is an Amazon S3 bucket) contains our logo
stored at the location **images/srpr/logo11w.png**.

By default, if you don’t specify a destination storage, picfit_
will store generated images to the source storage.

2. Restart the picfit service

::

    $ sudo service picfit restart

picfit implements the `facebook/grace <https://github.com/facebookgo/grace>`_ which
allows you to restart it gracefully

::

    $ sudo kill -USR2 $(cat /var/run/picfit.pid)

We are ready! Let’s convert our previous examples using the source storage.

1. Resize the image to **200 width** and calculate the **height** ratio

.. image:: https://cdn-images-1.medium.com/max/1600/1*9RKGTfQCXyWB6RVyjc1zlg.png

::

    http://localhost:8080/display/resize/200x/images/srpr/logo11w.png

2. Resize the image to **200 width** and **100 height**

.. image:: https://cdn-images-1.medium.com/max/1600/1*ufchoQbRFdg4tczAS6lGRA.png

::

    http://localhost:8080/display/resize/200x100/images/srpr/logo11w.png

3. Thumbnail the image to **300 width** and **50 height**

.. image:: https://cdn-images-1.medium.com/max/1600/1*pIvIQj0nd90qCjKnd87gVg.png

::

    http://localhost:8080/display/thumbnail/300x50/images/srpr/logo11w.png

4. Resize the image to **600 width** and disable upscale

.. image:: https://cdn-images-1.medium.com/max/1600/1*phQamw5IO1eV7345KIw1Sg.png

::

    http://localhost:8080/display/resize/600x/images/srpr/logo11w.png?upscale=0

Conclusion
----------

It has been a long introduction, if you have reach to the bottom
you belong to the brave ☺.

There are multiple others features (`Security <https://github.com/thoas/picfit#security>`_, `Sentry integration <https://github.com/thoas/picfit#error-reporting>`_, `others methods <https://github.com/thoas/picfit#methods>`_, etc.)
which are not described in this blog post, if you are curious enough
go check the README_ of the project.


Contributing to picfit
----------------------

* Ping me on twitter `@thoas <http://twitter.com/thoas>`_
* Fork the `project <https://github.com/thoas/picfit>`_
* Fix `bugs <https://github.com/thoas/picfit/issues>`_
* Add more unit tests

Don’t hesitate ☺!


.. _picfit: https://github.com/thoas/picfit
.. _Ulule: https://www.ulule.com
.. _Vagrant: https://www.vagrantup.com/
.. _VirtualBox: https://www.virtualbox.org
.. _Ansible: http://www.ansible.com/
.. _Vagrantfile: https://github.com/thoas/picfit/blob/master/Vagrantfile#L23
.. _README: https://github.com/thoas/picfit/blob/master/README.rst
