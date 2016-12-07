import hashlib
import sys

class hasher():
    def __init__(self, doorID):
        self.doorID = doorID


    def hash(self, num):
        m = hashlib.md5()
        m.update(self.doorID + str(num))
        return m.hexdigest()

h = hasher(sys.argv[1])
password = []
count = 0
while True:
    digest = h.hash(count)
    if digest[0:5] == "00000":
        password.append(digest[5])
        print digest
    if len(password) == 8:
        break
    count +=1

print ''.join(password)
