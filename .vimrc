" release autogroup in MyAutoCmd
augroup MyAutoCmd
    autocmd!
augroup END


"-----------------------------------------------------------------------------
" NeoBundle
"
let s:noplugin = 0
let s:bundle_root = expand('~/.vim/bundle')
let s:neobundle_root = s:bundle_root . '/neobundle.vim'
if !isdirectory(s:neobundle_root) || v:version < 702
    " NeoBundleが存在しない、Vimのバージョンが古い場合はプラグインを読み込まない
    let s:noplugin = 1
else
    " NeoBundleを'runtimepath'に追加し初期化を行う
    if has('vim_starting')
        execute "set runtimepath+=" . s:neobundle_root
    endif
    call neobundle#begin(s:bundle_root)

    " NeoBundle自身をNeoBundleで管理
    NeoBundleFetch 'Shougo/neobundle.vim'

    " 非同期通信を可能にする
    " 'build'が指定されているのでインストール時に自動的に
    " 指定されたコマンドが実行され vimproc がコンパイルされる
    NeoBundle "Shougo/vimproc", {
                \ "build": {
                \   "windows"   : "make -f make_mingw32.mak",
                \   "cygwin"    : "make -f make_cygwin.mak",
                \   "mac"       : "make -f make_mac.mak",
                \   "unix"      : "make -f make_unix.mak",
                \ }}

    """"""""""""""""""
    " My Bundles here:

    """ ネオコン
    NeoBundleLazy 'Shougo/neocomplcache.vim', {
                \ "autoload": {"insert": 1}}

    """ HTMLが開かれるまでロードしない
    NeoBundleLazy 'mattn/zencoding-vim', {
                \ "autoload": {"filetypes": ['html']}}

    """ tabの可視化
    NeoBundle "nathanaelkane/vim-indent-guides"

    """ vim quickrun async
    NeoBundleLazy "thinca/vim-quickrun", {
                \     "autoload": {
                \     "mappings": [['nxo', '<Plug>(quickrun)']]
                \ }}

    " syntastic
    NeoBundle "scrooloose/syntastic", {
                \ "build": {
                \   "mac": ["pip install flake8"],
                \   "unix": ["pip install flake8"],
                \ }}

    " Djangoを正しくVimで読み込めるようにする
    NeoBundleLazy "lambdalisue/vim-django-support", {
                \ "autoload": {
                \   "filetypes": ["python", "python3", "djangohtml"]
                \ }}
    " Vimで正しくvirtualenvを処理できるようにする
    NeoBundleLazy "jmcantrell/vim-virtualenv", {
                \ "autoload": {
                \   "filetypes": ["python", "python3", "djangohtml"]
                \ }}

    " jedi
    NeoBundleLazy "davidhalter/jedi-vim", {
                \ "autoload": {
                \   "filetypes": ["python", "python3", "htmldjango"],
                \   "build": {
                \     "mac": "pip install jedi",
                \     "unix": "pip install jedi",
                \   }
                \ }}

    " C#
    NeoBundleLazy 'nosami/Omnisharp', {
                \   'autoload': {'filetypes': ['cs']},
                \   'build': {
                \     'windows': 'MSBuild.exe server/OmniSharp.sln /p:Platform="Any CPU"',
                \     'mac': 'xbuild server/OmniSharp.sln',
                \     'unix': 'xbuild server/OmniSharp.sln',
                \   }
                \ }
    " pyflakes-vim
    " NeoBundleLazy "mitechie/pyflakes-pathogen", {
    "       \ "autoload": {
    "       \   "filetypes": ["python", "python3"]
    "       \ }}

    " erlang
    "NeoBundleLazy "jimenezrick/vimerl", {
          "\ "autoload": {
          "\    "filetypes":["erlang"]
          "\ }}

    NeoBundle 'majutsushi/tagbar'
    NeoBundle 'kana/vim-smartchr'
    NeoBundle 'kien/ctrlp.vim'
    NeoBundle 'lambdalisue/vim-python-virtualenv'
    NeoBundle 'YankRing.vim'
    NeoBundle 'scrooloose/nerdtree'
    NeoBundle 'plasticboy/vim-markdown'
    NeoBundle 'mxw/vim-jsx'  " react.js
    "NeoBundle 'mitechie/pyflakes-pathogen'
    "NeoBundle 'reinh/vim-makegreen'

    " vim-scripts repos
    NeoBundle 'The-NERD-Commenter'
    NeoBundle 'surround.vim'
    NeoBundle 'yanktmp.vim'
    NeoBundle 'Align'

    " インストールされていないプラグインのチェックおよびダウンロード
    NeoBundleCheck

    call neobundle#end()
