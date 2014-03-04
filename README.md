resize-brunch
=============

Automatically resizes images.

Usage
=====

### Configuration Options
```coffeescript
exports.config =
  plugins:
    resize:
      "app/assets/images/originals":
        height: 64
        width: 64
        dest: "images/thumbnails_64px"
```

#### Multiple option sets
```coffeescript
exports.config =
  plugins:
    resize:
      "app/assets/images/originals": [
        height: 64
        width: 64
        dest: "images/thumbnails_64px"
      ,
        height: 32
        width: 32
        dest: "images/thumbnails_32px"
      ]
```
