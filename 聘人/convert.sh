function 健康(){
  echo 健康
  convert "*.jpg" -resize 3612x5125 -quality 1 x-健康聲明書.pdf
}

function 健康s(){
  echo 健康s
  for d in */
  do
    [ -L "${d%/}" ] && continue
    echo "$d"
    convert "${d}*.jpg" -resize 3612x5125 -quality 1 "$(echo $d | cut -d '/' -f 1)-健康聲明書.pdf"
  done
}

function 型態(){
  echo 型態
  convert 1.jpg -quality 1 x-型態.pdf
}

function 型態-all(){
  echo "全部ㄉ型態"
  for i in ./*.jpg
  do
    basename "$i" | cut -d "." -f 1
    convert "$i" -quality 1 "$(basename $i | cut -d "." -f 1)-型態.pdf"
  done
}

function 學習(){
  echo 學習
  convert "*.jpg" -quality 5 x-學習指導實施計劃.pdf
}
