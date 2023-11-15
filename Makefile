# Makefile for copying files downloaded using composer into the proper location
# for use with WebCalendar.
# We only copy the min number of files required from the vendor directory.
# Also, compute the SHA hash to use with the integrity tag.
# We don't want WebCalendar releases to bundle every single file in the vendor directory.
# Also, composer dependency management sucks at asset management.
#
# NOTE: This Makefile does not work on macos, just linux.  This is because there is
# no sha384sum command on macos.  If you're on a Mac, you can use docker to setup
# a linux container where (after installing xdd), you can run make to generate the
# sha files.

PHPMAILER_DIR = includes/classes/phpmailer
PHPMAILER_VENDOR_DIR = vendor/phpmailer/phpmailer/src

BOOTSTRAP_ICON_DIR = images/bootstrap-icons
BOOTSTRAP_ICON_VENDOR_DIR = vendor/twbs/bootstrap-icons/icons

CKEDITOR_VENDOR_DIR = vendor/ckeditor

SHA384SUM = /usr/bin/sha384sum

_DEFAULT: _phpmailer includes/load_assets.php \
	_ICONS pub/ckeditor/CHANGES.md

_phpmailer: $(PHPMAILER_DIR)/PHPMailer.php \
	$(PHPMAILER_DIR)/Exception.php \
	$(PHPMAILER_DIR)/OAuth.php \
	$(PHPMAILER_DIR)/POP3.php \
	$(PHPMAILER_DIR)/SMTP.php

$(PHPMAILER_DIR)/PHPMailer.php: $(PHPMAILER_VENDOR_DIR)/PHPMailer.php
	cp $< $@

$(PHPMAILER_DIR)/Exception.php: $(PHPMAILER_VENDOR_DIR)/Exception.php
	cp $< $@

$(PHPMAILER_DIR)/OAuth.php: $(PHPMAILER_VENDOR_DIR)/OAuth.php
	cp $< $@

$(PHPMAILER_DIR)/POP3.php: $(PHPMAILER_VENDOR_DIR)/POP3.php
	cp $< $@

$(PHPMAILER_DIR)/SMTP.php: $(PHPMAILER_VENDOR_DIR)/SMTP.php
	cp $< $@

_ICONS: \
	$(BOOTSTRAP_ICON_DIR)/printer.svg \
	$(BOOTSTRAP_ICON_DIR)/search.svg \
	$(BOOTSTRAP_ICON_DIR)/arrow-left.svg \
	$(BOOTSTRAP_ICON_DIR)/arrow-right-circle.svg \
	$(BOOTSTRAP_ICON_DIR)/arrow-left-circle.svg \
	$(BOOTSTRAP_ICON_DIR)/arrow-up-short.svg \
	$(BOOTSTRAP_ICON_DIR)/arrow-down-short.svg \
	$(BOOTSTRAP_ICON_DIR)/plus-circle.svg \
	$(BOOTSTRAP_ICON_DIR)/rss-fill.svg \
	$(BOOTSTRAP_ICON_DIR)/circle-fill.svg \
	$(BOOTSTRAP_ICON_DIR)/exclamation-triangle-fill.svg \
	$(BOOTSTRAP_ICON_DIR)/question-circle-fill.svg \
	$(BOOTSTRAP_ICON_DIR)/arrow-90deg-up.svg \
	$(BOOTSTRAP_ICON_DIR)/dash-circle.svg \
	$(BOOTSTRAP_ICON_DIR)/check-circle.svg \
	$(BOOTSTRAP_ICON_DIR)/trash.svg \
	$(BOOTSTRAP_ICON_DIR)/key-fill.svg \
	$(BOOTSTRAP_ICON_DIR)/info-circle-fill.svg \
	$(BOOTSTRAP_ICON_DIR)/circle.svg

$(BOOTSTRAP_ICON_DIR)/printer.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/printer.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/search.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/search.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/arrow-right-circle.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/arrow-right-circle.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/arrow-left.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/arrow-left.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/arrow-left-circle.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/arrow-left-circle.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/arrow-up-short.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/arrow-up-short.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/arrow-down-short.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/arrow-down-short.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/plus-circle.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/plus-circle.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/rss-fill.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/rss-fill.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/circle-fill.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/circle-fill.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/exclamation-triangle-fill.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/exclamation-triangle-fill.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/question-circle-fill.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/question-circle-fill.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/arrow-90deg-up.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/arrow-90deg-up.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/dash-circle.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/dash-circle.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/check-circle.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/check-circle.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/trash.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/trash.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/key-fill.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/key-fill.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/info-circle-fill.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/info-circle-fill.svg
	cp $< $@

$(BOOTSTRAP_ICON_DIR)/circle.svg: $(BOOTSTRAP_ICON_VENDOR_DIR)/circle.svg
	cp $< $@

