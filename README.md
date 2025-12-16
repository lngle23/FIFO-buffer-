# FIFO Buffer

## Overview
A synchronous First-In-First-Out (FIFO) buffer module with configurable data width and depth.

## Features
- Synchronous read and write operations
- Parameterizable data width and buffer depth
- Full and empty status flags
- Synchronous reset capability
- Prevention of overflow and underflow conditions

## Applications
- Data buffering between different clock domains
- Rate matching between producer and consumer
- Stream data management
- Communication interface buffering

## Testing
Comprehensive testbench included with 10 test cases covering:
- Basic read/write operations
- Full and empty conditions
- Simultaneous read/write
- Reset behavior
- Edge cases and boundary conditions
