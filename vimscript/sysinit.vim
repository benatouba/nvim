if !filereadable($HOME . '/.config/nvim/init.lua')
	if !filereadable($HOME . '/.config/nvim/init.vim')
		echo 'Loading global setup'
		set runtimepath-=/root/.config/nvim
		set runtimepath+=/usr/local/share/nvim/config
		luafile /usr/local/share/nvim/config/init.lua
	endif
endif
