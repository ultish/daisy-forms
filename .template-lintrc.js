'use strict';

module.exports = {
  extends: 'recommended',
  rules: {
    'require-input-label': false,

    'no-forbidden-elements': ['meta', 'html', 'script'], // Allow usage of `style`
  },
};
