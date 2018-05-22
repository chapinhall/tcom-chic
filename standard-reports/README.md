# Background

This repository contains the code necessary to generate standard reports under mature development by the Chapin Hall Information Center (CHIC) team of the Transformational Collaborative Outcomes Management (TCOM) group. This includes code for performing the necessary data transformations needed to run the reports.

All of these reports are developed using mock data developed in [this separate repository](http://chudev01.chapinhall.org/tcom-chic/mock-data-development).

# Using and Adapting the Code in this Repository

## Cues for Adapting to Your Own Data

While adapting this code to your data is a detail-oriented and custom process, we have attempted to flag key part of our scripts that need obvious attention. We do so with indications of "/!\\"--an approximation of the "yield" symbol--which can guide your eye, and which you can "Find", to ensure that you attend to them. In each case, we also provide a description of what is needed there.

## R Programming Language for Data Development and Report Generation

The reports in this repository are dynamically generated during the run of programming code to read, process, and analyze mock CANS data developed in [this code repository](http://chudev01.chapinhall.org/tcom-chic/mock-data-development). All of these data manipulation steps are done using the free and open source [R statistical language](https://cran.r-project.org/), and this document--which integrates narrative descriptions of data steps, programming code which performs the necessary data manipulations, and output of that code to help readers interpret and check what is going on--is produced using the free R [Markdown](http://rmarkdown.rstudio.com/) and [Knitr](http://kbroman.org/knitr_knutshell/pages/Rmarkdown.html) packages.

While some solid familiarity with the R programming language is necessary to be able to able to read and understand the data processing steps below, the descriptions and output at each stage should be readable to non-programmers, especially those
with background knowledge of the structure of the CANS and comfort with data. For those with interest in learning more about R and some of the specific data cleaning tools used in this work, see:

* This page on [Cleaning Data with R](http://nsmader.github.io/knitr-sandbox/cleaning-data-with-R.html)
authored by Nick Mader
* A number of free and enjoyable ways to get introduced to R, including online introduction tutorial by groups such as [Code School](http://tryr.codeschool.com/), or [Data Camp](https://www.datacamp.com/courses/free-introduction-to-r)
* Some great one-page [cheat sheets](https://www.rstudio.com/resources/cheatsheets/) for common tasks and packages like data importing, transformation, visualization, etc. The [`rmarkdown` cheat sheet](https://www.rstudio.com/wp-content/uploads/2015/02/rmarkdown-cheatsheet.pdf) is likely of particular interest, since `rmarkdown` is what is used to format and "render" this document.

As a final technical note, some code chunks in the code will often have a block surrounded with a `if (FALSE) {}` statement. In effect, these curly braces surround code that will never run when this document--and the code herein--is rerun and rebuild, since the `if` condition for running the code is, by intention, always set to `FALSE`. The reason for this code is that some examinations of data involve a look at individual assessment or case values, which can *only* be permitted on a HIPAA-compliant data server. Thus, this document--which is intended to be shared and examined by  many stakeholders--will never include that level of detail. However, programmers who are working directly with testing the code can run the code in these blocks "interactively" in order to perform the appropriate checks.

## Regular Expressions for Pattern Matching

Several of the operations below make use of [`grep`](https://en.wikipedia.org/wiki/Grep) functions, which perform pattern matching using what are called [regular expressions](https://en.wikipedia.org/wiki/Regular_expression) are used. This is useful for easy and flexible organization/sorting of content, for example when we want all fields that begin with "BH_" or "FN_", "RF_", or "YS_".

Despite what their name suggests, regular expressions allow for extreme flexibility by having sometimes complex syntax. A very helpful--and even enjoyable--tutorial for learning to use regular expressions as at the [RegexOne](https://regexone.com/)
webpage.
