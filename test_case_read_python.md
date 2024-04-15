## Test Case: Interleaved Python and R Code Execution with Reticulate

**Purpose:** This test case verifies the ability of RStudio to seamlessly execute Python code interspersed with R code in a sequential order. The test utilizes the `reticulate` package to facilitate communication between R and Python environments.

**Scope:**

* **Functionality:**
  * Loading and executing Python scripts within R Studio.
  * Importing Python libraries within R using `reticulate`.
  * Reading and writing files from Python code.
  * Capturing results from Python code within R.
* **Limitations:**
  * Focuses on basic functionalities.
  * Doesn't test complex Python functionalities (e.g., object-oriented programming).

**Test Design:**

**1. Test Environment:**

* RStudio IDE
* `testthat` package installed
* `reticulate` package installed
* Python environment accessible from R

**2. Test Data:**

* A temporary project directory will be created.
* Python scripts will be dynamically generated within this directory.
* An R script will be used to trigger the Python code execution.

**3. Test Steps:**

1. Create a temporary project directory.
2. Create a subdirectory named "munge" to store Python and R scripts.
3. Define two python test scripts:
    * `01-test_data.py`: Imports `pandas` and `os`, creates a dataFrame `data`, writes it to a CSV file (`test_data_py.csv`) and performs a calculation (e.g., sum of a column) and prints the result.
    * `02-test_data.py`: Imports `pandas`, `os` and `sys`, reads/writes the CSV file `test_data_py.csv`) created in `01-test_data.py`, creates a dataframe `py_data`, defines a variable `subdirectory`, checks if the `subdirectory` variable exists in the python environment, passes the result to a variable `data`, prints whether `y` or `n`, writes a dynamically named dataframe either `y.csv` or `n.csv` to the `munge` subdirectory
4. Write the scripts to their respective files within the "munge" directory.
5. Use `reticulate`'s `source` function to sequentially load the Python scripts from the R Project Template package.
6. Verify if the CSV files created by the Python script exist using `except_false` and `file.exists` from the `testthat` package.
7. Verify if the python variables exist in the R environment using `except_false` from the `testthat` package.
8. Execute the python script (`01-test_data.py`) to test capturing of the Python calculation result.
9. Execute the R script (`01-test_data.R`) to test capturing of the R result tibble.
10. Execute the python script (`02-test_data.py`) to test capturing of the Python environment result.
11. Execute the R script (`02-test_data.R`) to test capturing of the R result tibble.

**4. Expected Results:**

* All alphanumerically interspersed Python and R scripts should be loaded successfully without errors.
* The Python script (`01-test_data.py`) should capture the expected result from the Python calculation and the `expect_true`, `file.exists` assertion should pass.
* The Python script (`02-test_data.py`) should capture the expected result from the Python environment and the `expect_true`, `file.exists` assertion should pass.
* The R script (`01-test_data.R`) should capture the expected result from the R calculation and the `expect_true`, `file.exists` assertion should pass.
* The R script (`02-test_data.R`) should capture the expected result from the R environment and the `expect_true`, `file.exists` assertion should pass.
* The CSV files (`test_data_py.csv`, `write_test_data_py.csv` and `y.csv`) created by the Python script should exist and the `expect_true`, `file.exists` assertion should pass.
* The CSV file (`n.csv`) should not be created by the Python script and the `expect_false`, `file.exists` assertion should pass.
* The data file (`data`) created in the (`01-test_data.py`) script should not be written to the R Environment and the `expect_false`, assertion should pass.

**5. Pass/Fail Criteria:**

* The test case passes if all expected results are met.
* The test case fails if any errors occur during Python and R script execution, file operations, or if the R assertion fails.

**Additional Considerations:**

* This test case can be further expanded to include more complex Python functionalities and error handling scenarios.
* The test script content (e.g., library imports, data manipulation) can be customized based on specific use cases.
* Ensure proper library installations and environment configurations for Python and R.

**Conclusion:** This test case demonstrates the basic functionality of running Python code interspersed with R code using `reticulate`. By successfully passing this test, we gain confidence in RStudio's ability to integrate Python code within the R environment, allowing for flexible data analysis workflows that leverage the strengths of both languages.
