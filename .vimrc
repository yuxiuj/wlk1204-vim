"
"   This is the personal .vimrc file of wanglk.
"   You can find me at https://github.com/wlk1204/wlk1204-vim
"

" ==========
" Environment
" ==========
  silent function! OSX()
      return has('macunix')
  endfunction
  silent function! LINUX()
      return has('unix') && !has('macunix') && !has('win32unix')
  endfunction
  silent function! WINDOWS()
      return  (has('win32') || has('win64'))
  endfunction

" ==========
" Basics
" ==========
  set nocompatible  " Must be first line
  if !WINDOWS()
      set shell=/bin/sh
  endif

" ==========
" Windows Compatible
" ==========
  if WINDOWS()
    set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
  endif

" ==========
" Plugins
" ==========
  if empty(glob('~/.vim/autoload/plug.vim'))
      silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
          \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif

  call plug#begin('~/.vim/plugged')
  Plug 'altercation/vim-colors-solarized'
  Plug 'scrooloose/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'tpope/vim-surround'
  Plug 'scrooloose/nerdcommenter'
  Plug 'mattn/emmet-vim'
  Plug 'raimondi/delimitMate'
  Plug 'morhetz/gruvbox'
  Plug 'vim-airline/vim-airline'
  Plug 'easymotion/vim-easymotion'
  Plug 'prettier/vim-prettier', { 'do': 'yarn install' }
  Plug 'bling/vim-bufferline'
  Plug 'liuchengxu/vim-which-key', { 'on': ['WhichKey', 'WhichKey!'] }
  call plug#end()

