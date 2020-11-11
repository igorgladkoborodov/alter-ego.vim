# alter-ego.vim

Jump between alternate files: test, styles, stories etc. Similar to `a.vim`, but works with multiple alternate file types.


Let's say you have a following structure:
```
src
└── components
    ├── __styles__
    │   ├── ComponentName.css
    │   └── ...
    ├── __tests__
    │   ├── __snapshots__
    │   │   ├── ComponentName.test.tsx.snap
    │   │   └── ...
    │   ├── ComponentName.test.tsx
    │   └── ...
    ├── ComponentName.tsx
    └── ...
```

With this plugin you can jump between all of these files in any order.

* `:A test` -- jump to test
* `:A styles` -- jump to styles
* `:A origin` or `:A` -- jump back to original file

You can configure it for different file structure.

It can also work if you the codebase is not very consistent. For example, if you jump to test file for `.tsx` file, it will find existing test if it ends with `.js` or `.tsx` instead of default `.test.tsx`. If existing alternate file is not found, it will create a new buffer with correct file name.

You can add different combination of alternate files. For example: types, resolvers, input types and payload types if you work on for GraphQL server; related controllers, models, views and tests for Ruby on Rails.

## Configuration

*Note: This config format is not final.*

Files patterns could be configured in `g:alterEgoFileTypes` variable:
```
let g:alterEgoFileTypes = [
\ {
\   'type': 'snapshot',
\   'match': [
\     ['\(.*\)\/__tests__\/__snapshots__\/\(.*\)\.test\.\([jt]sx\?\)', 1, 2],
\     ['\(.*\)\/__tests__\/__snapshots__\/\(.*\)\.\([jt]sx\?\)', 1, 2],
\   ],
\   'dir': ['$dir/__tests__/__snapshots__'],
\ },
\ {
\   'type': 'test',
\   'match': [
\     ['\(.*\)\/__tests__\/\(.*\)\.test\.\([jt]sx\?\)', 1, 2],
\     ['\(.*\)\/__tests__\/\(.*\)\.\([jt]sx\?\)', 1, 2],
\   ],
\   'dir': ['$dir/__tests__'],
\   'new': '$dir/__tests__/$file.test.$ext',
\ },
\ {
\   'type': 'styles',
\   'match': [['\(.*\)\/__styles__\/\(.*\)\.\(styl\)', 1, 2]],
\   'dir': ['$dir/__styles__'],
\   'new': '$dir/__styles__/$file.styl'
\ },
\ {
\   'type': 'origin',
\   'match': [['\(.*\)\/\(.*\)\.\([jt]sx\?\)', 1, 2, 3]],
\   'dir': ['$dir'],
\ },
\ ]
```

Each item in this array represent different file type. They have following fields:
* `type` -- file type. You can switch to that type with `:A fileType` command.
* `match` -- array of match rules that will be used to detect file type and find original directory and file name of this file. Match rule is an array: first item is regular expression; second, third and fourth are regex indexes of directory, file name and extension (for `origin` type) respectively. For example if the current file is `src/components/__tests__/ComponentName.test.tsx`, it wll be matched with `['\(.*\)\/__tests__\/\(.*\)\.test\.\([jt]sx\?\)', 1, 2]` and `src/components` will be the directory and `ComponentName` is file name. You can set multple match rules to cover different possible variants of this file type name.
* `dir` -- array of directories where it will try to find this file. `$dir` and `$file` will be replaced with the directory and original file name.
* `new` -- pattern that will be used to create a new file if it does not exist. `$dir`, `$file` and `$ext` will be replaced with directory, file name and extension of original file. If file type does not have `new` field, it will not try to create a file if it is not present.

Order of items and patterns is important. When script try to match file name, it uses the first found match.

Default configuration represent file structure in the first example.

## TODO

- [ ] Per project config
- [ ] Scopes
- [ ] Open in tab, split
