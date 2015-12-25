counter = 0
while counter < 3:
    print 'loop #%d' % counter
    counter += 1

for item in ['email', 'net-surfing', 'homework', 'chat']:
    print item,
print

for eachNum in range(3):
    print eachNum,
print

#p53
foo = 'abc'
for i in range(len(foo)):
    print foo[i],'(%d)' % i

#p53
for i, ch in enumerate(foo):
    print i, (ch)
print

#p53
sequared = [x**2 for x in range(4)]
for i in sequared:
    print i,
print
