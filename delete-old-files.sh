#!/usr/bin/env bash

# Delete PNG files older than 15 months
# Usage: ./delete_old_pngs.sh [directory] [--dry-run] [--verbose]

DIRECTORY=""
DRY_RUN=false
VERBOSE=false
MONTHS=20
DAYS=$((MONTHS * 30))  # Calculate days from months (approximate)

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --verbose|-v)
            VERBOSE=true
            shift
            ;;
        -*)
            echo "Unknown option $1"
            exit 1
            ;;
        *)
            DIRECTORY="$1"
            shift
            ;;
    esac
done

# Default to current directory if not specified
if [[ -z "$DIRECTORY" ]]; then
    DIRECTORY="."
fi

# Check if directory exists
if [[ ! -d "$DIRECTORY" ]]; then
    echo "Error: Directory '$DIRECTORY' does not exist"
    exit 1
fi

echo "Looking for PNG files older than $MONTHS months in: $DIRECTORY"

if [[ "$DRY_RUN" == true ]]; then
    echo "DRY RUN - files that would be deleted:"
    find "$DIRECTORY" -name "*.png" -mtime +$DAYS -print
else
    # Count files before deletion
    count=$(find "$DIRECTORY" -name "*.png" -mtime +$DAYS | wc -l)

    if [[ $count -eq 0 ]]; then
        echo "No PNG files older than $MONTHS months found"
        exit 0
    fi

    echo "Found $count PNG file(s) older than $MONTHS months"

    # Delete files
    if [[ "$VERBOSE" == true ]]; then
        find "$DIRECTORY" -name "*.png" -mtime +$DAYS -print -delete
    else
        find "$DIRECTORY" -name "*.png" -mtime +$DAYS -delete
    fi

    echo "Deleted $count PNG file(s)"
fi
