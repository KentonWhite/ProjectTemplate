---
layout: page
---

It is good practice to run `load.project()` often when developing a data analysis.  This ensures that the global environment is always up to date with the latest data and preprocessing rules.  However, it can sometimes take a while to run, especially if the loaded datasets are large, or the preprocessing is computationally intense.

It is often the case though that loaded datasets and output from preprocessing do not change very much once they are developed (perhaps only if new raw data is received, or there is an update to a particular rule).  The `cache()` function can be used in preprocessing scripts to dynamically cache objects only when necessary.  This provides you with a faster experience whenever `load.project()` is called.

There are three main ways to use it.  The first can be applied to raw datasets just loaded:

                cache("foo")

This will create a cached object of the `foo` object from the global environment the first time it is encountered in a script. If the object has not changed in subsequent invocations, it will not be cached again. Messages are output to inform you when it is being skipped or saved.

The second way is as follows:

                cache("foo", {
                     x<-loaded_data$name
                     x<-as.character(x)
                     x[[1]]
                })

Here the `cache( ... )` function is "wrapped around" some code in the preprocessing script. In this case, the code is executed in the global environment (so a variable `x` is created) and the variable `foo` is assigned the result (also in the global environment - in this case the first entry of the vector `x`). `foo` is then written to the cache.

Now, subsequent invocations of `load.project()` will only re-cache `foo` again only if the code itself has changed (additions of comments or white space in the code block do not count as code changes).  

There is a further variant of this as follows:

                cache("foo", depends=c("a", "b"), {
                     x<-loaded_data$name
                     x<-as.character(x)
                     c(x[[1]], a, b)
                })
                
In this case, if either the code block, or the variables `a` or `b` have changed, then the code is re-executed. This is important when the code chunk references other variables and you absolutely need to re-evaluate the code chunk if those other variables change.

Finally, a `clear.cache()` function is provided to allow fine grain control over the cache - you can remove objects from the cache if you want to force a re-run of all data from scratch. This function takes the form:

                clear.cache("y", "z", "a")

or

                clear.cache()

to clear everything.

