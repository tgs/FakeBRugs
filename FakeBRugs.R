# FakeBRugs - Pretend that rjags is BRugs
#
# This tiny library of functions is enough to get you through many
# of the examples in Dr. John Kruschke's book, Doing Bayesian Data
# Analysis [1].  The functions translate from the BRugs calls used
# in the book, to rjags calls that work on Unix-y environments.
#
# This is not a complete translation layer!!!  It's just enough to
# do most of the things the book asks you to do!
#
# Some of the routines that examine the results of the MCMC 
# computations are pretty different.  They use R's coda [2] package,
# which is different from whatever BRugs uses.  You'll need to
# figure out how to use those things; they're not obvious to me,
# but I'm not an R expert at all.
#
# To use this file in the code examples from the book, put this file
# in the same directory as your code example, open up the example
# file and change:
#
# 	#install.packages("BRugs")
# 	library(BRugs)
#
# to
#
# 	source("FakeBRugs.R")
#
# As I said, this is not going to make everything peachy, but it
# will take away a lot of the pain of trying to make the code work
# on a Mac OS X or Linux box.
#
# I don't use R in my everyday work anymore, so I don't plan on
# making any enhancements to this file.  But if you change
# something, I'd be happy to accept a pull request on this 
# GitHub page [3].
#
# Hope this is helpful!
#
# -Thomas G Smith <thomathom@gmail.com>
#
# [1]: http://www.indiana.edu/~kruschke/DoingBayesianDataAnalysis/
# [2]: http://cran.r-project.org/web/packages/coda/index.html
# [3]: https://github.com/tgs/FakeBRugs

library(rjags)
library(plyr)

# CHANGE THIS if you're on Linux!
# There may be another way of accomplishing this, with options(device=)?
windows <- function(w, h) {
	# Mac:
	quartz(w=w, h=h)
}

modelCheck <- function(modelFileName) {
	FakeBRugs_modelFileName <<- modelFileName
}

bugsData <- function(datalist) {
	return(datalist)
}

modelData <- function(datalist) {
	FakeBRugs_modelData <<- datalist
}

modelCompile <- function(numChains=1) {
	FakeBRugs_MODEL <<- NULL
	FakeBRugs_numChains <<- numChains
}

modelGenInits <- function() {
	print("hi")
}

bugsInits <- bugsData

modelGenInits <- function() {
	FakeBRugs_inits <<- NULL
}

modelInits <- function(inits) {
	if (! is.function(inits)) {
		stop("Can't deal with non-function inits yet but got ", str(inits))
	}
	FakeBRugs_inits <<- inits
}

FakeBRugs_getModel <- function() {
	if (is.null(FakeBRugs_MODEL)) {
		FakeBRugs_sampleList <<- NULL
		FakeBRugs_chains <<- NULL
		args <- list(
			file = FakeBRugs_modelFileName ,
			data = FakeBRugs_modelData ,
			n.chains = FakeBRugs_numChains 
			#inits = FakeBRugs_inits
			)
		print(paste('Calling jags.model with ', str(args)))
		model <- do.call(jags.model, args)
		FakeBRugs_MODEL <<- model
	}

	return(FakeBRugs_MODEL)
}

samplesSet <- function(sampleList) {
	FakeBRugs_sampleList <<- sampleList
}


modelUpdate <- function(steps, thin=1) {
	model <- FakeBRugs_getModel()
	if (is.null(FakeBRugs_sampleList)) {
		update(model, steps)
	} else {
		csamps <- coda.samples(model, FakeBRugs_sampleList, steps * thin, thin=thin)
		if (! is.null(FakeBRugs_chains)) {
			warning("Overwriting earlier chains with new ones!")
		}
		FakeBRugs_chains <<- csamps
	}
}

samplesSample <- function(nodeName) {
	samples <- laply(FakeBRugs_chains, function(m) as.vector(m[,nodeName]))
	return(as.vector(samples))
}

getRealSamples <- function() {
	return(FakeBRugs_chains)
}

samplesStats <- function(nodeName) {
	return(summary(FakeBRugs_chains[,nodeName]))
}

samplesHistory <- function(nodeName, ...) {
	traceplot(FakeBRugs_chains[,nodeName], ...)
}

samplesAutoC <- function(nodeName, chain=1, ...) {
	autocorr.plot(FakeBRugs_chains[[chain]][,nodeName], ...)
}

samplesBgr <- function(nodeName, ...) {
	gelman.plot(FakeBRugs_chains[,nodeName], ...)
}



