def insert_sort(list):
    #Insertion Sort
    count = len(list)
    for i in range(1, count):
        key = list[i]
        j = i
        while j > 0 and key < list[j - 1]:
            list[j] = list[j - 1]
            j -= 1
        list[j] = key
        i += 1
    return list

aList=[3,5,7,2,1,9]
print aList
insert_sort(aList)
print aList

