#!/bin/bash

# Check if PDF directory argument is provided
PDF_DIR=${1:-"/home/ubertobarbini/ebooks"}

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo "Starting PDF Viewer setup check..."

# Check if PDF directory exists
if [ ! -d "$PDF_DIR" ]; then
    echo -e "${RED}Error: PDF directory '$PDF_DIR' does not exist${NC}"
    exit 1
fi

# Create necessary directories
mkdir -p priv/static/pdfs
mkdir -p priv/static/pdf_images

# Clean and link PDF directory
rm -f priv/static/pdfs/*
ln -sf "$PDF_DIR"/* priv/static/pdfs/

# Check dependencies
echo "Checking dependencies..."
if ! mix deps.get; then
    echo -e "${RED}Error: Failed to get dependencies${NC}"
    exit 1
fi

# Compile the project
echo "Compiling project..."
if ! mix compile; then
    echo -e "${RED}Error: Failed to compile project${NC}"
    exit 1
fi

# Count available PDFs
PDF_COUNT=$(ls -1 priv/static/pdfs/*.pdf 2>/dev/null | wc -l)
if [ $PDF_COUNT -eq 0 ]; then
    echo -e "${RED}Warning: No PDF files found in $PDF_DIR${NC}"
    exit 1
else
    echo -e "${GREEN}Found $PDF_COUNT PDF files${NC}"
fi

# Start the Phoenix server
echo -e "${GREEN}Starting Phoenix server...${NC}"
echo "You can view PDFs at: http://localhost:4000/pdf/view/1"
mix phx.server 