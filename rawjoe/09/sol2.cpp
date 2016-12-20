#include <iostream>
#include <fstream>
#include <string>
#include <cstdlib>
using namespace std;

#define INPUT_FILE "input"
#define TMP_FILE "input.tmp"

ifstream input;

int
readNum(
    char stop,
    int *num)
{
    string str = "";
    char c;
    int count = 1;
    input.get(c);
    while (c != stop)
    {
        str = str + c;
        input.get(c);
        count++;
    }
    *num = atoi(str.c_str());
    return count;
}

unsigned long int
removeWhitespace()
{
    ifstream in;
    ofstream out;
    in.open(INPUT_FILE);
    out.open(TMP_FILE);
    
    unsigned long int size = 0;

    char c;
    while (in.get(c))
    {
        if (c > ' ')
        {
            size++;
            out << c;
        }
    }
    in.close();
    out.close();
    return size;
}

unsigned long int doIt (
    unsigned long int bytes
)
{
    int i = 0;
    char c;
    unsigned long int count = 0;
    while (i < bytes)
    {
        input.get(c);
        i++;
        if (c == '(')
        {
            int numChars, repeat;
            i += readNum('x', &numChars);
            i += readNum(')', &repeat);
            count = count + (repeat * doIt(numChars));
            i += numChars;
        }
        else
        {
            count++;
        }
    }
    return count;
}

int main()
{
    unsigned long int count = 0;
    unsigned long int size = removeWhitespace();

    input.open(TMP_FILE);

    count = doIt(size);
    
    input.close();

    cout << count << "\n";
    
    return 0;
}
