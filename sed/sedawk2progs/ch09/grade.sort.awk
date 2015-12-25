# grade.sort.awk -- script for sorting student grades
# input: student name followed by a series of grades

# sort function -- sort numbers in ascending order
function sort(ARRAY, ELEMENTS, 	temp, i, j) {
	for (i = 2; i <= ELEMENTS; ++i) 
		for (j = i; (j-1) in ARRAY && ARRAY[j-1] > ARRAY[j]; --j) { 
			temp = ARRAY[j]
			ARRAY[j] = ARRAY[j-1]
			ARRAY[j-1] = temp
	}
	return 
}

# main routine
{ 
# loop through fields 2 through NF and assign values to
# array named grades
for (i = 2; i <= NF; ++i)
	grades[i-1] = $i 

# call sort function to sort elements

sort(grades, NF-1)

# print student name
printf("%s: ", $1)

# output loop
for (j = 1; j <= NF-1; ++j)
	printf("%d ", grades[j])
printf("\n")
}
