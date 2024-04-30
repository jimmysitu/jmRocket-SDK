#!/bin/bash

# Function to handle the interrupt signal (SIGINT)
cleanup() {
    echo "Caught Interrupt. Killing spike and openocd..."
    echo "spike pid: $pid1"
    echo "openocd pid: $pid2"

    kill -KILL $pid1
    
    # Kill openocd
    kill -KILL $pid2
    
    # FIXME: Send 'quit' to spike, assuming it's waiting for input
    #printf 'quit\n' > /proc/$pid1/fd/0
    #kill -KILL $pid1
    
    exit 0
}

# Set the trap to call the cleanup function when SIGINT is received
trap 'cleanup' SIGINT

# Run spike in the background as usual
spike --rbb-port=9824 -m0x80000000:0x40000 ../dummy.riscv &
pid1=$!

sleep 1

# Run openocd in the background as usual
openocd -f spike.cfg &
pid2=$!

# Wait for both commands to finish
wait $pid1 $pid2
