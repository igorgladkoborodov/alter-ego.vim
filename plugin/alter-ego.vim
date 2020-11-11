function! s:FileInfo(fileName)
  let l:result = {
    \   'path': a:fileName,
    \ }
  for fileType in g:alterEgoFileTypes
    for l:match in fileType['match']
      let l:matched = matchlist(a:fileName, l:match[0])
      if get(l:matched, l:match[1]) != '0' && get(l:matched, l:match[2]) != '0'
        let l:result['type'] = fileType['type']
        let l:result['dir'] = l:matched[l:match[1]]
        let l:result['file'] = l:matched[l:match[2]]
        if get(l:match, 3)
          let l:result['ext'] = l:matched[l:match[3]]
        endif
        break
      endif
    endfor
    if has_key(l:result, 'type')
      break
    endif
  endfor
  return l:result
endfunction

function s:FindFile(fileInfo, typeInfo)
  for dir in a:typeInfo['dir']
    let dir = substitute(dir, '$dir', a:fileInfo['dir'], 'g')
    let dir = substitute(dir, '$file', a:fileInfo['file'], 'g')
    let files = split(globpath(dir, '*'))
    for file in files
      let info = s:FileInfo(file)
      if has_key(info, 'file') && info['file'] ==# a:fileInfo['file'] && info['dir'] ==# a:fileInfo['dir']
        return info
      end
    endfor
  endfor
  return {}
endfunction

function! s:TypeInfo(type)
  for fileType in g:alterEgoFileTypes
    if fileType['type'] ==# a:type
      return fileType
    endif
  endfor
  return {}
endfunction

function! AlterEgoJumpTo(...)
  let l:type = a:0 > 0 ? a:1 : 'origin'

  let l:fileInfo = s:FileInfo(expand('%'))
  let l:typeInfo = s:TypeInfo(l:type)

  if !has_key(l:fileInfo, 'type') || !has_key(l:typeInfo, 'type') || l:type ==# l:fileInfo['type']
    return
  endif

  let l:findFile = s:FindFile(l:fileInfo, l:typeInfo)
  if has_key(l:findFile, 'path')
    call s:OpenFile(l:findFile['path'])
    return
  elseif (has_key(l:typeInfo, 'new'))
    let l:newFile = l:typeInfo['new']
    let l:newFile = substitute(l:newFile, '$dir', l:fileInfo['dir'], 'g')
    let l:newFile = substitute(l:newFile, '$file', l:fileInfo['file'], 'g')
    if has_key(l:fileInfo, 'ext')
      let l:newFile = substitute(l:newFile, '$ext', l:fileInfo['ext'], 'g')
    else
      let originTypeInfo = s:TypeInfo('origin')
      let originFile = s:FindFile(l:fileInfo, originTypeInfo)

      let l:newFile = substitute(l:newFile, '$ext', originFile['ext'], 'g')
    endif
    call s:OpenFile(l:newFile)
    return
  endif
endfunction

function! s:OpenFile(file)
  exec('e ' . a:file)
endfunction

command! -nargs=? A call AlterEgoJumpTo(<f-args>)

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
