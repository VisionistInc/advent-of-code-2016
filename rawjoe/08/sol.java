import java.io.IOException;
import java.io.File;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.List;
import java.util.Arrays;
import java.lang.*;

public class sol {

    private static final int H = 6;
    private static final int W = 50;

    private static final String RECT = "rect ";
    private static final String ROTX = "rotate column x=";
    private static final String ROTY = "rotate row y=";

    private static String[] grid = new String[H];

    public static void main(String[] args) {

        List<String> lines;
    
        /* read input */
        File input = new File("./input");
        if (!input.exists()) {
            System.out.println("No input");
            return;
        }
        try {
            lines = Files.readAllLines(input.toPath(), StandardCharsets.UTF_8);
        } catch (IOException e) {
            System.out.println(e);
            return;
        }
        
        /* create empty grid */
        for (int i = 0; i < H; i++) {
            grid[i] = "";
            char[] repeat = new char[W];
            Arrays.fill(repeat, ' ');
            grid[i] += new String(repeat);
        }

        try {
            for (String line : lines) {
                if (line.startsWith(RECT)) {
                    handleRect(line.substring(RECT.length()));
                } else if (line.startsWith(ROTX)) {
                    handleRotX(line.substring(ROTX.length()));
                } else if (line.startsWith(ROTY)) {
                    handleRotY(line.substring(ROTY.length()));
                }
            }
        } catch (Exception e) {
            System.out.println(e);
            return;
        }

        printGrid();
    }

    private static void printGrid() {
        int cnt=0;
        for (int i = 0; i < H; i++) {
            System.out.println(grid[i]);
            for( int j=0; j < grid[i].length(); j++) {
                if( grid[i].charAt(j) == '*' ) {
                    cnt++;
                }
            }
        }
        System.out.println(cnt);
    }

    private static void handleRect(String cmd) throws Exception {
        String[] xy = cmd.split("x");
        int x = Integer.parseInt(xy[0]);
        int y = Integer.parseInt(xy[1]);
        
        for (int i=0; i < y; i++) {
            char[] repeat = new char[x];
            Arrays.fill(repeat, '*');
            grid[i] = new String(repeat) + grid[i].substring(x);
        }
    }

    private static void handleRotX(String cmd) {
        String[] dim = cmd.split(" by ");
        int col = Integer.parseInt(dim[0]);
        int num = Integer.parseInt(dim[1]);
        String str = "";
        for (int i = 0; i < H; i++) {
            str = str + grid[i].substring(col,col+1);
        }
        str = str.substring(H-num) + str.substring(0,H-num);
        for (int i = 0; i < H; i++) {
            grid[i] = grid[i].substring(0,col) + str.substring(i,i+1) + grid[i].substring(col+1);
        }
    }
    
    private static void handleRotY(String cmd) {
        String[] dim = cmd.split(" by ");
        int row = Integer.parseInt(dim[0]);
        int num = Integer.parseInt(dim[1]);
        grid[row] = grid[row].substring(W-num) + grid[row].substring(0,W-num);
    }

}