endif

" ファイルタイププラグインおよびインデントを有効化
filetype plugin on
filetype indent on



"-----------------------------------------------------------------------------
" NeoBundle遅延読み込み設定
"

" neocomplcache
let s:hooks_neocom = neobundle#get_hooks("neocomplcache.vim")
function! s:hooks_neocom.on_source(bundle)
    let g:neocomplcache_enable_at_startup = 0
    "let g:neocomplcache_omni_functions['python'] = 'jedi#completions'
endfunction


" jedi-vim
let s:hooks = neobundle#get_hooks("jedi-vim")
function! s:hooks.on_source(bundle)
    " jediにvimの設定を任せると'completeopt+=preview'するので
    " 自動設定機能をOFFにし手動で設定を行う
    let g:jedi#auto_vim_configuration = 0
    let g:jedi#auto_initialization = 1
    " 補完の最初の項目が選択された状態だと使いにくいためオフにする
    let g:jedi#popup_select_first = 0
    let g:jedi#popup_on_dot = 1
    " quickrunと被るため大文字に変更
    let g:jedi#rename_command = '<Leader>R'
    " gundoと被るため大文字に変更
    let g:jedi#goto_assignments_command = '<Leader>G'
    " NERDTreeToggle と被るため変更
    let g:jedi#usages_command = "<leader>N"

    let g:jedi#show_call_signatures = 1

    autocmd FileType python let b:did_ftplugin = 1
endfunction


" vim-indent-guides
let s:hooks = neobundle#get_hooks("vim-indent-guides")
function! s:hooks.on_source(bundle)
    let g:indent_guides_start_level = 1
    let g:indent_guides_guide_size = 1
    let g:indent_guides_auto_colors = 0
    colorscheme default
    "hi IndentGuidesOdd ctermbg=darkgray
    "hi IndentGuidesEven ctermbg=darkgray
    IndentGuidesEnable
endfunction


" quickrun
nmap <Leader>r <Plug>(quickrun)
let s:hooks = neobundle#get_hooks("vim-quickrun")
function! s:hooks.on_source(bundle)
  let g:quickrun_config = {
      \ "*": {"runner": "remote/vimproc"},
      \ }
endfunction

" syntastic
let s:hooks = neobundle#get_hooks("syntastic")
function! s:hooks.on_source(bundle)
    let g:syntastic_check_on_open=1
    let g:syntastic_python_checkers=["flake8"]
    let g:syntastic_javascrip_checkers=["gjslint"]
    let g:syntastic_cs_checkers = ["syntax", "issues"]
    " syntasticしてほしいのは js, php, perl
    let g:syntax_mode_map = {'mode' : 'active',
      \ 'active_filetypes': ['javascript', 'php', 'perl'],
      \ 'passive_filetypes': ['sh'] }
endfunction

" OmniSharp
let s:hooks = neobundle#get_hooks("omnisharp")
function! s:hooks.on_source(bundle)
    autocmd BufEnter,TextChanged,InsertLeave *.cs SyntasticCheck
    autocmd CursorHold *.cs call OmniSharp#TypeLookupWithoutDocumentation()
