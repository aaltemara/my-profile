" My settings
syntax on
"set debug=msg
filetype plugin indent on

set lines=40
set columns=80
set autoindent
set tabstop=4
set smarttab
set expandtab
set shiftwidth=4
set softtabstop=4

set modeline
set modelines=10

if &diff
  colorscheme mycolorscheme
endif

" timestamp.vim settings
autocmd BufEnter * EnableTimestamp
let timestamp_regexp = '\v\C%(<%(Last %([cC]hanged?|modified)|Modified)\s*:\s+)@<=\a+ \d{2} \a+ \d{4} \d{2}:\d{2}:\d{2}%(\s+[AP]M)?%(\s+\a+)?(\s+by.*)?|TIMESTAMP'

let timestamp_rep = '%a %d %b %Y %I:%M:%S %p %Z by #u'

" Syntastic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" vim-session settings
let g:session_autoload = 'yes'
let g:session_autosave = 'yes'
let g:session_autosave_to = 'default'
let g:session_verbose_messages = 0

set backup
set backupdir-=.
set backupdir^=~/backup/vim,~/tmp,/tmp

" Enable Pathogen
runtime bundle/vim-pathogen/autoload/pathogen.vim
execute pathogen#infect()

