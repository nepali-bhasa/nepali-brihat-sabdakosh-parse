set -e

if [ -z "$1" ]; then
    echo "Specify pdf to be extracted!"
    exit 1
fi

current=$(dirname $0)
tmp="$current/tmp"

mkdir "$tmp" -p

# Crop pdf
echo "STEP: crop pdf"
echo "Started"
./crop.py "$1" "$tmp/cropped.pdf"
echo "Completed"

# Convert pdf to html
echo "STEP: extract pdf"
echo "Started"
pdf2txt.py -o "$tmp/cropped.html" -t html "$tmp/cropped.pdf"
echo "Completed"

# Tidy html
echo "STEP: tidy html"
echo "Started"
# NOTE: tidy return 1 on warning so just ignoring the return code
tidy -o "$tmp/tidy.html" -config "$current/tidyconf.txt" "$tmp/cropped.html" || echo ""
echo "Completed"

# Split large html into manageable chunks
echo "STEP: create html chunk"
echo "Started"
chunks="$tmp/chunks"
mkdir "$chunks" -p
csplit -n 5 -f "$chunks/" "$tmp/tidy.html" '/Page [0-9]/-1' '{*}'
echo "Completed"

# Add .html extension to chunks
echo "STEP: rename html chunk"
echo "Started"
cd "$chunks"
for f in *; do mv $f `basename $f `.html; done;
echo "Completed"
