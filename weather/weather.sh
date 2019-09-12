#!/bin/bash
# Evan Widloski - 2019-01-15
# Weather "pdflet" for reMarkable
# thanks to https://brendanzagaeski.appspot.com/0004.html

data_path=/home/root/.local/share/remarkable/xochitl

uuid=a6ab69e5-27b4-4606-8c82-1ca591333107

# force the page to re-render
rm $data_path/$uuid.cache/*.png

esc=$(printf '\033')
# we have to split substitions up because busybox sed is buggy
out=$(wget -q -O /dev/stdout http://wttr.in 2>&1 |
    sed -e "s,${esc}\[[0-9;]*[a-zA-Z],,g;" \
        -e 's/┴/+/g; s/┼/+/g; s/┤/+/g; s/├/+/g; s/┘/+/g; s/┬/+/g;          # replace boxdrawing chars with ascii ones
            s/└/+/g; s/┐/+/g; s/┌/+/g; s/│/|/g; s/─/-/g; s/―/-/g;          # replace boxdrawing chars with ascii ones
            s/\\/\\\\\\/g;                                                 # escape backslash
            s/(/\\(/g; s/)/\\)/g                                           # escape parens
            s/‘/\`/g; s/’/\`/g;                                            # escape forwardtick
            s/\(.*\)/0 -9 Td (\1) Tj/g                                     # render newlines
            s/→/ /g; s/←/ /g; s/↓/ /g; s/↑/ /g; s/↘/ /g; s/↙/ /g;          # remove special chars
            s/↗/ /g; s/°/ /g; s/…/ /g; s/↖/ /g; s/‚/,/g; s/⚡/ /g;         # remove special chars
')

echo "$out"

cat > $data_path/$uuid.pdf <<EOF
%PDF-1.1
%¥±ë

1 0 obj
  << /Type /Catalog
     /Pages 2 0 R
  >>
endobj

2 0 obj
  << /Type /Pages
     /Kids [3 0 R]
     /Count 1
     /MediaBox [0 0 612 792]
  >>
endobj

3 0 obj
  <<  /Type /Page
      /Parent 2 0 R
      /Resources
       << /Font
           << /F1
               << /Type /Font
                  /Subtype /Type1
                  /BaseFont /Courier
               >>
           >>
       >>
      /Contents 4 0 R
  >>
endobj

4 0 obj
  << /Length 55 >>
stream
  BT
    /F1 8 Tf
    0 700 Td
    ${out}
    0 -9 Td (Updated $(date)) Tj
  ET
endstream
endobj

xref
0 5
0000000000 65535 f 
0000000018 00000 n 
0000000077 00000 n 
0000000178 00000 n 
0000000457 00000 n 
trailer
  <<  /Root 1 0 R
      /Size 5
  >>
startxref
565
%%EOF
EOF
