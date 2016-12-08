from collections import Counter
import regex as re
import sys
from operator import add

words = re.compile(r"[\w]+")
abba = re.compile(r"(.)(?!\1)(.)\2\1")
aba = re.compile(r"(.)(?!\1)(.)\1")

class IPv7Address():
    def __init__(self, address):
        # Break each IP up into the chunks inside and outside the square
        # brackets.
        self.outside_squares = []
        self.inside_squares = []
        chunks = words.findall(address)
        for i in range(len(chunks)):
            if i % 2 == 0:
                self.outside_squares.append(chunks[i])
            else:
                self.inside_squares.append(chunks[i])

    def is_TLS_capable(self):
        # TLS Capable = abba outside squares but not inside the squares.
        abba_outside = [bool(abba.search(word)) for word in self.outside_squares]
        abba_inside = [bool(abba.search(word)) for word in self.inside_squares]
        return any(abba_outside) and not any(abba_inside)


    def is_SSL_capable(self):
        # SSL capable = aba outside squares and bab inside.

        # find all the aba sequences.
        aba_outside = [aba.findall(word, overlapped=True) for word in self.outside_squares]
        aba_inside = [aba.findall(word, overlapped=True) for word in self.inside_squares]
        # flatten the lists
        aba_outside = reduce(add, aba_outside, [])
        aba_inside = reduce(add, aba_inside, [])
        # flip the matches for inside => aba <=> bab
        aba_inside = [(k,v) for (v,k) in aba_inside]
        # go over the inside pairs and see if there's any matches outside.
        for pair in aba_inside:
            if pair in aba_outside:
                return True
        return False


addresses = []
with open(sys.argv[1]) as f:
    for line in f:
        addresses.append(IPv7Address(line.strip()))

tls_capable = [ip.is_TLS_capable() for ip in addresses]
print "TLS Capable:", Counter(tls_capable)

ssl_capable = [ip.is_SSL_capable() for ip in addresses]
print "SSL Capable:", Counter(ssl_capable)
