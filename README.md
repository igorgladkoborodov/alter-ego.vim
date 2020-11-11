# alter-ego.vim

Jump between alternate files: tests, styles, stories, fixtures, mocks etc.

Let's say you have a project with following structure:
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

## Installation

Use this repository to install plugin via you favorite package manager. For example with using [Plug](https://github.com/junegunn/vim-plug):

```
Plug 'igorgladkoborodov/alter-ego.vim'
```

You can add your mappings to jump between files, for example:

```
map <silent> <Leader>jf :A<CR>
map <silent> <Leader>js :A style<CR>
map <silent> <Leader>jt :A test<CR>
map <silent> <Leader>jn :A snapshot<CR>
```

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
\   'type': 'style',
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

## Alternatives

* Classic [a.vim](https://www.vim.org/scripts/script.php?script_id=31)
* [rails.vim](https://github.com/tpope/vim-rails) have powerful related and alternate files navigation for Rails projects
* [SpaceVim](https://spacevim.org/manage-project-alternate-files/) have [built-in alternate file plugin](https://github.com/SpaceVim/SpaceVim/blob/master/autoload/SpaceVim/plugins/a.vim)
* [https://vimawesome.com/?q=alternate](https://vimawesome.com/?q=alternate)

## TODO

- [ ] Finalize config format
- [ ] Per project config
- [ ] Scopes
- [ ] Open in tab, split
