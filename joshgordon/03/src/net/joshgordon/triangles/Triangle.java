package net.joshgordon.triangles;

public class Triangle {
  public int side1;
  public int side2;
  public int side3;

  public Triangle(int side1, int side2, int side3) {
    this.side1 = side1;
    this.side2 = side2;
    this.side3 = side3;
  }

  public boolean isValid() {
    return (this.side1 + this.side2 > this.side3 &&
            this.side1 + this.side3 > this.side2 &&
            this.side2 + this.side3 > this.side1);
  }
}
