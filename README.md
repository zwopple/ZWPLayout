# ZWPLayout

Cocoa Autolayout itself is awesome, the way a developer implements it well isn’t so awesome. ZWPLayout is a small set of utilities to make autolayout as simple as `c = m * x + b`.

Bear with us as we try to make this documentation as complete as possible.

## Goals

* Make autolayout code more readable
* Make autolayout code more concise
* Make autolayout code fun

## Implementation

ZWPLayout is just another string syntax that results in NSLayoutConstraints getting added into your views. Why another string syntax? Strings are the shortest possible way to implement complex layout code while keeping it readable, concise and fun. If you would rather a compile time check we recommend you check out the [Masonry](http://github.com/cloudkite/masonry) project as it uses method chaining to obtain compile time checks.

## Usage

ZWPLayout installs two API methods into UIView:

`- (ZWPLayoutViewConstraintsSet *)constrainToView:(UIView *)otherView formula:(NSString *)formula, …`
`- (ZWPLayoutViewConstraintsSet *)constrainWithFormula:(NSString *)formula, …`

`constrainToView:formula:` allows you to constrain the calling view to another view with the specified formula. In this situation the "left hand" will be `self` and the "right hand" will be the view passed in.

`constrainWithFormula:` allows you to constrain the calling view to itself. This is useful for constraints that are not reliant on another view, such as min/max dimensions.

Each method takes a formula which is a string constaint with format specifiers just like `stringWithFormat:` so you can easy put in constants.

Each method also returns a `ZWPLayoutViewConstraintsSet` which is keeps track of all the constraints that were added for that particular formula as well as the view in which the constraints were added to. `ZWPLayoutViewConstraintsSet` has a enabled property which allows you to enable or disable constraints based on a formula super quick.

## Usage / Examples

Writing forumla’s takes a little while to get into, though when in doubt it’s simply just c = mx + b. Formula’s thus should be `left-attribute = multiplier * right-attribute + constant@priority` where multiplier, constant and priority are optional. To specify more than one constraint in a single formula you simple separate them with commas.

These are all valid formula’s:

* `left = left`
* `left = left + 10`
* `left = left - 10`
* `left = left@749`

And so are these, a bit more complex:

* `left = left, top = top, right = right + 10, bottom = bottom`
* `left = centerX, top = 0.5 * height`

Here are some use cases and full examples:

|Use Case|Example|
|-----------------|-------|
|Resize to fill superview|[view constrainToView:view.superview, formula:@"left = left, top = top, right = right, height = height"]|
|Resize to fill superview with 10px inset|[view constrainToView:view.superview, formula:@"left = left + 10, top = top + 10, right = right - 10, height = height - 10"]|
|50% size of superview centered|[view constrainToView:view.superview, formula:@"width = 0.5 * width, height = 0.5 * height, centerX = centerX, centerY = centerY"]|

## Syntax

|Attributes|
|----------|
|width|
|height|
|left|
|top|
|right|
|bottom|
|centerX|
|centerY|
|leading|
|trailing|
|baseline|

|Relations|
|---------|
|=|
|>=|
|<=|

|Operators|
|---------|
|*|
|+|
|-|


## Installation

Add `pod 'ZWPLayout'` to your `Podfile` and then run `pod install`.

## License

The MIT License (MIT)

Copyright (c) 2013 Zwopple Limited

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.