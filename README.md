# [bulma_sass](https://bulma.io)

[Bulma](https://bulma.io/) is a **modern SCSS framework** based on [Flexbox](https://developer.mozilla.org/en-US/docs/Web/CSS/CSS_Flexible_Box_Layout/Using_CSS_flexible_boxes).

## Example

You can find basic example usage of the package over at [bulma_sass_example](https://github.com/indiealexh/dart_bulma_sass_example)

## Usage

Add Sass and Builder runner to the project pubspec.yaml:

```yaml
dev_dependencies:
  build_runner: ^0.7.10+1
  sass_builder: ^1.1.2
```

Create a SCSS file and import bulma and edit any variable you need:

```scss
// 1. Import the initial variables
@import "package:bulma_sass/scss/utilities/initial-variables";
@import "package:bulma_sass/scss/utilities/functions";

// 2. Set your own initial variables
// Update blue
$blue: #72d0eb;
// Add pink and its invert
$pink: #ffb3b3;
$pink-invert: #fff;
// Add a serif family
$family-serif: "Merriweather", "Georgia", serif;

// 3. Set the derived variables
// Use the new pink as the primary color
$primary: $pink;
$primary-invert: $pink-invert;
// Use the existing orange as the danger color
$danger: $orange;
// Use the new serif family
$family-primary: $family-serif;

// 4. Setup your Custom Colors
$linkedin: #0077b5;
$linkedin-invert: findColorInvert($linkedin);
$twitter: #55acee;
$twitter-invert: findColorInvert($twitter);
$github: #333;
$github-invert: findColorInvert($github);

// 5. Add new color variables to the color map.
@import "package:bulma_sass/scss/utilities/derived-variables";
$addColors: (
  "twitter":($twitter, $twitter-invert),
  "linkedin": ($linkedin, $linkedin-invert),
  "github": ($github, $github-invert)
);
$colors: map-merge($colors, $addColors);

// 6. Import the rest of Bulma
@import "package:bulma_sass/scss/bulma";
```

Alternatively If you want to customize which bulma parts are included to minimize the end size of your css, you can use the below and simply uncomment the parts you want to include.

```scss
// Utilities
@import "package:bulma_sass/scss/utilities/initial-variables";
@import "package:bulma_sass/scss/utilities/functions";
@import "package:bulma_sass/scss/utilities/derived-variables";
@import "package:bulma_sass/scss/utilities/animations";
@import "package:bulma_sass/scss/utilities/mixins";
@import "package:bulma_sass/scss/utilities/controls";
// Custom Variables

// Base
@import "package:bulma_sass/scss/base/minireset";
@import "package:bulma_sass/scss/base/generic";
@import "package:bulma_sass/scss/base/helpers";
// Elements
// @import "package:bulma_sass/scss/elements/box";
// @import "package:bulma_sass/scss/elements/button";
// @import "package:bulma_sass/scss/elements/container";
// @import "package:bulma_sass/scss/elements/content";
// @import "package:bulma_sass/scss/elements/form";
// @import "package:bulma_sass/scss/elements/icon";
// @import "package:bulma_sass/scss/elements/image";
// @import "package:bulma_sass/scss/elements/notification";
// @import "package:bulma_sass/scss/elements/progress";
// @import "package:bulma_sass/scss/elements/table";
// @import "package:bulma_sass/scss/elements/tag";
// @import "package:bulma_sass/scss/elements/title";
// @import "package:bulma_sass/scss/elements/other";
// Components
// @import "package:bulma_sass/scss/components/breadcrumb";
// @import "package:bulma_sass/scss/components/card";
// @import "package:bulma_sass/scss/components/dropdown";
// @import "package:bulma_sass/scss/components/level";
// @import "package:bulma_sass/scss/components/media";
// @import "package:bulma_sass/scss/components/menu";
// @import "package:bulma_sass/scss/components/message";
// @import "package:bulma_sass/scss/components/modal";
// @import "package:bulma_sass/scss/components/navbar";
// @import "package:bulma_sass/scss/components/pagination";
// @import "package:bulma_sass/scss/components/panel";
// @import "package:bulma_sass/scss/components/tabs";
// Grid
@import "package:bulma_sass/scss/grid/columns";
// @import "package:bulma_sass/scss/grid/tiles";
// Layout
// @import "package:bulma_sass/scss/layout/hero";
// @import "package:bulma_sass/scss/layout/section";
// @import "package:bulma_sass/scss/layout/footer";

// Custom SCSS

```

## Documentation

Documentation for the Bulma framework can be found here [Bulma Documentation](https://bulma.io/documentation)

## Bugs and Features

Report problems with this package to [https://github.com/indiealexh/dart_bulma_sass](https://github.com/indiealexh/dart_bulma_sass)

Report problems with the core framework to [https://github.com/jgthms/bulma](https://github.com/jgthms/bulma)

## Copyright and license

Dart package is released under MIT license.

Original Code copyright 2017 Jeremy Thomas and released under [the MIT license](https://github.com/jgthms/bulma/blob/master/LICENSE).
