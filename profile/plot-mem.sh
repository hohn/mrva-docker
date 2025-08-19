awk 'NF >= 5 && $1 ~ /^[0-9]+$/ && $3 ~ /^[0-9.]+$/ {
    print $1, $4
}' mem-usage-2025-08-11.dat.log > mem-usage-2025-08-11.dat

cat >> /tmp/gnuplot$$ <<eof
set xdata time
set timefmt "%s"
set format x "%H:%M:%S"
set xlabel "Time"
set ylabel "RES (KiB)"
set title "Resident Memory Over Time"
set grid
plot "mem-usage-2025-08-11.dat" using 1:2 with lines title "RSS"
pause -1
eof

gnuplot /tmp/gnuplot$$