includes/load_assets.php: \
	pub/bootstrap.min.css \
	pub/bootstrap.min.css.sha \
	pub/bootstrap.bundle.min.js \
	pub/bootstrap.bundle.min.js.sha \
	pub/jquery.min.js \
	pub/jquery.min.js.sha
	echo '<?php' > $@
	echo '// Auto-generated by make.  Do not hand-edit.' >> $@
	echo '// See Makefile in source for details..' >> $@
	echo '// Last updated: ' | tr -d '\012' >> $@
	date >> $@
	echo "XASSETS =" | tr X '\044' >> $@
	echo '  _<link rel="stylesheet" href="pub/bootstrap.min.css" integrity="sha384-' | tr -d '\012' | tr _ '\047' >> $@
	cat pub/bootstrap.min.css.sha | tr -d '\012' >> $@
	echo '">_ .' | tr _ '\047' >> $@
	echo '  _<script src="pub/jquery.min.js" integrity="sha384-' | tr -d '\012' | tr _ '\047' >> $@
	cat pub/jquery.min.js.sha | tr -d '\012' >> $@
	echo '"></script>_ .' | tr _ '\047' >> $@
	echo '  _<script src="pub/bootstrap.bundle.min.js" integrity="sha384-' | tr -d '\012' | tr _ '\047' >> $@
	cat pub/bootstrap.bundle.min.js.sha | tr -d '\012' >> $@
	echo '"></script>_ .' | tr _ '\047' >> $@
	echo '  "\\n";' >> $@
	echo '?>' >> $@

pub/bootstrap.min.css: vendor/twbs/bootstrap/dist/css/bootstrap.min.css
	cp $< $@

pub/bootstrap.min.css.sha: pub/bootstrap.min.css $(SHA384SUM)
	$(SHA384SUM) $< | head -c 96 | xxd -r -p | base64 > $@

pub/bootstrap.bundle.min.js: vendor/twbs/bootstrap/dist/js/bootstrap.bundle.min.js
	cp $< $@

pub/bootstrap.bundle.min.js.sha: pub/bootstrap.bundle.min.js $(SHA384SUM)
	$(SHA384SUM) $< | head -c 96 | xxd -r -p | base64 > $@

pub/jquery.min.js: vendor/components/jquery/jquery.min.js
	cp $< $@

pub/jquery.min.js.sha: pub/jquery.min.js $(SHA384SUM)
	$(SHA384SUM) $< | head -c 96 | xxd -r -p | base64 > $@