" ==========
" General
" ==========
  " set autowrite
  " set noswapfile     " no swap files
  " set noundofile
  nnoremap <silent> <leader> :WhichKey '<Space>'<CR>
  let NERDTreeShowHidden=1 " show hidden files
  filetype plugin indent on   " Automatically detect file types.
  set nobackup       " no backup files
  set nowritebackup  " only in case you don't want a backup file while editing
  set mouse=a                 " Automatically enable mouse usage
  set mousehide               " Hide the mouse cursor while typing
  set encoding=utf8
  scriptencoding utf-8
  set fileencodings=ucs-bom,utf-8,cp936,gb18030,big5,euc-jp,euc-kr,latin1 " macvim
  if has('clipboard')
      if has('unnamedplus')  " When possible use + register for copy-paste
          set clipboard=unnamed,unnamedplus
      else         " On mac and Windows, use * register for copy-paste
          set clipboard=unnamed
      endif
  endif
  if !exists('g:spf13_no_autochdir')
      autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
      " Always switch to the current file directory
  endif
  set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
  set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
  set virtualedit=onemore             " Allow for cursor beyond last character
  set history=1000                    " Store a ton of history (default is 20)
  set spell                           " Spell checking on
  set hidden                          " Allow buffer switching without saving
  set iskeyword-=.                    " '.' is an end of word designator
  set iskeyword-=#                    " '#' is an end of word designator
  set iskeyword-=-                    " '-' is an end of word designator
  " Instead of reverting the cursor to the last position in the buffer, we
  " set it to the first line when editing a git commit message
  au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

  " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
  " Restore cursor to file position in previous editing session
  " To disable this, add the following to your .vimrc.before.local file:
  "   let g:spf13_no_restore_cursor = 1
  if !exists('g:spf13_no_restore_cursor')
      function! ResCur()
          if line("'\"") <= line("$")
              silent! normal! g`"
              return 1
          endif
      endfunction

      augroup resCur
          autocmd!
          autocmd BufWinEnter * call ResCur()
      augroup END
  endif

" ==========
" Vim UI
" ==========
  set termguicolors
  syntax enable
  " set background=dark
  " let g:solarized_termcolors=256
  colorscheme gruvbox
  " colorscheme solarized
  highlight clear SignColumn
  highlight CocErrorHighlight ctermfg=Red  guifg=#ff0000
  if has('cmdline_info')
      set ruler                   " Show the ruler
      set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
      set showcmd                 " Show partial commands in status line and
  endif
  set tabpagemax=15               " Only show 15 tabs
  set showmode                    " Display the current mode
  set cursorline                  " Highlight current line
  set backspace=indent,eol,start  " Backspace for dummies
  set linespace=0                 " No extra spaces between rows
  set relativenumber              " Show relative line numbers
  set number                      " Show current line number
  set showmatch                   " Show matching brackets/parenthesis
  set incsearch                   " Find as you type search
  set hlsearch                    " Highlight search terms
  set winminheight=0              " Windows can be 0 line high
  set ignorecase                  " Case insensitive search
  set smartcase                   " Case sensitive when uc present
  set wildmenu                    " Show list instead of just completing
  set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
  set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
  set scrolljump=5                " Lines to scroll when cursor leaves screen
  set scrolloff=3                 " Minimum lines to keep above and below cursor
  set sidescrolloff=15
  set foldenable                  " Auto fold code
  set foldmethod=marker
  set list
  set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

" ==========
" Formatting
" ==========
  set nowrap                      " Do not wrap long lines
  set autoindent                  " Indent at the same level of the previous line
  set shiftwidth=2                " Use indents of 4 spaces
  set expandtab                   " Tabs are spaces, not tabs
  set tabstop=2                   " An indentation every four columns
  set softtabstop=2               " Let backspace delete indent
  set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
  set splitright                  " Puts new vsplit windows to the right of the current
  set splitbelow                  " Puts new split windows to the bottom of the current
  set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
  "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
  autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufWritePre <buffer> if !exists('g:spf13_keep_trailing_whitespace') | call StripTrailingWhitespace() | endif
  autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
  autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
  autocmd BufNewFile,BufRead *.coffee set filetype=coffee
  autocmd BufNewFile,BufRead *.ts set filetype=typescript
  autocmd BufNewFile,BufRead *.tsx set filetype=typescript
  autocmd FileType haskell setlocal commentstring=--\ %s
  autocmd FileType html,css,javascript,typescript,json,typescriptreact setlocal tabstop=2 shiftwidth=2 softtabstop=2
  autocmd FileType haskell,rust,typescript,javascript setlocal nospell

" ==========
" Key(re) Mappings
" ==========
  let mapleader = ' '
  let maplocalleader = '_'
  let s:edit_config_mapping = '<leader>ev'
  let s:apply_config_mapping = '<leader>sv'
  noremap j gj
  noremap k gk
  nnoremap <Leader>b :bp<CR>
  nnoremap <Leader>f :bn<CR>
  nnoremap <Leader>bl :ls<CR>
  nnoremap <Leader>b1 :1b<CR>
  nnoremap <Leader>b2 :2b<CR>
  nnoremap <Leader>b3 :3b<CR>
  nnoremap <Leader>b4 :4b<CR>
  nnoremap <Leader>b5 :5b<CR>
  nnoremap <Leader>b6 :6b<CR>
  nnoremap <Leader>b7 :7b<CR>
  nnoremap <Leader>b8 :8b<CR>
  nnoremap <Leader>b9 :9b<CR>
  nnoremap <Leader>b0 :10b<CR>
  " trigger background
  function! ToggleBG()
      let s:tbg = &background
      " Inversion
      if s:tbg == "dark"
          set background=light
      else
          set background=dark
      endif
  endfunction
  noremap <leader>bg :call ToggleBG()<CR>
  if !exists('g:wanglk_no_easyWindows')
      map <C-J> <C-W>j<C-W>_
      map <C-K> <C-W>k<C-W>_
      map <C-L> <C-W>l<C-W>_
      map <C-H> <C-W>h<C-W>_
  endif
  if !exists('g:wanglk_no_wrapRelMotion')
      " Same for 0, home, end, etc
      function! WrapRelativeMotion(key, ...)
          let vis_sel=""
          if a:0
              let vis_sel="gv"
          endif
          if &wrap
              execute "normal!" vis_sel . "g" . a:key
          else
              execute "normal!" vis_sel . a:key
          endif
      endfunction

      " normal
      noremap $ :call WrapRelativeMotion("$")<CR>
      noremap <End> :call WrapRelativeMotion("$")<CR>
      noremap 0 :call WrapRelativeMotion("0")<CR>
      noremap <Home> :call WrapRelativeMotion("0")<CR>
      noremap ^ :call WrapRelativeMotion("^")<CR>
      " Overwrite the operator pending $/<End> mappings from above
      " to force inclusive motion with :execute normal!
      onoremap $ v:call WrapRelativeMotion("$")<CR>
      onoremap <End> v:call WrapRelativeMotion("$")<CR>
      " visual+select
      vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
      vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
      vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
      vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
      vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
  endif

  nnoremap Y y$
  nmap <silent> <leader>/ :set invhlsearch<CR>

  " Shortcuts
  " Change Working Directory to that of the current file
  cmap cwd lcd %:p:h
  cmap cd. lcd %:p:h

  " Visual shifting (does not exit Visual mode)
  vnoremap < <gv
  vnoremap > >gv
  " repeat operator
  " http://stackoverflow.com/a/8064607/127816
  vnoremap . :normal .<CR>

  " For when you forget to sudo.. Really Write the file.
  cmap w!! w !sudo tee % >/dev/null

  " Some helpers to edit mode
  " http://vimcasts.org/e/14
  cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
  map <leader>ew :e %%
  map <leader>es :sp %%
  map <leader>ev :vsp %%
  map <leader>et :tabe %%

  " Find merge conflict markers
  " map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

  " Adjust viewports to the same size
  map <Leader>= <C-w>=
  " Map <Leader>ff to display all lines with keyword under cursor
  " and ask which one to jump to
  nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>
  " Easier horizontal scrolling
  map zl zL
  map zh zH
  " Easier formatting
  nnoremap <silent> <leader>q gwip

  " FIXME: Revert this f70be548
  " fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
  map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>
  map <C-e> :NERDTreeToggle<CR>
  let NERDTreeQuitOnOpen=0
  autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
  map <leader>1 <C-h>
  map <leader>2 <C-l>

  "" coc.vim
  " :verbose imap <tab>
  " inoremap <silent><expr> <TAB>
  "   \ pumvisible() ? "\<C-n>" :
  "   \ <SID>check_back_space() ? "\<TAB>" :
  "   \ coc#refresh()
  " inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

  function! s:check_back_space() abort
      let col = col('.') - 1
      return !col || getline('.')[col - 1]  =~# '\s'
  endfunction

" ==========
" GUI Settings
" ==========
  let g:NERDSpaceDelims=1
  "let g:airline_statusline_ontop=1
  " GVIM- (here instead of .gvimrc)
  if has('gui_running')
      set guioptions-=T           " Remove the toolbar
      set lines=40                " 40 lines of text instead of 24
      if !exists("g:spf13_no_big_font")
          if LINUX() && has("gui_running")
              set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
          elseif OSX() && has("gui_running")
              set guifont=HackNerdFontComplete-Regular:h14,Menlo\ Regular:h14,Consolas\ Regular:h14,Courier\ New\ Regular:h14
          elseif WINDOWS() && has("gui_running")
              set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
          endif
      endif
  else
      if &term == 'xterm' || &term == 'screen'
          set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
      endif
      "set term=builtin_ansi       " Make arrow and other keys work
  endif

" ==========
" Functions
" ==========
  " Strip whitespace {
  function! StripTrailingWhitespace()
      " Preparation: save last search, and cursor position.
      let _s=@/
      let l = line(".")
      let c = col(".")
      " do the business:
      %s/\s\+$//e
      " clean up: restore previous search history, and cursor position
      let @/=_s
      call cursor(l, c)
  endfunction

  " Shell command {
  function! s:RunShellCommand(cmdline)
      botright new
      setlocal buftype=nofile
      setlocal bufhidden=delete
      setlocal nobuflisted
      setlocal noswapfile
      setlocal nowrap
      setlocal filetype=shell
      setlocal syntax=shell

      call setline(1, a:cmdline)
      call setline(2, substitute(a:cmdline, '.', '=', 'g'))
      execute 'silent $read !' . escape(a:cmdline, '%#')
      setlocal nomodifiable
      1
  endfunction

  command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
  " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
  " }

  function! s:ExpandFilenameAndExecute(command, file)
      execute a:command . " " . expand(a:file, ":p")
  endfunction

  function! s:EditWanglkConfig()
      call <SID>ExpandFilenameAndExecute("tabedit", "~/.vimrc")
  endfunction

  execute "noremap " . s:edit_config_mapping " :call <SID>EditWanglkConfig()<CR>"
  execute "noremap " . s:apply_config_mapping . " :source ~/.vimrc<CR>"
