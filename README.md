# article-reader

Extracts articles from html pages.

## Introduction

The module is still in an early version. It tries to find the smallest tag
containing the whole article. It works well with html pages whose structure
is similar to:
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
or
```html
<html>
...
    <body>
    ...
        <article>
        ...
        </article>
    </body>
</html>
```
It breaks if there are `<p>` tags containing enough text outside the main
article.

## Usage

The module is called `Parser` and contains some (poorly) documented methods.
If you want a one-liner call the `main` function:
```ruby
require './find-article.rb'

html_file = <The name of the .html file>
node = Parser.main html_file # => Nokogiri::XML::Node
```

## TODO

* Be more selective with `<p>` tags.
* Produce a well formatted html page containing the article.

