# FakeBRugs - Pretend that rjags is BRugs #

This tiny library of functions is enough to get you through many
of the examples in Dr. John Kruschke's book, [Doing Bayesian Data
Analysis][1].  The functions translate from the BRugs calls used
in the book, to rjags calls that work on Unix-y environments.

This is not a complete translation layer!!!  It's just enough to
do most of the things the book asks you to do!

Some of the routines that examine the results of the MCMC 
computations are pretty different.  They use R's [coda][2] package,
which is different from whatever BRugs uses.  You'll need to
figure out how to use those things; they're not obvious to me,
but I'm not an R expert at all.

To use this file in the code examples from the book, put this file
in the same directory as your code example, open up the example
file and change:

    #install.packages("BRugs")
    library(BRugs)

to

    source("FakeBRugs.R")

As I said, this is not going to make everything peachy, but it
will take away a lot of the pain of trying to make the code work
on a Mac OS X or Linux box.

I don't use R in my everyday work anymore, so I don't plan on
making any enhancements to this file.  But if you change
something, I'd be happy to accept a pull request on [this 
GitHub page][3].

Hope this is helpful!

-Thomas G Smith <thomathom@gmail.com>

[1]: http://www.indiana.edu/~kruschke/DoingBayesianDataAnalysis/
[2]: http://cran.r-project.org/web/packages/coda/index.html
[3]: https://github.com/tgs/FakeBRugs