endfunction

" vim-markdown
" デフォルトで折りたたまない
let g:vim_markdown_folding_disabled=1

" vimproc
if has('mac')
  let g:vimproc_dll_path = $HOME . '.vim/bundle/vimproc/autoload/vimproc_mac.so'
elseif has('win32')
  let g:vimproc_dll_path = $HOME . '.vim/bundle/vimproc/autoload/vimproc_win32.dll'
elseif has('win64')
  let g:vimproc_dll_path = $HOME . '.vim/bundle/vimproc/autoload/vimproc_win64.dll'
endif



"-----------------------------------------------------------------------------
" ステータスライン関連
"  1. insert modeで色変更
"  2. format変換
let g:hi_insert = 'highlight StatusLine guifg=darkblue guibg=darkyellow gui=none ctermfg=black ctermbg=yellow cterm=none'

if has('syntax')
    augroup InsertHook
    autocmd!
    autocmd InsertEnter * call s:StatusLine('Enter')
    autocmd InsertLeave * call s:StatusLine('Leave')
    augroup END
endif

let s:slhlcmd = ''
function! s:StatusLine(mode)
    if a:mode == 'Enter'
        silent! let s:slhlcmd = 'highlight ' . s:GetHighlight('StatusLine')
        silent exec g:hi_insert
    else
        highlight clear StatusLine
        silent exec s:slhlcmd
    endif
endfunction

function! s:GetHighlight(hi)
    redir => hl
    exec 'highlight '.a:hi
    redir END
    let hl = substitute(hl, '[\r\n]', '', 'g')
    let hl = substitute(hl, 'xxx', '', '')
    return hl
endfunction




"-----------------------------------------------------------------------------
" バイナリ編集関連
"
" (xxd)モード（vim -b での起動、もしくは *.bin で発動します）
augroup BinaryXXD
    autocmd!
    autocmd BufReadPre  *.bin let &binary =1
    autocmd BufReadPost * if &binary | silent %!xxd -g 1
    autocmd BufReadPost * set ft=xxd | endif
    autocmd BufWritePre * if &binary | %!xxd -r | endif
    autocmd BufWritePost * if &binary | silent %!xxd -g 1
    autocmd BufWritePost * set nomod | endif
augroup END



"-----------------------------------------------------------------------------
" 検索関連
"
"検索文字列が小文字の場合は大文字小文字を区別なく検索する
set ignorecase
"検索文字列に大文字が含まれている場合は区別して検索する
set smartcase
"検索時に最後まで行ったら最初に戻る
set wrapscan
"検索文字列入力時に順次対象文字列にヒットさせない
set noincsearch
"検索結果文字列のハイライトを有効にする
set hlsearch

" バックスラッシュやクエスチョンを状況に合わせ自動エスケープ
cnoremap <expr> / getcmdtype() == '/' ? '\/' : '/'
cnoremap <expr> ? getcmdtype() == '?' ? '\?' : '?'



"-----------------------------------------------------------------------------
" 編集/装飾関連
"
"シンタックスハイライトを有効にする
syntax enable
if exists("syntax")
    syntax on
endif

"タブ, インデント関連
set tabstop=4      " タブは4文字
set shiftwidth=4
set expandtab      " タブ文字は空白文字に
set autoindent     " オートインデント
set cindent        " Cスタイル自動インデント
set shiftround     " indentの移動をshiftwidthの値に丸める

"Align plugin
let g:Align_xstrlen = 3     " for japanese string
let g:DrChipTopLvMenu = ''  " remove 'DrChip' menu

