PICBOX V2.1.1 README
===================
(c) Ben Kay 2010

Based on Slimbox 1.7
(c) Christophe Beyls 2007-2009 <http://www.digitalia.be>

Included files:

example.html		A simple example page demonstrating how to use Picbox with the default configuration.
example.jpg		An example image used on the example page.
README.txt		The file you are reading.
css/*			The Picbox stylesheet and its associated images. You can edit them to customize Picbox appearance.
js/picbox.js		The minified version of Picbox, plus the editable autoloading code using default options.
src/picbox.js		The Picbox source. Contains many comments and is not suitable for production use (needs to be minified first).
extra/*			Some extra scripts that you can add to the autoload code block inside picbox.js to add special functionality.

Installation:

For easy installation, upload the css/ and js/ folders to your server,
then copy the following code into your <head>:

<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.4/jquery.min.js"></script>
<script src="js/picbox.js" type="text/javascript"></script>
<link rel="stylesheet" href="css/picbox.css" type="text/css" media="screen" />

You can use the provided and picbox.js script "as is", or edit the autoloading code inside picbox.js.

When deploying picbox.js, you MUST always preserve the copyright notice at the beginning of the file.

If you are a developer and want to edit the provided Picbox source code, it is strongly recommended to minify the script using the 'YUI Compressor'
or 'Google Closure' before distribution. It will strip spaces and comments and shrink the variable names in order to obtain the smallest file size.

For more information, please read the documentation on the official project page. (http://bunnyfire.co.uk/projects/picbox/)


Enjoy!