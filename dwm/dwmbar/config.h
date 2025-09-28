#ifndef CONFIG_H
#define CONFIG_H
#define ENABLE_COLOR 1

#define DELIMITER "  "
#define MAX_BLOCK_OUTPUT_LENGTH 45
#define CLICKABLE_BLOCKS 1
#define LEADING_DELIMITER 0
#define TRAILING_DELIMITER 0

#define BLOCKS(X)                             \
    X(" ", "./blocks/ram", 5, 4)                 \
    X("󰻠 ", "./blocks/cpu", 5, 3)                 \
    X("󰃟 ", "./blocks/brightness", 10, 6)         \
    X(" ", "./blocks/volume", 5, 2)              \
    X("󰆼 ", "./blocks/disk", 60, 5)               \
    X("󱇻 ", "./blocks/clock", 60, 7)              \
    X("󰁹 ", "./blocks/battery", 30, 1)

#endif  // CONFIG_H
