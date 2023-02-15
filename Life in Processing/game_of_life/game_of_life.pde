int cell_size;
int grid_width = 120;
int grid_height = 120;
int width;
int height;
int grid[][];
int timer;
boolean is_play = false;
boolean is_cell;

void initGrid() {
  grid = new int[grid_height][grid_width];
  
  // glider
  grid[1][2] = 1;
  grid[2][3] = 1;
  grid[3][1] = 1;
  grid[3][2] = 1;
  grid[3][3] = 1;
}

void drawCells() {
  for (int y = 0; y < grid_height; y++) {
    for (int x = 0; x < grid_width; x++) {
      if (grid[y][x] == 1) {
        noStroke();
        fill(255);
        rect(x * cell_size, y * cell_size, cell_size, cell_size);
      }
    }
  }
}

void setup() {
  size(600, 600);
  width = 600;
  height = 600;
  cell_size = int(width / grid_width);
  initGrid();
}

void draw() {
  background(0);
  
  if (is_play) {
    if (millis() - timer > 50) {
      int[][] temp = new int[grid_height][grid_width];
      
      for (int y = 0; y < grid_height; y++) {
        for (int x = 0; x < grid_width; x++) {
          int around_cells = 0;
          
          for (int ay = y - 1; ay <= y + 1; ay++) {
            for (int ax = x - 1; ax <= x + 1; ax++) {
              if (ax >= 0 && ax < grid_width && ay >= 0 && ay < grid_height) {
                around_cells += grid[ay][ax];
              }
            }
          }
          
          around_cells -= grid[y][x];
          
          if (around_cells == 0 || around_cells == 1) {
            temp[y][x] = 0;
          } else if (around_cells == 2 && grid[y][x] == 1) {
            temp[y][x] = 1;
          } else if (around_cells == 3) {
            temp[y][x] = 1;
          } else {
            temp[y][x] = 0;
          }
        }
      }
      
      grid = temp;
      
      timer = millis();
    }
  }
  
  drawCells();
  
  int cellX = floor(mouseX / (width / grid_width));
  int cellY = floor(mouseY / (height / grid_height));
  
  stroke(189);
  noFill();
  rect(cellX * cell_size, cellY * cell_size, cell_size, cell_size);
  
  if (mousePressed && cellX >= 0 && cellX < grid_width && cellY >= 0 && cellY < grid_width) {
    if (is_cell) {
      grid[cellY][cellX] = 1;
    } else {
      grid[cellY][cellX] = 0;
    }
  }
}

void mousePressed() {
  int cellX = floor(mouseX / (width / grid_width));
  int cellY = floor(mouseY / (height / grid_height));
  
  if (grid[cellY][cellX] == 0) {
    is_cell = true;
  } else {
    is_cell = false;
  }
}

void keyPressed() {
  if (key == ' ') {
    is_play = !is_play;
  }
}
