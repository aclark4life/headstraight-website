# Project Makefile
# ================
#
# A generic Makefile for projects
#
# - https://github.com/project-makefile/project-makefile
#
#
# License
# ------------------------------------------------------------------------------ 
#
# Copyright 2016—2021 Jeffrey A. Clark
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Checkmake
# ------------------------------------------------------------------------------ 
# Make checkmake happy

.PHONY: all
all-default: list-targets-default

.PHONY: clean
clean: list-targets-default

#
# Includes
# ------------------------------------------------------------------------------ 
#
include base.mk
#
# Overrides
# ------------------------------------------------------------------------------ 
#
# Here you can override variables, targets, etc.
#
.DEFAULT_GOAL := commit-push
serve:
	@echo "Serving http://0.0.0.0:8000"
	@npm run watch &
	@python -m http.server

deploy-prod:
	aws --profile default s3 sync --exclude "pyvenv.cfg" --exclude "webpack.config.js" --exclude "src/*" --exclude "package-lock.json" --exclude "package.json" --exclude "base.mk" --exclude "bin/*" --exclude "lib/*" --exclude ".git/*" --exclude ".gitignore" --exclude "Makefile" --exclude "README.rst" --exclude "node_modules/*" --delete . s3://headstraightband.com --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
	aws cloudfront create-invalidation --distribution-id E1OIVKRQH3OZTA --paths "/*"

deploy-dev:
	aws --profile default s3 sync --exclude "pyvenv.cfg" --exclude "webpack.config.js" --exclude "src/*" --exclude "package-lock.json" --exclude "package.json" --exclude "base.mk" --exclude "bin/*" --exclude "lib/*" --exclude ".git/*" --exclude ".gitignore" --exclude "Makefile" --exclude "README.rst" --exclude "node_modules/*" --delete . s3://dev.headstraightband.com --grants read=uri=http://acs.amazonaws.com/groups/global/AllUsers
	aws cloudfront create-invalidation --distribution-id E3PQTOSV9X2KNQ --paths "/*"

pack:
	./node_modules/.bin/webpack

django-npm-install:
	npm install

edit:
	vi index.html

.PHONY: e
e: edit

eb-deploy:
	$(MAKE) deploy-dev