# CKEDITOR 4.X stuff
# To get the list of files we need for the "basic" install of ckeditor,
# I downloaded the "basic package" from the website:
#   https://ckeditor.com/ckeditor-4/download
# Then I looked at what was included to make the list of files we need
# to copy over from the vendor/ckeditor directory (which includes
# enough for the "full package" of 72 plugins and adds about 15Mb instead
# of the 2Mb for basic.
# To create this list from the unzipped ckeditor download, cd into the unzipped
# 'ckeditor' dir and use this command:
#  find * -type f | grep -v samples | grep -v config.js | grep -v 'adapters/' | sed 's/^/\t/' | sed 's/$/ \\/' | sed 's/promise.js ./promise.js/'
# NOTE: We do not include the config.js provides by composer because it defaults to
# the full ckeditor distribution with all plugins (15+ Mb).  Instead, I've downloaed
# the config.js from the 4.18 basic build and copied it manually into pub/ckeditor.
# It's possible we may need to update the pub/ckeditor/config.js file manually if
# a new 4.X release requires updates to this file.
# NOTE #2: This Makefile is assuming that the README.md file gets updated with
# each CKEditor update (seems like a safe assumption.)
CKEDITOR_FILES = \
	pub/ckeditor/CHANGES.md \
	pub/ckeditor/LICENSE.md \
	pub/ckeditor/README.md \
	pub/ckeditor/SECURITY.md \
	pub/ckeditor/bender-runner.config.json \
	pub/ckeditor/ckeditor.js \
	pub/ckeditor/contents.css \
	pub/ckeditor/lang/sr-latn.js \
	pub/ckeditor/lang/pt.js \
	pub/ckeditor/lang/vi.js \
	pub/ckeditor/lang/lv.js \
	pub/ckeditor/lang/gl.js \
	pub/ckeditor/lang/pl.js \
	pub/ckeditor/lang/mn.js \
	pub/ckeditor/lang/en-ca.js \
	pub/ckeditor/lang/el.js \
	pub/ckeditor/lang/et.js \
	pub/ckeditor/lang/is.js \
	pub/ckeditor/lang/sl.js \
	pub/ckeditor/lang/ko.js \
	pub/ckeditor/lang/hr.js \
	pub/ckeditor/lang/ms.js \
	pub/ckeditor/lang/fi.js \
	pub/ckeditor/lang/th.js \
	pub/ckeditor/lang/ru.js \
	pub/ckeditor/lang/eu.js \
	pub/ckeditor/lang/mk.js \
	pub/ckeditor/lang/no.js \
	pub/ckeditor/lang/sq.js \
	pub/ckeditor/lang/gu.js \
	pub/ckeditor/lang/si.js \
	pub/ckeditor/lang/tt.js \
	pub/ckeditor/lang/ja.js \
	pub/ckeditor/lang/ka.js \
	pub/ckeditor/lang/he.js \
	pub/ckeditor/lang/ug.js \
	pub/ckeditor/lang/bg.js \
	pub/ckeditor/lang/af.js \
	pub/ckeditor/lang/id.js \
	pub/ckeditor/lang/az.js \
	pub/ckeditor/lang/en-au.js \
	pub/ckeditor/lang/ca.js \
	pub/ckeditor/lang/cy.js \
	pub/ckeditor/lang/nb.js \
	pub/ckeditor/lang/zh-cn.js \
	pub/ckeditor/lang/de-ch.js \
	pub/ckeditor/lang/pt-br.js \
	pub/ckeditor/lang/oc.js \
	pub/ckeditor/lang/da.js \
	pub/ckeditor/lang/fa.js \
	pub/ckeditor/lang/de.js \
	pub/ckeditor/lang/en.js \
	pub/ckeditor/lang/bs.js \
	pub/ckeditor/lang/ku.js \
	pub/ckeditor/lang/sv.js \
	pub/ckeditor/lang/zh.js \
	pub/ckeditor/lang/hi.js \
	pub/ckeditor/lang/uk.js \
	pub/ckeditor/lang/cs.js \
	pub/ckeditor/lang/km.js \
	pub/ckeditor/lang/fr.js \
	pub/ckeditor/lang/nl.js \
	pub/ckeditor/lang/fr-ca.js \
	pub/ckeditor/lang/en-gb.js \
	pub/ckeditor/lang/sr.js \
	pub/ckeditor/lang/hu.js \
	pub/ckeditor/lang/lt.js \
	pub/ckeditor/lang/fo.js \
	pub/ckeditor/lang/ar.js \
	pub/ckeditor/lang/es-mx.js \
	pub/ckeditor/lang/sk.js \
	pub/ckeditor/lang/it.js \
	pub/ckeditor/lang/es.js \
	pub/ckeditor/lang/bn.js \
	pub/ckeditor/lang/eo.js \
	pub/ckeditor/lang/ro.js \
	pub/ckeditor/lang/tr.js \
	pub/ckeditor/plugins/about/dialogs/about.js \
	pub/ckeditor/plugins/about/dialogs/hidpi/logo_ckeditor.png \
	pub/ckeditor/plugins/about/dialogs/logo_ckeditor.png \
	pub/ckeditor/plugins/dialog/styles/dialog.css \
	pub/ckeditor/plugins/dialog/dialogDefinition.js \
	pub/ckeditor/plugins/icons.png \
	pub/ckeditor/plugins/link/images/hidpi/anchor.png \
	pub/ckeditor/plugins/link/images/anchor.png \
	pub/ckeditor/plugins/link/dialogs/link.js \
	pub/ckeditor/plugins/link/dialogs/anchor.js \
	pub/ckeditor/plugins/icons_hidpi.png \
	pub/ckeditor/plugins/clipboard/dialogs/paste.js \
	pub/ckeditor/skins/moono-lisa/editor_iequirks.css \
	pub/ckeditor/skins/moono-lisa/editor.css \
	pub/ckeditor/skins/moono-lisa/images/lock.png \
	pub/ckeditor/skins/moono-lisa/images/spinner.gif \
	pub/ckeditor/skins/moono-lisa/images/arrow.png \
	pub/ckeditor/skins/moono-lisa/images/lock-open.png \
	pub/ckeditor/skins/moono-lisa/images/hidpi/lock.png \
	pub/ckeditor/skins/moono-lisa/images/hidpi/lock-open.png \
	pub/ckeditor/skins/moono-lisa/images/hidpi/refresh.png \
	pub/ckeditor/skins/moono-lisa/images/hidpi/close.png \
	pub/ckeditor/skins/moono-lisa/images/refresh.png \
	pub/ckeditor/skins/moono-lisa/images/close.png \
	pub/ckeditor/skins/moono-lisa/editor_ie.css \
	pub/ckeditor/skins/moono-lisa/editor_ie8.css \
	pub/ckeditor/skins/moono-lisa/dialog_iequirks.css \
	pub/ckeditor/skins/moono-lisa/readme.md \
	pub/ckeditor/skins/moono-lisa/icons.png \
	pub/ckeditor/skins/moono-lisa/editor_gecko.css \
	pub/ckeditor/skins/moono-lisa/dialog_ie.css \
	pub/ckeditor/skins/moono-lisa/dialog.css \
	pub/ckeditor/skins/moono-lisa/icons_hidpi.png \
	pub/ckeditor/skins/moono-lisa/dialog_ie8.css \
	pub/ckeditor/styles.js \
	pub/ckeditor/vendor/promise.js

# CKEDITOR
pub/ckeditor/CHANGES.md: $(CKEDITOR_VENDOR_DIR)/ckeditor/CHANGES.md
	for f in $(CKEDITOR_FILES); do\
	  a="$(CKEDITOR_VENDOR_DIR)/"`echo $${f} | sed 's?pub/??'`; \
	  echo "Copying file: $${f}"; \
	  cp $${a} $${f}; \
	done

