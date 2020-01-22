# @see https://gradescope-autograders.readthedocs.io/en/latest/specs/
# Optional: change to the name of your assignment.  $(NAME).zip will be produced as output
NAME = assignment
# Path to zip if not in your $PATH
ZIP  = zip


FILES = $(wildcard spec/*) run_autograder setup.sh

all: $(NAME).zip

$(NAME).zip: $(FILES)
	$(ZIP) $@ setup.sh run_autograder spec

.PHONY: test
test: localenv
	echo 'Grading dummy assignment with run_autograder...'
	cd autograder && ./run_autograder
	echo 'Done, check autograder/results/results.json for results'

.PHONY: make_localenv
localenv: $(FILES)
	@echo 'Setting up environment to look like Gradescope docker container...'
	-rm -rf autograder
	mkdir autograder && cd autograder && mkdir source submission
	cp run_autograder autograder/
	cp Makefile README.md $(SOLUTIONS) rspec_gradescope_formatter.rb run_autograder setup.sh autograder/source
	cp -R spec autograder/source/
	cp $(SOLUTIONS) autograder/submission/

.PHONY: clean
clean:
	-rm -rf autograder $(NAME).zip

