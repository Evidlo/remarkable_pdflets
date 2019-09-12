#!/bin/bash
# Evan Widloski - 2019-01-15
# Weather "pdflet" for reMarkable
# thanks to https://brendanzagaeski.appspot.com/0004.html

usernames="realDonaldtrump SimoneGiertz CNN"

# rendering options
font_size=12
line_wrap=80
line_height=-12

data_path=/home/root/.local/share/remarkable/xochitl
uuid=72cb311d-38d6-4518-a5dc-26cb1efaecd1

# force the page to re-render
rm $data_path/$uuid.cache/*.png

# strip/replace chars that can't go into the pdf - this is still really buggy
strip_bad_chars () {
    # we have to split substitions up because busybox sed is buggy
    sed \
        -e "s,${esc}\[[0-9;]*[a-zA-Z],,g;" \
        -e 's/┴/+/g; s/┼/+/g; s/┤/+/g; s/├/+/g; s/┘/+/g; s/┬/+/g;          # replace boxdrawing chars with ascii ones
            s/└/+/g; s/┐/+/g; s/┌/+/g; s/│/|/g; s/─/-/g; s/―/-/g;          # replace boxdrawing chars with ascii ones
            s/\\/\\\\\\/g;                                                 # escape backslash
            s/(/\\(/g; s/)/\\)/g                                           # escape parens
            s/‘/\`/g; s/’/\`/g;                                            # escape forwardtick
            s/→/ /g; s/←/ /g; s/↓/ /g; s/↑/ /g; s/↘/ /g; s/↙/ /g;          # remove special chars
            s/↗/ /g; s/°/ /g; s/…/ /g; s/↖/ /g;                            # remove special chars
'
}

for username in ${usernames}
do
    out+=" /F2 ${font_size} Tf"
    out+=" 0 ${line_height} Td (${username}) Tj"
    out+=" 0 ${line_height} Td (------------------------) Tj"
    out+=" /F1 ${font_size} Tf"

    # split long lines
    lines=$(wget -q -O /dev/stdout http://decapi.me/twitter/latest?name=${username} 2>&1 | sed "s/.\{${line_wrap}\}/&\n/g")
    while read -r line; do
        out+=" 0 ${line_height} Td ($(strip_bad_chars <<< ${line})) Tj"
    done <<< "$lines"
    out+=" 0 ${line_height} Td"
done

esc=$(printf '\033')

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
              /F2
               << /Type /Font
                  /Subtype /Type1
                  /BaseFont /Courier-Bold
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
    /F1 ${font_size} Tf
    10 700 Td
    ${out}
    0 ${line_height} Td
    0 ${line_height} Td
    (Updated $(date)) Tj
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
