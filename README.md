# pyship
pyship creates a python 2.7 binary that can be bundled with python scripts.  This gives
python scripts a native application feel.  Other attempts at creating a similar effect include
programs like py2exe and cx_Freeze.

Curretly only OSX is supported.

## pre-requisites
0. Install ActiveState Tcl/Tk 8.5
1. Install Xcode SDK
2. ```sudo ln -s /usr/bin/clang /usr/bin/cc```
3. ```sudo ln -s /usr/local/bin/hg /usr/bin/hg```
4. ```sudo ln -s /Library/Frameworks/Tk.framework/ $(xcrun --show-sdk-path)/Library/Frameworks/```
5. ```sudo ln -s /Library/Frameworks/Tcl.framework/ $(xcrun --show-sdk-path)/Library/Frameworks/```

## creating a binary
0. ```git clone https://github.com/burrows-labs/pyship.git```
1. ```cd pyship```
2. ```./main.sh 10.10```

## invoking the python shell
```
$ ./build/pyship/python2.7/usr/local/bin/python
Python 2.7.11+ (default, Mar 19 2016, 18:11:56) 
[GCC 4.2.1 Compatible Apple LLVM 7.0.2 (clang-700.1.81)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import _ssl # ssl works!
>>> print "Hello World"
Hello World
>>> exit()
```

## setting up a virtualenv
```
$ ./build/pyship/python2.7/usr/local/bin/python ./build/pyship/virtualenv/virtualenv.py abc
New python executable in /Users/burr0ws/code/pyship/abc/bin/python
Installing setuptools, pip, wheel...done.
$ ./abc/bin/pip install requests
Collecting requests
  Using cached requests-2.9.1-py2.py3-none-any.whl
Installing collected packages: requests
Successfully installed requests-2.9.1
Box:pyship burr0ws$ ./abc/bin/python
Python 2.7.11+ (default, Mar 19 2016, 18:11:56) 
[GCC 4.2.1 Compatible Apple LLVM 7.0.2 (clang-700.1.81)] on darwin
Type "help", "copyright", "credits" or "license" for more information.
>>> import requests
>>> r = requests.get('http://google.com')
>>> r.text
u'<!doctype html><html itemscope="" itemtype="http://schema.org/WebPage" lang="en"><head><meta
content="Search the world\'s information, including webpages, images, videos and more. Google
has many special features to help you find exactly what you\'re looking for." name="description">...
>>> exit()
```

## dependencies?
```
$ find build/pyship/python2.7/ | xargs otool -L 2>/dev/null | \
  grep -Ev "(is not an object file|Invalid argument|build/pyship)" | \
  awk '{$1=$1};1' | awk '{print $1}' | sort | uniq
/Library/Frameworks/Tcl.framework/Versions/8.5/Tcl
/Library/Frameworks/Tk.framework/Versions/8.5/Tk
/System/Library/Frameworks/ApplicationServices.framework/Versions/A/ApplicationServices
/System/Library/Frameworks/Carbon.framework/Versions/A/Carbon
/System/Library/Frameworks/CoreFoundation.framework/Versions/A/CoreFoundation
/System/Library/Frameworks/CoreGraphics.framework/Versions/A/CoreGraphics
/System/Library/Frameworks/CoreServices.framework/Versions/A/CoreServices
/System/Library/Frameworks/SystemConfiguration.framework/Versions/A/SystemConfiguration
/usr/lib/libSystem.B.dylib
/usr/lib/libbz2.1.0.dylib
/usr/lib/libedit.3.dylib
/usr/lib/libz.1.dylib
```
