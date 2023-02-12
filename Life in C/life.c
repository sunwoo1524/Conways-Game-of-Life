#include <stdio.h>
#include <stdlib.h> // 난수 생성 함수
#include <time.h> // 난수 시드 생성 용
#include <stdbool.h> // C에는 논리 자료형이 없기 때문에 헤더파일을 따로 선언해야 쓸 수 있다.
#include <windows.h> // gotoxy 함수를 쓰기 위해 선언

#define COL 30
#define ROW 25

int grid[ROW][COL];
int next[ROW][ROW]; // 연산을 위한 grid 복제 배열
int speed = 500; // 실행 속도, 밀리초 단위

void gotoxy(int x, int y) {
    COORD pos = { x * 2, y }; // x를 두배로 해서 x좌표에 빈 공간 주기
    SetConsoleCursorPosition(GetStdHandle(STD_OUTPUT_HANDLE), pos);
}

void setGrid() {
    srand(time(NULL));

    for (int i = 0; i < 500; i++) {
        int j = rand() % COL;
        int k = rand() % ROW;

        grid[k][j] = 1;
    }

    /* 팽이
    grid[4][4] = 1;
    grid[3][4] = 1;
    grid[5][4] = 1;
    grid[4][3] = 1;
    grid[4][5] = 1;
    */
}

void drawGrid() {
    for (int y = 0; y < ROW; y++) {
        for (int x = 0; x < COL; x++) {
            if (grid[y][x] == 1) {
                gotoxy(x, y);
                printf("#");
            }
        }
    }
}

void operate() {
    // grid를 next에 복사
    for (int y = 0; y < ROW; y++) {
        for (int x = 0; x < COL; x++) {
            next[y][x] = grid[y][x];
        }
    }

    //연산
    for (int y = 0; y < ROW; y++) {
        for (int x = 0; x < COL; x++) {
            // 세포의 주변 8칸에 살아있는 세포 개수 찾기
            int cells_number = 0;

            if (x - 1 >= 0 && y - 1 >= 0) { // LT
                if (grid[y - 1][x - 1] == 1) {
                    cells_number++;
                }
            }
            
            if (y >= 0) { // T
                if (grid[y - 1][x] == 1) {
                    cells_number++;
                }
            }
            
            if (x < COL && y >= 0) { // RT
                if (grid[y - 1][x + 1] == 1) {
                    cells_number++;
                }
            }
            
            if (x >= 0) { // L
                if (grid[y][x - 1] == 1) {
                    cells_number++;
                }
            }
            
            if (x < COL) { // R
                if (grid[y][x + 1] == 1) {
                    cells_number++;
                }
            }
            
            if (x >= 0 && y < ROW) { // LB
                if (grid[y + 1][x - 1] == 1) {
                    cells_number++;
                }
            }
            
            if (y < ROW) { // B
                if (grid[y + 1][x] == 1) {
                    cells_number++;
                }
            }
            
            if (x < COL && y < ROW) { // RB
                if (grid[y + 1][x + 1] == 1) {
                    cells_number++;
                }
            }

            // 세포 생성 또는 삭제 또는 유지
            if (cells_number <= 1) {
                next[y][x] = 0;
            } else if (cells_number == 3) {
                next[y][x] = 1;
            } else if (cells_number >= 4) {
                next[y][x] = 0;
            }
        }
    }

    // next를 grid에 복사
    for (int y = 0; y < ROW; y++) {
        for (int x = 0; x < COL; x++) {
            grid[y][x] = next[y][x];
        }
    }
}

int main() {
    setGrid();

    system("cls");
    drawGrid();
    Sleep(speed);

    while (true) {
        system("cls");
        operate();
        drawGrid();
        Sleep(speed);
    }

    return 0;
}
