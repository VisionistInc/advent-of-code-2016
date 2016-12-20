import std.stdio;
import std.digest.md;

enum string SALT = "hhhxzeay";

enum int U = 0;
enum int D = 1;
enum int L = 2;
enum int R = 3;

enum int X = 0;
enum int Y = 1;
enum int PATH = 2;

enum int MIN = 0;
enum int MAX = 3;

struct state { int x; int y; string path = "";}

void main()
{
	int moves = 0;
	int longest = 0;
	string longestPath = "";

	state[] now = [{0, 0, ""}];

	while (now.length > 0)
	{
		state[] next = [];
		int i = 0;
		while (i < now.length)
		{
			if ((now[i].x == MAX) && (now[i].y == MAX))
			{
				if (longest == 0)
				{
					writeln("Shortest path is: ");
	                writeln(now[i].path);
    	            writeln(moves);
    	        }
    	        longest = moves;
    	        longestPath = now[i].path;
    	        i++;
    	        continue;
			}

			string tmp = SALT ~ now[i].path;
			auto md5 = new MD5Digest();
			tmp = toHexString(md5.digest(tmp));

	        if ((now[i].x > MIN) && (tmp[L] > 'A'))
	        {
    	        state newstate = {now[i].x-1, now[i].y, now[i].path~"L"};
				next ~= newstate;
			}

	        if ((now[i].x < MAX) && (tmp[R] > 'A'))
	        {
    	        state newstate = {now[i].x+1, now[i].y, now[i].path~"R"};
				next ~= newstate;
			}

	        if ((now[i].y > MIN) && (tmp[U] > 'A'))
	        {
    	        state newstate = {now[i].x, now[i].y-1, now[i].path~"U"};
				next ~= newstate;
			}

	        if ((now[i].y < MAX) && (tmp[D] > 'A'))
	        {
    	        state newstate = {now[i].x, now[i].y+1, now[i].path~"D"};
				next ~= newstate;
			}
			i++;
		}

		now = next;
		moves++;
	}

	writeln("Longest path is:");
	writeln(longestPath);
	writeln(longest);
}

