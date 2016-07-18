name = nagios-plugins-bird
version = 0.2.0

# install options (like configure)
prefix = /usr
libdir = $(prefix)/lib
sysconfdir = $(prefix)/etc
nagiosdir = $(libdir)/nagios/plugins
nagiosconfdir = $(sysconfdir)/nagios-plugins/config

tmp_dir = $(CURDIR)/tmp

.PHONY: clean dist install deb deb-src

clean:
	rm -rf $(tmp_dir) *.tar.gz *.deb *.dsc

dist:
	@echo "Packaging sources"
	test ! -d $(tmp_dir) || rm -fr $(tmp_dir)
	mkdir -p $(tmp_dir)/$(name)-$(version)
	cp Makefile $(tmp_dir)/$(name)-$(version)
	cp LICENSE README.md CHANGELOG $(tmp_dir)/$(name)-$(version)
	cp -R src $(tmp_dir)/$(name)-$(version)
	cp -R config $(tmp_dir)/$(name)-$(version)
	cp -R debian $(tmp_dir)/$(name)-$(version)
	test ! -f $(name)-$(version).tar.gz || rm $(name)-$(version).tar.gz
	tar -C $(tmp_dir) -czf $(name)-$(version).tar.gz $(name)-$(version)
	rm -fr $(tmp_dir)

install:
	@echo "Installing Bird Nagios plugins in $(DESTDIR)$(nagiosdir)"
	install -d $(DESTDIR)$(nagiosdir)
	install -m 0755 src/* $(DESTDIR)$(nagiosdir)
	install -d $(DESTDIR)$(nagiosconfdir)
	install -m 0644 config/* $(DESTDIR)$(nagiosconfdir)

pre_deb: dist
	mkdir -p $(tmp_dir)
	cp $(name)-$(version).tar.gz $(tmp_dir)/$(name)_$(version).orig.tar.gz
	tar -C $(tmp_dir) -xzf $(tmp_dir)/$(name)_$(version).orig.tar.gz

deb-src: pre_deb
	@echo "Debian source package..."
	cd $(tmp_dir) && dpkg-source -b $(name)-$(version)
	cp $(tmp_dir)/$(name)_$(version)* .
	rm -rf $(tmp_dir)

deb: pre_deb
	@echo "Debian package..."
	cd $(tmp_dir)/$(name)-$(version) && debuild -uc -us
	cp $(tmp_dir)/$(name)*.deb .
	rm -rf $(tmp_dir)

