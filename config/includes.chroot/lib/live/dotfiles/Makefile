HOME = $(shell pwd)
build: emacs vim

emacs: .emacs
	emacs -q --batch -l .emacs
	find .emacs.d -name \*.elc -exec rm {} \;
vim: .vimrc
	if [ ! -f ~/.vim/autoload/plug.vim ]; then \
		curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim ;\
	fi ;\
	vim +PlugInstall +qall

clean:
	rm .emacs.d .vim -rf
