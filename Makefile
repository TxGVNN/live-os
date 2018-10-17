build: pre-build
	sudo lb build

pre-build:
	$(MAKE) -C config/includes.chroot/lib/live/dotfiles build

clean:
	$(MAKE) -C config/includes.chroot/lib/live/dotfiles clean
	sudo lb clean
