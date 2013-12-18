RBname
=========

RBname is an interactive renaming tool

Installation
--
`gem install rbname`

Usage
--
`rbname`

The Idea
---
Renaming things (classes, methods, properties) is a snap in a language like Java.  In Ruby, however, I usually find myself grepping for occurrences of a pattern, and manually editing each file.  This takes a while.

Why not automate the process?

This tool lets you specify, via a regex, which lines you are interested in changing.  Then it watches how you change those lines, and makes suggestions about how to change other lines.
###Rename Example
Suppose that you encountered the line :

`db_conn = Connection.new`

And changed it to:

`db_conn = DatabaseConnection.new`

The tool would *later* suggest renaming this line:

`Connection.kill_all!`

to

`DatabaseConnection.kill_all!`

###VIDEO DEMO
https://vimeo.com/82157486


