# article-reader

Extracts articles from html pages.

## Introduction

The module is still in an early version. It tries to find the smallest tag
containing the whole article. It works well with html pages with a structure
similar to:
```html
<html>
...
    <body>
    ...
        <div class="some_class">
            <p> Article paragraph </p>
            <p> Another paragraph </p>
            ...
        </div>
    </body>
</html>
```
It breaks if there are `<p>` tags outside the main article, but I plan to
fix that in the future.

## Usage

The module is called `Parser` and contains some (poorly) documented methods.
If you want a one-liner call the `main` function:
```ruby
require './find-article.rb'

html_file = <The name of the .html file>
Parser.main html_file
```

## TODO

* Be more selective with `<p>` tags.
* Produce a well formatted html page containing the article

