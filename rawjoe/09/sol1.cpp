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
    char stop)
{
    string str = "";
    char c;
    input.get(c);
    while (c != stop)
    {
        str = str + c;
        input.get(c);
    }
    return atoi(str.c_str());
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

int
main()
{
    unsigned long int count = 0;
    removeWhitespace();
    
    input.open(TMP_FILE);
    
    char c;
    while (input.get(c))
    {
        if (c == '(')
        {
            int numChars = readNum('x');
            int repeat = readNum(')');
            for (int i = 0; i < numChars; i++)
            {
                input.get(c);
            }
            count += (numChars * repeat);
        }
        else
        {
            count++;
        }
    }
    
    input.close();

    cout << count << "\n";
    
    return 0;
}
