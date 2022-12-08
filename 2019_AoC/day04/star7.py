lower_bound = 138241
upper_bound = 674034
number = lower_bound
counter = 0

while number < 674034:
    str_n = str(number)

    condition1 = (str_n[0] == str_n[1] or str_n[1] == str_n[2] or str_n[2] == str_n[3] or str_n[3] == str_n[4] or
                  str_n[4] == str_n[5])
    condition2 = (str_n[0] <= str_n[1] <= str_n[2] <= str_n[3] <= str_n[4] <= str_n[5])

    if condition1 and condition2:
        counter += 1

    number += 1

print(counter)