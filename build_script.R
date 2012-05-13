library('devtools')

document(".")
test(".")
run_examples()
devtools:::build(".")
devtools:::check(".")
#install("ProjectTemplate")
#release()