"その他個人設定
set infercase                    " 補完に大文字小文字を区別しない
set laststatus=2                 " ステータスラインを常に表示
set showcmd                      " 入力中のコマンドをステータスに表示する
set showmatch                    " 括弧入力時の対応する括弧を表示
set matchtime=3                  " 括弧対応のハイライトは3秒表示
set backspace=indent,eol,start   " バックスペースでなんでも消せるように
set scrolloff=5                  " スクロール時の余白確保
set autoread                     " 他で書き換えられたら自動で再読み込み
set guioptions+=a                " ターミナル上でマウスを使用可能に
set hidden                       " Undo履歴のためバッファを閉じる代わりに隠す
set switchbuf=useopen            " バッファを優先して開く

" insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

" vimの多重起動を抑止
runtime macros/editexisting.vim

"ステータスラインに文字コードと改行文字を表示する
set statusline=%<%f\ %m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l,%c%V%8P

" 補完設定(for jedi-vimのpopup_selector_firstの無効化)
set completeopt=longest,menuone,preview


"-----------------------------------------------------------------------------
" 画面表示
"
set vb t_vb=       " ベル消灯
set novisualbell
"set list           " 不可視文字の可視化
set number         " 行数
set wrap           " 折り返す
set textwidth=0    " 自動改行の無効化
"set colorcolumn=80 " 80文字目にライン

" デフォルト不可視文字をUnicodeで可視化
"set listchars=tab:❘\ ,trail:-,extends:»,precedes:«,nbsp:% ",eol:↲

"-----------------------------------------------------------------------------
" クリップボード
"
if has('unnamedplus')
    set clipboard& clipboard+=unnamedplus
else
    set clipboard& clipboard+=unnamed
endif


"-----------------------------------------------------------------------------
" Swap, BackUp files
"
"set nowritebackup
"set nobackup
"set noswapfile
set backup
set backupdir=$HOME/.vim/backup
set swapfile
set directory=$HOME/.vim/swp


"-----------------------------------------------------------------------------
" マップ定義
"
"バッファ移動用キーマップ
" F2: 前のバッファ
" F3: 次のバッファ
" F4: バッファ削除
map <F2> <ESC>:bp<CR>
map <F3> <ESC>:bn<CR>
map <F4> <ESC>:bw<CR>

" Exc 2回で ハイライトオフ
nmap <silent> <Esc><Esc> :nohlsearch<CR>

" 検索後にジャンプした際に検索単語を画面中央に持ってくる
nnoremap n nzz
nnoremap N Nzz
nnoremap * *zz
nnoremap # #zz
nnoremap g* g*zz
nnoremap g# g#zz

" TABにて対応ペアにジャンプ
nnoremap <Tab> %
vnoremap <Tab> %


" 表示行単位で行移動する
nnoremap j gj
nnoremap k gk

" フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-

" タブの切り替えを楽に行う
map <C-h> :tabprev<cr>
map <C-l> :tabnext<cr>

" make, grep などのコマンド後に自動的にQuickFixを使う
autocmd MyAutoCmd QuickfixCmdPost make,grep,grepadd,vimgrep copen

" QuickFixおよびHelpでは q でバッファを閉じる
autocmd MyAutoCmd FileType help,qf nnoremap <buffer> q <C-w>c

" w!! でスーパーユーザーとして保存（sudoが使える環境限定）
cmap w!! w !sudo tee > /dev/null %


" バッファの切り替えを楽に行う
"map <C-k> :bn<CR>
"map <C-j> :bN<CR>

" 括弧を入力したとき,括弧内にカーソルを自動移動する
"imap {} {}<Left>
"imap [] []<Left>
"imap () ()<Left>
"imap "" ""<Left>
"imap '' ''<Left>


" The Nerd Tree {{{
nmap <Leader>n :NERDTreeToggle<CR>
let NERDTreeIgnore = ['\.pyc$']
" }}}

" TagBar {{{
nmap <Leader>l :TagbarToggle<CR>
let g:tagbar_ctags_bin = '/usr/local/Cellar/ctags/5.8/bin/ctags'
" }}}

" yanktmp.vim {{{
map <silent> sy :call YanktmpYank()<CR>
map <silent> sp :call YanktmpPaste_p()<CR>
map <silent> sP :call YanktmpPaste_P()<CR>
" }}}


