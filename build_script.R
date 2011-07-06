library('devtools')

document(".")
test(".")
run_examples()
devtools:::build(".")
# Happens in /var. Why?
devtools:::check(".")
# Fails. Why?

#install("ProjectTemplate")
#release()
