def bubble_sort(list):
    #bubble sort
    finish = False
    count = len(list)
    while finish == False:
        finish = True
        for i in range(0, count - 1):
            if list[i] > list[i+1]:
                finish = False
                list[i], list[i+1] = list[i+1], list[i]
        count -= 1

    for i in range(0, count):
        for j in range(i + 1, count):
            if list[i] > list[j]:
                list[i], list[j] = list[j], list[i]


aList=[3,5,7,2,1,9]
bubble_sort(aList)
print aList