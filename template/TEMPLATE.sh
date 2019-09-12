#!/bin/bash
# Evan Widloski - 2019-01-15
# Sample pdflet

uuid=UUID

data_path=/home/root/.local/share/remarkable/xochitl

# force the page to re-render
rm $data_path/$uuid.cache/*.png

# command output to show on pdf.  include any errors
out=$(echo hello world 2>&1)

# also show result in systemd
echo "$out"

# rendering options
font_size=12
line_wrap=80
line_height=-12

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
    (${out}) Tj
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
