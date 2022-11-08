// 生成循环的7x7的patch

#include <stdio.h>
#define COL 30    // 总共生成COL列ROW行的数据
#define ROW 20
#define PATCH_SIZE 7 // 7x7的patch

char patch_data[][PATCH_SIZE] = {{0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07}, \
                                 {0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17}, \
                                 {0x21, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27}, \
                                 {0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37}, \
                                 {0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47}, \
                                 {0x51, 0x52, 0x53, 0x54, 0x55, 0x56, 0x57}, \
                                 {0x61, 0x62, 0x63, 0x64, 0x65, 0x66, 0x67}};

int main() {
    int i, j;

    FILE *fpWrite = fopen("F:\\FPGA_prj\\Fast_ref\\FPGA-FAST\\tb\\tb_data.txt", "w");
    if (fpWrite == NULL) {
        printf("failed to open file");
        return 0;
    }

    for (i=0; i<ROW; i++) {
        for (j=0; j<COL; j++) {
            fprintf(fpWrite, "%02X\r", patch_data[i%7][j%7]);
        }
    }
}