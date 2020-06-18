VERSION ?= Alpha

DATE := $(shell date +'%Y%m%d')

ZIP := LH-KERNEL-$(VERSION)-$(DATE).zip

EXCLUDE := Makefile *.git* *.jar*

all: $(ZIP)

$(ZIP):
	@echo "Creating ZIP: $(ZIP)"
	@zip -r9 "$@" . -x $(EXCLUDE)
	@echo "Generating SHA1..."
	@sha1sum "$@" > "$@.sha1"
	@cat "$@.sha1"
	@echo "Done."

clean:
	@rm -vf "LH-KERNEL-"*.zip*
	@rm -vf Image.gz-dtb
	@echo "Done."

sign:
	java -classpath testsign.jar testsign "LH-KERNEL-$(VERSION)-$(DATE)".zip "LH-KERNEL-$(VERSION)-$(DATE)"-signed.zip
