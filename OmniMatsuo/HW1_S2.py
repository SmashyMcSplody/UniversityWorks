# 1. Import libraries
import numpy as np
# 2. Define a 1D NumPy array
a = np.array([1, 5, 10, 3, 4, 25, 30])

def homework(a):
    my_result = a[(a % 2 == 1) & (a % 5 == 0)]
    return my_result

# Run this cell after completing homework().
your_answer = homework(a)
print("Your answer:", your_answer)

case_2_input = np.array([11, 15, 20, 21, 35, 40, 45])
case_2_answer = homework(case_2_input)
print("Your answer:", case_2_answer)

case_3_input = np.array([2, 4, 6, 8])
case_3_answer = homework(case_3_input)
print("Your answer:", case_3_answer)