#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define START_CHAR '5'
#define PAD_FILE "pad"
#define INPUT_FILE "input"

static char padLine[1024];
static char **pad;
static int w, h, _x, _y;

void
createPad()
{
    FILE *fp;
    int x, y;

    w = 0;
    h = 0;

    fp = fopen(PAD_FILE, "r");
    if (fp == NULL)
    {
        printf("Error with file %s\n", PAD_FILE);
        exit(-1);
    }

    /* find dimensions of array */
    while (fgets(padLine, 1024, fp) != NULL)
    {
        if (strlen(padLine)-1 > w)
        {
            w = strlen(padLine)-1;
        }
        h++;
    }

    rewind(fp);

    pad = malloc(w * sizeof(char*));
    if (pad == NULL)
    {
        exit(-2);
    }

    for (x = 0; x < w; x++)
    {
        if ((pad[x] = malloc(h)) == NULL)
        {
            exit(-3);
        }
    }

    for (x = 0; x < w; x++)
    {
        for (y = 0; y < h; y++)
        {
            pad[x][y] = ' ';
        }
    }

    y = 0;

    while (fgets(padLine, 1024, fp) != NULL)
    {
        x = 0;
        while (x < strlen(padLine)-1)
        {
            pad[x][y] = padLine[x];
            x++;
        }
        y++;
    }

    fclose(fp);

    for (y = 0; y < h; y++)
    {
        for (x = 0; x < w; x++)
        {
            printf("%c", pad[x][y]);
            if (pad[x][y] == START_CHAR)
            {
                _x = x;
                _y = y;
            }
        }
        printf("\n");
    }
}

int
main()
{
    FILE *fp;
    char c;
    int x,y;

    createPad();

    fp = fopen(INPUT_FILE, "r");
    if (fp == NULL)
    {
        printf("Error with file %s\n", INPUT_FILE);
        exit(-1);
    }
    
    x = _x;
    y = _y;

    do
    {
        c = fgetc(fp);
        if (feof(fp))
        {
            printf("\n");
            break;
        }
        switch (c)
        {
            case '\n':
                printf("%c", pad[x][y]);
                x = _x;
                y = _y;
                break;
            case 'U':
                if ((y != 0) && (pad[x][y-1] != ' '))
                {
                    y--;
                }
                break;
            case 'D':
                if ((y != h-1) && (pad[x][y+1] != ' '))
                {
                    y++;
                }
                break;
            case 'L':
                if ((x != 0) && (pad[x-1][y] != ' '))
                {
                    x--;
                }
                break;
            case 'R':
                if ((x != w-1) && (pad[x+1][y] != ' '))
                {
                    x++;
                }
                break;
            default:
                break;
        }
    } while(1);
             

    fclose(fp);
    return 0;
}

