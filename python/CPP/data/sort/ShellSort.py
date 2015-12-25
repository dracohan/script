def ShellSort(list):
    #Shell Sort
    count = len(list)
    gap = count/2
    while gap > 0:
        i = gap
        while i < count:
            key = list[i]
            j = i
            while j >= gap and key < list[j-gap]:
                list[j] = list[j - gap]
                j -= gap
            list[j] = key
            i += 1
        gap /= 2
aList=[3,5,7,2,1,9]
ShellSort(aList)
print aList
