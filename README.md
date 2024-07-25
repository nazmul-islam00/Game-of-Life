# Game-of-Life

### Conway's game of life made using Lua & LÖVE. 
### The rules have been modified as follows
- Any live cell with no neighbors dies due to underpopulation.
- Any live cell with more than 5 neighbors dies due to overpopulation.
- Any live cell at the border of the grid dies.
- Any dead cell with more than 3 neighbors becomes alive.
- Other cells remain as they are.
### Move into the working directory and run the following:
```shell
love .
```
 
