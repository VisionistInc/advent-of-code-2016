package net.joshgordon.triangles;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;

public class Test {

  public static void main(String[] args) {
    Triangle test = new Triangle(5, 10, 25);
    System.out.println(test.isValid());
    
    ArrayList<Triangle> triangles = new ArrayList<Triangle>();
    try (BufferedReader br = new BufferedReader(new FileReader(args[0]))) {
    	String line;
    	while ((line = br.readLine()) != null) {
    		String[] numbers = line.split("\\s+");
    		Triangle triangle = new Triangle(Integer.parseInt(numbers[1]), Integer.parseInt(numbers[2]), Integer.parseInt(numbers[3]));
    		triangles.add(triangle);
    	}
    } catch (FileNotFoundException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	} catch (IOException e) {
		// TODO Auto-generated catch block
		e.printStackTrace();
	}

    int valid = 0;
    int invalid = 0;
    for (int ii = 0; ii < triangles.size(); ii++) {
    	if (triangles.get(ii).isValid()) {
    		valid++;
    	} else {
    		invalid ++;
    	}
    	
    }
	System.out.format("Valid: %d\n", valid);
	System.out.format("Invaid: %d\n", invalid);

  }
}
