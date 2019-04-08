.PHONY: clean all build install kernel-install

SITE-PACKAGES = $(shell pip show notebook | grep Location | cut -d ' ' -f 2)
CODEMIRROR = $(SITE-PACKAGES)/notebook/static/components/codemirror
CODEMIRROR-AGDA = $(CODEMIRROR)/mode/agda
$(info CODEMIRROR-AGDA: $(CODEMIRROR-AGDA))

all: build local-install kernel-install codemirror-install

build: dist/agda_kernel-0.2-py3-none-any.whl

dist/agda_kernel-0.2-py3-none-any.whl: setup.py agda_kernel/install.py agda_kernel/kernel.py
	python setup.py bdist_wheel

local-install: build
	python -m pip install --force-reinstall dist/agda_kernel-0.2-py3-none-any.whl

# run after the agda_kernel module is installed
kernel-install: build
	python -m agda_kernel.install

codemirror-install: codemirror-agda/agda.js
	mkdir -p $(CODEMIRROR-AGDA)
	cp codemirror-agda/agda.js $(CODEMIRROR-AGDA)

pip-upload: build
	python -m twine upload dist/*

pip-install:
	pip install agda_kernel

committ:
	git add 

clean:
	rm -rf agda_kernel.egg-info build dust