"-----------------------------------------------------------------------------
" 補完機能

let g:neocomplcache_enable_at_startup = 0

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd Filetype python let b:did_ftplugin = 1
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType cs setlocal omnifunc=OmniSharp#Complete
set completeopt-=preview "PydocのWindowは出さない

"" Enable heavy omni completion.
if !exists('g:neocomplcache_force_omni_patterns')
    let g:neocomplcache_force_omni_patterns = {}
endif
let g:neocomplcache_force_omni_patterns.ruby = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_force_omni_patterns.cs = '.*' "'[^.]\.\%(\u\{2,}\)\?'


"" Golang
filetype off
filetype plugin indent off
set runtimepath+=$GOROOT/misc/vim
filetype plugin indent on
syntax on
autocmd FileType go autocmd BufWritePre <buffer> Fmt
exe "set rtp+=".globpath($GOPATH, "src/github.com/nsf/gocode/vim")
set completeopt=menu,preview


"--------------------------------------------------------------------
" 機能追加
"

" create directory automatically
augroup vimrc-auto-mkdir
    autocmd!
    autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'),
    v:cmdbang)
    function! s:auto_mkdir(dir, force)
        if !isdirectory(a:dir) && (a:force ||
                    \ input(printf('"%s" does not exist. Create?
            [y/N]', a:dir)) =~? '^y\%[es]$')
            call mkdir(iconv(a:dir,
            &encoding, &termencoding), 'p')
        endif
    endfunction
augroup END


"開いてるバッファを常にカレントディレクトリにする
au BufEnter * execute ":lcd" . expand("%:p:h")


" 縦分割で画面が狭いとき、自動でリサイズする
nnoremap <C-w><C-e>h <C-w>h<C-w>=
nnoremap <C-w><C-e>l <C-w>l<C-w>=
nnoremap <C-w><C-e>H <C-w>H<C-w>=
nnoremap <C-w><C-e>L <C-w>L<C-w>=
nnoremap <C-w><C-e><C-e> :call <SID>good_width()<Cr>
function! s:good_width()
    if winwidth(0) < 88
        vertical resize 88
    endif
endfunction


" カレント行にアンダーラインを一時的に表示させる
augroup vimrc-auto-cursorline
    autocmd!
    autocmd CursorMoved,CursorMovedI * call s:auto_cursorline('CursorMoved')
    autocmd CursorHold,CursorHoldI * call s:auto_cursorline('CursorHold')
    autocmd WinEnter * call s:auto_cursorline('WinEnter')
    autocmd WinLeave * call s:auto_cursorline('WinLeave')

    let s:cursorline_lock = 0
    function! s:auto_cursorline(event)
        if a:event ==# 'WinEnter'
            setlocal cursorline
            let s:cursorline_lock = 2
        elseif a:event ==# 'WinLeave'
            setlocal nocursorline
        elseif a:event ==# 'CursorMoved'
            if s:cursorline_lock
                if 1 < s:cursorline_lock
                    let s:cursorline_lock = 1
                else
                    setlocal nocursorline
                    let s:cursorline_lock = 0
                endif
            endif
        elseif a:event ==# 'CursorHold'
            setlocal cursorline
            let s:cursorline_lock = 1
        endif
    endfunction
augroup END


" .vimrcを楽に編集
"nnoremap <Space>. :<C-u>edit $MYVIMRC<Enter>
"nnoremap <Space>s. :<C-u>source $MYVIMRC<Enter>


"--------------------------------------------------------------------------
" Python関連
"autocmd Filetype python setl smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class


" ~/.vimrc.localが存在する場合のみ設定を読み込む
let s:local_vimrc = expand('~/.vimrc.local')
if filereadable(s:local_vimrc)
    execute 'source ' . s:local_vimrc
endif
