### Lumumba Mobile - Cocoa Touch best practice extensions

Lumumba Mobile (lumobile) is a set of toolkit classes
that have helped my developing several iOS applications.

It's far from being a complete framework, but you may use any of it's code at your will.

# Installation #

I'm working on an easier way, but for now you have to clone the repository and create references to the files you want manually.

1. Open a terminal and navigate to the project, 
   where you want to add the lumobile library

2. add as a submodule from github

  ```sh
  git submodules add https://github.com/Tharabas/lumobile.git libs/lumobile
  ```
  where the ``libs/lumobile`` is just the path you want to put the library

3. include the project in XCode

  Add the files, you put under ``lib/lumobile`` to your project

4. Include the lumobile.h where you want to use it

  The most comfortable way would be to put it into your ``Prefix.pch``, wich is usually located under __Supporting Files__ in your XCode working tree.

  ```objc
  // for the framework
  #import "lumobile.h"
  // for cocos2d extensions
  #import "lumobile-cocos2d.h"
  ```

# Categories #

Most of the used categories will look like ``UIOriginalFile+TH`` as they are in the __TH__arabas namespace.

## NSString ## ##

``TODO: write a bit more``

## NSArray ## ##

### reversed ###

Returns the reversed version of the NSArray

### map ###

Returns a new ``NSArray`` performing a block on every item of the ``NSArray``.

As an ``NSArray`` can not contain any ``nil`` value, returning ``nil`` will drop that value from the resulting ``NSArray``.

### filter ###

Returns a subset of the original ``NSArray`` that contains all elements, where the call of the block returned ``YES``.

> In some cases you might be forced to coerce the return value to `(BOOL)` as the compiler would not accept it otherwise.

``TODO: write a bit more``

## NSDictionary ##

``TODO: write a bit more``

## UIColor ##

Especially the color classes needed an easy access point.
The ``THWebNamedColors`` caches a map of named colors with the default web names (css) of the colors.
Thus you can grab an NSColor with the value of __skyblue__ via ``[NSColor colorWithName:@"skyblue"]``

A more generic parser version of this is ``[NSColor colorFromString:colorString]`` wich tries to parse
any string into a NSColor.

That string2color parser allows even more stuff, like blending colors:

50% white, 50% blue -> ``[UIColor colorFromString:@"white <> blue"]`` (see UIColor+TH for more details on this)

It even defines a (readonly) property __colorValue__ on a NSString, allowing you to use this:

```objc
NSColor *magenta   = @"magenta".colorValue;
NSColor *pinkGlass = @"pink".colorValue.translucent;
```

As well as another (readonly) property __colorValues__ on NSArray

```objc
NSArray *colors = @[[NSColor blackColor], 
                    [NSColor colorNamed:@"pink"],
                    [NSColor colorNamed:@"gold"]
                  ];
// or simply
NSArray *colors = @"black pink gold".words.colorValues;
```

# Some Objective-C Sugar

Lots and lots of times, you usually need to format NSStrings.
Each time with `` [NSString stringWithFormat:format, arg1, arg2, arg3, ...] ``

This can be shortened to `` $(format, arg1, arg2, arg3, ...) `` using the ``$`` macro.

As well as `` [NSArray arrayWithObjects:o1, o2, o3, ..., nil] ``

May be written as `` $array(o1,o2,o3) ``

__Note:__ As with **clang 4.1** the ``$array(...)`` and ``$map(...)`` features are __deprecated__ as you can use the ``@[...]`` and ``@{...}`` compiler features. That's even more awesome and just fixes the need for my macros.

There are other _preprocessor macros_ that do similar things.

## A thin layer for geometric calculus

Look for ``THPoint``, ``THSize``, ``THRect`` in the sources.

_... more details on that later ..._

# Extensions

## cocos2d

I've worked with Cocos2d (great Framework for 2d stuff) but found some nuisance, that have been __corrected__ my way by creating categories for them.
You may find those under ``/extensions/cocos2d``.

# DISCLAIMER

All those components, snippets and code fragments have been created,
because I either used them very often and thought, there should be
an easier way to do this, or because I simply did not know that there
is another way to do this in Objective-C.

I do neither claim all things to be flawless nor perfect to fit _your_ Apps.

I'm absolutely aware, that _preprocessor macros_ may be considered evil,
as they obscure code. That may be right, but they can also be used to considerably
_clean up the code_, what would be desired behaviour.

Anyway they are a feature of the c environment.

You may use it or you may leave it. Still your decision.

Constructive comments are welcome, anytime, though.