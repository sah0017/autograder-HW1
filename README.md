# RSpec With Gradescope

The files in this repo provide the necessary scaffolding to create
a [Gradescope](https://gradescope.com)-compatible grader for 
assignments graded solely on the basis of one or more RSpec specfiles.
To summarize [how Gradescope autograding works](https://gradescope-autograders.readthedocs.io/en/latest/specs/):

* Your create a zipfile that gets unzipped and "wakes up" in an instantiated Docker container with
a well-known directory structure (this repo helps you do so)
* You provide a script `setup.sh` that installs the necessary packages, libraries, etc. on which
the autograder depends
* You provide a script `run_autograder` that actually invokes the autograder
* The autograder is expected to produce a JSON file with the results of the run,
feedback for the student, etc.

To create a Gradescope-compatible autograder for a programming
assignment that is graded entirely on the basis of RSpec tests,
structure the homework solutions repo as follows.

Note: It's fine if the assignment is split into multiple
specfiles, and/or if the students submit multiple code files, but the
entire assignment will be treated as a single gradeable unit.

## Use this repo as a template

To use this repo as a template, click the green "Use as template"
button above.  (This is different from clone or fork.)  Then clone
your copy and work from there.

## Set the name of the assignment in the Makefile

Set the make variable `NAME` to some descriptive name for your
assignment, like `homework_1`.  This will be used as the name of the
zipfile you'll upload to Gradescope, among other things.

## Add your spec files

When you write your specs, give each example a point value.  There
are two ways to do this: in the docstring or in the metadata.

```ruby
it "works [3 points]" do
  expect(true).to eq(true) 
end
it "works", points: 3 do
  expect(true).to eq(true)
end
```

If you specify both for the same example, you'll get a warning if the
points match and an unrecoverable exception if they don't.

The spec files should not explicitly try to `require` student code or
anything like that; the packaging (below) will do that.  

Delete the example `*_spec.rb` files in the `spec/` directory and put
your specfiles there.  Note that this `spec` directory contains a copy of the file
`rspec_gradescope_formatter.rb` from this repo.  Don't delete that
file.

If your assignment has sequential parts in
different specfiles, name the files so that the names collate in the
order in which you want students to see results (e.g.,
`p1_foo_spec.rb` and `p2_bar_spec.rb` will sort in that order, whereas
`foo_spec.rb` and `bar_spec.rb` will sort in the opposite order).

## Package your spec files and test things locally

1. Make sure the directory `spec` contains _all_ specfiles for the
assignment.  

1. Say `make test SOLUTIONS=`_your-solutions-file_`.rb` to test things
locally, where this file contains a reference solution to the assignment.
This make target will create an
`autograder` directory that looks like it will look on Gradescope and
tries to run your specfiles against that reference solution.
You can inspect `autograder/results/results.json` to see if it looks
good.

1. If all looks good, `make` will create a
zipfile that should have the right contents for uploading to Gradescope.

1. `make clean` removes the temporary `autograder` directory and the
zipfile.

