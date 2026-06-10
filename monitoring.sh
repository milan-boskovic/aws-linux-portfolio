#!/bin/bash
echo "=== MEMORY ==="
free -h
echo "=== DISK ==="
df -h 
echo "=== CPU ==="
top -bn1 | grep "Cpu"
