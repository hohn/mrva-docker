set xdata time
set timefmt "%s"
set format x "%H:%M"
set xlabel "Time"
set ylabel "CPU %"
set title "Top 3 CPU values per snapshot"
set grid
set key outside

plot "cpu-top-3-agents-1-2025-08-11.dat" using 1:2 with lines title "Top 1", \
"" using 1:3 with lines title "Top 2", \
"" using 1:4 with lines title "Top 3"

pause -1
