from __future__ import print_function
import hashlib
import signal
import pickle
import sys


class hasher():
    def __init__(self, doorID):
        self.doorID = doorID


    def hash(self, num):
        m = hashlib.md5()
        m.update(self.doorID + str(num))
        return m.hexdigest()

class Spinner():
    chars = ['|', '/', '-', '\\']
    pos = 0
    def spin(self):
        self.pos += 1
        self.pos %= len(self.chars)
        return self.chars[self.pos]

def print_password(spinner, password, count):
    pw_string = [char if char is not None else '_' for char in password]
    print("\r[%10d] %8s %s" % (count, ''.join(pw_string), spinner.spin()), end='')

h = hasher(sys.argv[1])
password = [None] * 8
count = 0
spinner = Spinner()

try:
    with open("progress.dat", 'rb') as f:
        progress = pickle.load(f)
    count = progress[sys.argv[1]]['count']
    password = progress[sys.argv[1]]['password']
except:
    pass

# handle ctrl-c nicely
def signal_handler(signal, frame):
    print("Saving progres....")
    with open("progress.dat", "rb") as f:
        data = pickle.load(f)
    data[sys.argv[1]] = {'count': count, 'password': password}
    with open("progress.dat", "wb") as f:
        pickle.dump(data, f)
    sys.exit(0)

signal.signal(signal.SIGINT, signal_handler)

while True:
    digest = h.hash(count)
    if digest[0:5] == "00000":
        try:
            pos = int(digest[5])
            if pos < 8:
                if password[pos] == None:
                    password[pos] = digest[6]
        except:
            pass
    if len([char for char in password if char == None ]) == 0:
        break
    count +=1
    if count % 263 == 0:
        print_password(spinner, password, count)
print()

print (''.join(password))

