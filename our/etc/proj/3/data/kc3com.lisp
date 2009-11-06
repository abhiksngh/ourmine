#|@relation shared_KC3

@attribute loc               numeric
@attribute v(g)              numeric
@attribute ev(g)             numeric
@attribute iv(g)             numeric
@attribute v                 numeric
@attribute l                 numeric
@attribute d                 numeric
@attribute i                 numeric
@attribute e                 numeric
@attribute b                 numeric
@attribute t                 numeric
@attribute lOCode            numeric
@attribute lOComment         numeric
@attribute locCodeAndComment numeric
@attribute uniq_Op           numeric
@attribute uniq_Opnd         numeric
@attribute total_Op          numeric
@attribute total_Opnd        numeric
@attribute branchCount       numeric
@attribute defects {false) true)}
|#

(defun kc3com ()
  (table-update (table-deep-copy (data
   :name 'kc3com
   :columns '($loc $vg $ivg $v $l $d $e $b $t $lOCode $lOCcomment $locCodeAndComment $uniq_Op $uniq_Opnd $total_Op $total_Opnd $branchCount defects)
   :egs
   '( 
(3 3 0 1 0 3 85.59 0.01 1 9 1 4 6 3 6 4.75 1 false)
(11 21 0 3 0 11.38 3010.96 0.09 1 57 3 13 13 12 36 167.28 5 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(3 2 0 1 0 2.5 49.13 0.01 1 7 1 4 5 2 5 2.73 1 false)
(58 92 0 10 2 23.96 39892.13 0.56 5 269 8 66 25 48 177 2216.23 18 false)
(6 11 0 1 0 6.19 834.61 0.04 1 33 1 7 9 8 22 46.37 1 false)
(6 20 0 1 0 7.86 1605.45 0.07 1 44 1 9 11 14 24 89.19 1 false)
(9 10 0 2 0 8.57 1092.32 0.04 1 30 1 10 12 7 20 60.68 3 false)
(3 3 0 1 0 3 85.59 0.01 1 9 1 4 6 3 6 4.75 1 false)
(8 18 0 4 0 14 2976.5 0.07 1 47 3 10 14 9 29 165.36 7 false)
(0 0 0 1 0 0 0 0 1 1 1 1 1 0 1 0 1 false)
(71 139 0 11 0 19.86 48468.15 0.81 7 385 11 78 18 63 246 2692.68 19 false)
(4 2 0 1 0 3.5 133.14 0.01 1 12 1 5 7 2 10 7.4 1 false)
(7 18 0 2 5 11.7 2752.14 0.08 1 52 2 16 13 10 34 152.9 3 false)
(34 68 0 7 8 20.4 22864.72 0.37 1 193 6 53 21 35 125 1270.26 12 false)
(18 30 0 5 1 14.25 6778.53 0.16 3 90 3 20 19 20 60 376.58 8 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(14 17 0 3 0 9.21 2266.4 0.08 3 53 3 15 13 12 36 125.91 5 false)
(19 66 0 2 0 17.22 14395 0.28 1 163 2 20 12 23 97 799.72 3 false)
(22 31 1 4 0 13.68 6017.65 0.15 1 88 3 28 15 17 57 334.31 6 true)
(27 54 0 5 1 14.04 10683.73 0.25 1 145 4 30 13 25 91 593.54 6 true)
(3 4 0 1 0 7 266.27 0.01 1 12 1 4 7 2 8 14.79 1 false)
(3 2 0 1 0 3 72 0.01 1 8 1 4 6 2 6 4 1 false)
(25 50 0 6 0 25 18875 0.25 1 151 6 29 16 16 101 1048.61 11 false)
(9 24 0 2 1 11.2 3645.43 0.11 1 67 2 12 14 15 43 202.52 3 false)
(8 14 0 2 0 10.5 1679.07 0.05 1 37 2 10 12 8 23 93.28 3 false)
(52 137 0 10 0 27.14 59492.48 0.73 5 353 10 59 21 53 216 3305.14 18 false)
(5 13 0 1 1 5.85 820.06 0.05 1 33 1 9 9 10 20 45.56 1 false)
(4 11 0 2 0 6.72 871.59 0.04 1 30 2 6 11 9 19 48.42 3 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(4 4 0 1 0 4 215.1 0.02 1 15 1 5 8 4 11 11.95 1 false)
(43 58 1 10 4 16.11 15290.22 0.32 1 176 8 52 15 27 118 849.46 15 false)
(10 6 1 3 0 7.2 853.46 0.04 1 29 2 11 12 5 23 47.41 4 false)
(7 5 0 1 0 5 304.72 0.02 1 17 1 8 8 4 12 16.93 1 false)
(14 20 0 3 0 8.13 2486.68 0.1 1 63 2 17 13 16 43 138.15 4 false)
(82 232 1 18 27 43.69 178710.34 1.36 10 608 15 121 29 77 376 9928.35 34 false)
(0 3 0 1 0 3 85.59 0.01 1 9 1 1 6 3 6 4.75 1 false)
(8 14 0 2 0 10.5 1679.07 0.05 1 37 2 10 12 8 23 93.28 3 false)
(5 12 0 1 0 4.2 463.52 0.04 1 27 1 6 7 10 15 25.75 1 false)
(39 82 0 11 2 22 29456.04 0.45 1 224 8 44 22 41 142 1636.45 20 false)
(10 6 1 3 0 7.2 853.46 0.04 1 29 2 11 12 5 23 47.41 4 false)
(17 56 0 2 1 14 9816.39 0.23 1 139 2 24 11 22 83 545.36 3 false)
(66 161 0 9 1 23.48 64177.21 0.91 4 418 7 81 21 72 257 3565.4 14 false)
(6 3 0 1 0 6 279.04 0.02 1 14 1 7 8 2 11 15.5 1 false)
(6 11 0 1 0 8.25 999.19 0.04 1 31 1 7 9 6 20 55.51 1 false)
(17 47 1 3 2 14.69 9703.67 0.22 1 125 1 25 15 24 78 539.09 5 false)
(8 18 0 2 1 8.18 1796.86 0.07 1 50 2 12 10 11 32 99.83 3 false)
(12 28 0 2 0 8.24 2819.37 0.11 1 72 2 13 10 17 44 156.63 3 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(14 20 0 3 0 9.17 2197.7 0.08 1 53 3 18 11 12 33 122.09 4 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(21 64 0 2 4 11.08 8806.58 0.27 1 155 2 35 9 26 91 489.25 3 false)
(5 12 0 1 0 4.2 463.52 0.04 1 27 1 6 7 10 15 25.75 1 false)
(5 13 0 1 0 3.55 434.76 0.04 1 30 1 8 6 11 17 24.15 1 false)
(3 3 0 1 0 3 85.59 0.01 1 9 1 4 6 3 6 4.75 1 false)
(0 3 0 1 0 3 85.59 0.01 1 9 1 1 6 3 6 4.75 1 false)
(13 15 0 4 0 11.25 2664.41 0.08 1 51 3 14 15 10 36 148.02 6 false)
(4 3 0 1 1 6 239.18 0.01 1 12 1 6 8 2 9 13.29 1 false)
(3 2 0 1 0 3 72 0.01 1 8 1 4 6 2 6 4 1 false)
(0 1 0 1 0 1.5 12 0 1 4 1 1 3 1 3 0.67 1 false)
(67 109 0 10 1 27.99 51033.62 0.61 1 314 9 75 19 37 205 2835.2 18 false)
(13 16 0 4 0 13.71 3029.38 0.07 1 52 4 15 12 7 36 168.3 7 false)
(2 1 0 1 0 2.5 38.77 0.01 1 6 1 3 5 1 5 2.15 1 false)
(2 0 0 1 0 0 0 0 1 1 1 3 1 0 1 0 1 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(29 57 0 4 4 16.63 12999.77 0.26 1 149 3 38 14 24 92 722.21 5 false)
(6 16 0 1 0 6.15 1141.33 0.06 1 41 1 7 10 13 25 63.41 1 true)
(22 43 0 6 2 19.55 13490.6 0.23 1 128 5 31 20 22 85 749.48 11 false)
(19 27 0 4 0 13.5 5332.5 0.13 3 79 3 22 16 16 52 296.25 6 false)
(7 17 0 1 0 7.65 1397.36 0.06 1 43 1 9 9 10 26 77.63 1 false)
(4 4 0 1 0 2 66 0.01 1 11 1 5 4 4 7 3.67 1 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(21 63 0 1 4 10.02 7011.39 0.23 1 144 1 33 7 22 81 389.52 1 false)
(43 58 1 14 4 27.62 27226.57 0.33 6 184 12 57 20 21 126 1512.59 27 true)
(12 20 0 3 0 9.23 2229.05 0.08 1 52 3 14 12 13 32 123.84 5 false)
(4 4 0 1 0 2.67 67.38 0.01 1 9 1 5 4 3 5 3.74 1 false)
(64 116 0 9 0 20.71 38301.26 0.62 1 317 9 80 15 42 201 2127.85 13 false)
(10 47 0 1 0 6.85 3871.09 0.19 1 114 1 13 7 24 67 215.06 1 false)
(5 12 0 1 0 4.2 463.52 0.04 1 27 1 6 7 10 15 25.75 1 false)
(118 235 1 25 8 32.85 154013.92 1.56 8 680 23 151 26 93 445 8556.33 45 false)
(5 11 0 1 0 5.5 756.84 0.05 1 33 1 8 9 9 22 42.05 1 false)
(10 35 0 1 2 8.37 3534.13 0.14 1 83 1 16 11 23 48 196.34 1 false)
(4 8 0 1 0 5.33 406.12 0.03 1 20 1 5 8 6 12 22.56 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(11 34 0 3 1 13.6 5496.65 0.13 3 85 2 16 12 15 51 305.37 5 false)
(107 263 0 15 0 24.81 116852.98 1.57 5 675 14 118 20 106 412 6491.83 22 true)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(11 10 0 3 0 9.29 1484.89 0.05 1 37 2 12 13 7 27 82.49 4 false)
(4 5 0 1 0 4.38 227.03 0.02 1 15 1 5 7 4 10 12.61 1 false)
(0 1 0 1 0 1.5 12 0 1 4 1 1 3 1 3 0.67 1 false)
(25 42 0 5 2 15.17 8866.36 0.19 1 118 4 30 13 18 76 492.58 7 false)
(48 108 0 8 3 24.16 37151.02 0.51 1 266 6 60 17 38 158 2063.94 12 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(9 14 0 2 0 9.33 1557.81 0.06 1 38 2 10 12 9 24 86.54 3 false)
(5 12 0 1 0 4.2 463.52 0.04 1 27 1 6 7 10 15 25.75 1 false)
(46 114 0 10 9 27.14 47999.33 0.59 1 297 8 65 20 42 183 2666.63 16 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(4 4 0 1 0 5 182.48 0.01 1 13 1 5 5 2 9 10.14 1 false)
(3 2 0 1 0 3 72 0.01 1 8 1 4 6 2 6 4 1 false)
(54 109 0 7 0 18.17 29080.61 0.53 4 271 5 67 15 45 162 1615.59 11 false)
(4 5 0 2 0 3.5 238.4 0.02 1 19 2 5 7 5 14 13.24 3 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(16 32 0 2 0 15.06 6152.97 0.14 1 81 2 17 16 17 49 341.83 3 false)
(3 2 0 1 0 3 72 0.01 1 8 1 4 6 2 6 4 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(28 46 0 6 1 12.46 8112.64 0.22 1 125 4 32 13 24 79 450.7 9 false)
(8 15 0 2 0 9 1685.67 0.06 1 42 2 9 12 10 27 93.65 3 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(3 4 0 1 0 3.5 193.73 0.02 1 16 1 4 7 4 12 10.76 1 false)
(65 156 1 10 8 42.39 107406.67 0.84 4 412 9 89 25 46 256 5967.04 19 false)
(2 0 0 1 1 0 0 0 1 1 1 4 1 0 1 0 1 false)
(0 2 0 1 0 3 72 0.01 1 8 1 1 6 2 6 4 1 false)
(7 17 0 1 0 6.95 1382.62 0.07 1 46 1 8 9 11 29 76.81 1 false)
(3 2 0 1 0 3.5 122.04 0.01 1 11 1 4 7 2 9 6.78 1 false)
(0 3 0 1 0 3 85.59 0.01 1 9 1 1 6 3 6 4.75 1 false)
(8 16 0 1 0 7.11 1133.59 0.05 1 39 1 9 8 9 23 62.98 1 true)
(5 8 0 1 0 5.33 426.42 0.03 1 21 1 7 8 6 13 23.69 1 false)
(0 0 0 1 0 0 0 0 1 1 1 1 1 0 1 0 1 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(48 112 1 5 0 19.38 33861.93 0.58 3 285 5 56 18 52 173 1881.22 9 true)
(11 23 0 2 0 8.21 2372.72 0.1 1 63 2 12 10 14 40 131.82 3 false)
(14 24 0 3 0 9.6 3195.28 0.11 1 70 2 16 12 15 46 177.52 4 false)
(3 1 0 1 1 1.5 12 0 1 4 1 5 3 1 3 0.67 1 false)
(11 10 0 3 0 9.29 1484.89 0.05 1 37 2 12 13 7 27 82.49 4 false)
(0 1 0 1 0 2 23.22 0 1 5 1 1 4 1 4 1.29 1 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(4 3 0 1 0 3 123.63 0.01 1 13 1 5 6 3 10 6.87 1 false)
(10 16 0 1 3 6.4 1521.19 0.08 1 57 1 18 8 10 41 84.51 1 false)
(34 74 0 7 0 26.79 30243.28 0.38 5 200 6 40 21 29 126 1680.18 13 false)
(54 98 0 8 4 17.04 26283.38 0.51 1 259 8 73 16 46 161 1460.19 12 false)
(5 13 0 1 1 5.32 919.39 0.06 1 40 1 9 9 11 27 51.08 1 false)
(37 144 0 4 5 24 51383.14 0.71 1 347 4 56 18 54 203 2854.62 7 false)
(3 4 0 1 0 3.5 133.19 0.01 1 11 1 5 7 4 7 7.4 1 false)
(3 3 0 1 0 3.5 139.52 0.01 1 12 1 4 7 3 9 7.75 1 false)
(22 55 0 7 0 15.58 13243.53 0.28 1 153 7 25 17 30 98 735.75 13 false)
(5 5 0 1 1 5.83 368.18 0.02 1 19 1 7 7 3 14 20.45 1 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(18 33 0 3 0 18.56 8310.37 0.15 3 88 2 19 18 16 55 461.69 5 false)
(0 2 0 1 0 3 72 0.01 1 8 1 1 6 2 6 4 1 false)
(106 308 0 14 1 44.77 252155.78 1.88 1 829 10 127 25 86 521 14008.65 27 true)
(5 15 0 1 11 5.63 1012.98 0.06 1 41 1 18 9 12 26 56.28 1 false)
(16 13 0 4 0 8.45 1681.86 0.07 3 44 2 17 13 10 31 93.44 7 false)
(3 3 0 1 0 3 85.59 0.01 1 9 1 4 6 3 6 4.75 1 false)
(21 18 0 5 1 10.64 3218.64 0.1 3 66 4 24 13 11 48 178.81 8 false)
(22 44 0 6 0 17 11411.18 0.22 1 127 5 28 17 22 83 633.95 11 false)
(10 21 0 2 0 8.53 2320.9 0.09 1 56 2 13 13 16 35 128.94 3 false)
(3 3 0 1 1 2.5 60 0.01 1 8 1 5 5 3 5 3.33 1 false)
(23 47 0 4 0 11.02 8321.46 0.25 1 136 4 32 15 32 89 462.3 6 true)
(5 12 0 1 0 4.2 463.52 0.04 1 27 1 6 7 10 15 25.75 1 false)
(61 118 0 9 16 22.53 46024.85 0.68 1 327 9 91 21 55 209 2556.94 15 false)
(5 12 0 1 0 4.2 463.52 0.04 1 27 1 6 7 10 15 25.75 1 false)
(19 26 0 4 0 14.62 6175.54 0.14 1 83 3 21 18 16 57 343.09 7 false)
(70 109 4 15 6 25.26 46844.09 0.62 7 314 15 94 19 41 205 2602.45 27 true)
(113 219 1 18 3 38.09 148686.82 1.3 3 597 16 138 24 69 378 8260.37 30 true)
(14 23 0 4 0 9.97 3114.36 0.1 3 65 2 15 13 15 42 173.02 7 false)
(0 1 0 1 0 1.5 12 0 1 4 1 1 3 1 3 0.67 1 false)
(5 9 0 1 0 6.75 606.54 0.03 1 23 1 6 9 6 14 33.7 1 false)
(4 8 0 2 0 5.33 568.57 0.04 1 28 2 5 8 6 20 31.59 3 false)
(13 14 0 4 0 7 1404.72 0.07 3 45 3 18 11 11 31 78.04 6 false)
(14 24 0 4 0 9.75 3268.21 0.11 3 69 2 15 13 16 45 181.57 7 false)
(15 44 0 3 0 14 8034.06 0.19 1 111 3 18 14 22 67 446.34 5 false)
(20 47 0 9 0 14.55 9917.4 0.23 9 134 9 26 13 21 87 550.97 17 true)
(3 3 0 1 0 2.5 60 0.01 1 8 1 4 5 3 5 3.33 1 false)
(36 83 0 6 3 11.75 15944.27 0.45 1 223 6 50 15 53 140 885.79 11 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(16 65 0 1 0 8.43 6687.19 0.26 1 156 1 18 7 27 91 371.51 1 false)
(11 24 0 4 0 18 6006.03 0.11 4 68 3 12 18 12 44 333.67 7 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(5 8 0 1 0 6.4 544.7 0.03 1 23 1 6 8 5 15 30.26 1 false)
(10 9 1 3 0 9 1304.52 0.05 1 33 2 11 14 7 24 72.47 4 false)
(5 11 0 1 0 4.81 488.85 0.03 1 26 1 7 7 8 15 27.16 1 false)
(53 102 1 9 7 17.94 31877.94 0.59 5 287 7 73 19 54 185 1771 15 true)
(15 29 0 3 1 10.15 4079.38 0.13 1 79 2 18 14 20 50 226.63 4 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(14 26 0 3 0 9.75 3140.4 0.11 1 67 2 16 12 16 41 174.47 4 false)
(12 34 0 2 0 14 6172.93 0.15 1 89 2 13 14 17 55 342.94 3 false)
(11 24 1 2 0 13.71 4777.91 0.12 1 71 2 14 16 14 47 265.44 3 true)
(3 3 0 1 0 3 85.59 0.01 1 9 1 4 6 3 6 4.75 1 false)
(3 3 0 1 1 2.5 60 0.01 1 8 1 6 5 3 5 3.33 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(4 4 0 1 0 4 215.1 0.02 1 15 1 5 8 4 11 11.95 1 false)
(0 3 0 1 0 3 85.59 0.01 1 9 1 1 6 3 6 4.75 1 false)
(7 21 0 1 2 5.25 1347.98 0.09 1 56 1 11 8 16 35 74.89 1 true)
(5 6 0 1 0 2 106.3 0.02 1 16 1 6 4 6 10 5.91 1 false)
(0 1 0 1 0 1.5 12 0 1 4 1 1 3 1 3 0.67 1 false)
(6 13 0 2 0 8.67 1294.27 0.05 1 34 2 9 12 9 21 71.9 3 false)
(8 27 0 1 0 4.97 1402.71 0.09 1 60 1 11 7 19 33 77.93 1 false)
(45 110 0 12 3 26.35 48459.37 0.61 7 299 10 59 23 48 189 2692.19 22 true)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(11 26 0 2 0 9.29 3150.52 0.11 1 74 2 12 10 14 48 175.03 3 false)
(5 6 0 1 0 6 323.33 0.02 1 17 1 6 6 3 11 17.96 1 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(11 19 0 3 3 9.5 2569.87 0.09 1 59 3 17 12 12 40 142.77 5 true)
(20 35 0 5 0 12.35 6361.1 0.17 4 106 5 26 12 17 71 353.39 9 false)
(3 3 0 1 0 2.5 60 0.01 1 8 1 4 5 3 5 3.33 1 true)
(15 40 0 3 0 17.14 9151.3 0.18 1 101 3 20 18 21 61 508.41 5 false)
(24 79 0 5 2 23.7 26838.69 0.38 4 195 5 33 21 35 116 1491.04 9 false)
(12 34 0 2 0 13.22 5883.89 0.15 1 89 2 13 14 18 55 326.88 3 false)
(6 13 0 2 0 6.5 1066 0.05 1 41 2 9 8 8 28 59.22 3 true)
(13 28 0 2 0 14 5014.84 0.12 1 73 2 15 15 15 45 278.6 3 false)
(3 2 0 1 1 3 108 0.01 1 12 1 5 6 2 10 6 1 false)
(4 4 0 1 0 3.33 130 0.01 1 13 1 5 5 3 9 7.22 1 false)
(4 4 0 1 0 3 149.49 0.02 1 15 1 5 6 4 11 8.3 1 false)
(0 1 0 1 0 2.5 38.77 0.01 1 6 1 1 5 1 5 2.15 1 false)
(22 29 0 4 0 15.47 6896.24 0.15 3 90 4 25 16 15 61 383.12 7 false)
(3 2 0 1 0 3 72 0.01 1 8 1 4 6 2 6 4 1 false)
(6 8 0 2 0 7.2 822.39 0.04 1 30 2 8 9 5 22 45.69 3 false)
(8 19 0 2 0 7.92 1800.5 0.08 1 51 2 10 10 12 32 100.03 3 false)
(33 42 0 6 0 14.88 9961.7 0.22 3 125 5 37 17 24 83 553.43 10 false)
(3 3 0 1 0 3 95.1 0.01 1 10 1 4 6 3 7 5.28 1 false)
(3 3 0 1 0 3 85.59 0.01 1 9 1 4 6 3 6 4.75 1 false)
(57 144 0 5 0 16.46 37755.59 0.76 1 357 5 65 16 70 213 2097.53 7 true)
(5 8 0 1 0 5.33 426.42 0.03 1 21 1 7 8 6 13 23.69 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(9 13 0 2 0 8.13 1355.23 0.06 1 40 2 10 10 8 27 75.29 3 false)
(38 119 0 14 0 42.15 72932.91 0.58 9 323 14 45 17 24 204 4051.83 27 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(103 208 0 22 4 48.94 169799.06 1.16 12 557 17 119 24 51 349 9433.28 43 false)
(14 35 0 3 3 11.05 5037.64 0.15 1 92 2 26 12 19 57 279.87 4 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(14 63 0 1 0 7.6 5424.68 0.24 1 138 1 17 7 29 75 301.37 1 false)
(88 189 2 15 12 35.1 114410.43 1.09 1 495 9 122 26 70 306 6356.14 24 true)
(12 21 0 3 7 10.5 3208.05 0.1 1 65 3 23 13 13 44 178.23 5 true)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(0 1 0 1 0 1.5 12 0 1 4 1 1 3 1 3 0.67 1 false)
(23 39 0 6 0 24.7 13948.3 0.19 1 111 4 29 19 15 72 774.91 11 false)
(3 2 0 1 0 3 72 0.01 1 8 1 4 6 2 6 4 1 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(0 3 0 1 0 3 85.59 0.01 1 9 1 1 6 3 6 4.75 1 false)
(0 3 0 1 0 3 85.59 0.01 1 9 1 1 6 3 6 4.75 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(20 60 0 6 1 20.69 19748.29 0.32 5 170 6 28 20 29 110 1097.13 11 false)
(16 16 0 4 0 11.64 3264.45 0.09 1 59 3 17 16 11 43 181.36 6 false)
(5 9 0 1 0 6.75 606.54 0.03 1 23 1 6 9 6 14 33.7 1 false)
(21 37 0 7 1 17.34 8678.36 0.17 3 101 6 25 15 16 64 482.13 12 false)
(3 3 0 1 0 2.5 60 0.01 1 8 1 4 5 3 5 3.33 1 false)
(18 33 0 2 5 16.5 6765 0.14 1 82 2 24 16 16 49 375.83 3 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(9 16 0 3 0 8.67 2092.83 0.08 3 52 3 11 13 12 36 116.27 5 false)
(52 78 0 9 3 19.5 24605.14 0.42 1 234 8 60 14 28 156 1366.95 13 false)
(3 3 0 1 0 3.5 139.52 0.01 1 12 1 4 7 3 9 7.75 1 false)
(17 36 0 4 2 16.2 8841.71 0.18 1 104 4 25 18 20 68 491.21 7 false)
(90 139 2 17 7 38.06 95809.13 0.84 8 418 14 117 23 42 279 5322.73 30 true)
(7 11 0 1 0 5.5 688.04 0.04 1 30 1 9 9 9 19 38.22 1 false)
(5 12 0 1 0 4.2 463.52 0.04 1 27 1 6 7 10 15 25.75 1 false)
(13 29 0 3 0 15.54 5735.89 0.12 1 76 3 17 15 14 47 318.66 5 false)
(21 50 0 6 0 18.75 13244.88 0.24 4 131 4 25 18 24 81 735.83 11 false)
(4 6 0 1 0 4.2 240.91 0.02 1 16 1 6 7 5 10 13.38 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(25 56 0 5 0 17.68 13404.49 0.25 1 153 4 28 12 19 97 744.69 8 false)
(14 42 0 6 0 16.43 10037.72 0.2 1 114 5 19 18 23 72 557.65 11 false)
(36 79 0 5 0 19.75 21840 0.37 1 198 4 44 16 32 119 1213.33 7 true)
(6 8 0 2 0 7.33 719.39 0.03 1 24 2 7 11 6 16 39.97 3 false)
(37 79 0 4 4 16.93 19777.28 0.39 4 207 4 51 15 35 128 1098.74 7 false)
(19 52 0 3 0 12.43 8983.13 0.24 1 142 3 24 11 23 90 499.06 5 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(21 51 0 4 1 15.11 10577.6 0.23 1 129 4 29 16 27 78 587.64 6 false)
(21 37 0 7 1 17.34 8678.36 0.17 3 101 6 25 15 16 64 482.13 12 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(4 6 0 1 0 5.25 417.73 0.03 1 23 1 5 7 4 17 23.21 1 false)
(18 33 0 2 6 10.08 4016.74 0.13 1 82 2 27 11 18 49 223.15 3 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(5 13 0 1 0 4.88 770.85 0.05 1 36 1 8 9 12 23 42.83 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(36 62 0 8 0 20.67 19687.59 0.32 3 179 6 40 16 24 117 1093.75 13 false)
(3 3 0 1 1 2.5 60 0.01 1 8 1 6 5 3 5 3.33 1 false)
(52 127 0 13 13 33.13 70666.9 0.71 1 348 12 77 24 46 221 3925.94 23 false)
(16 13 0 4 0 8.45 1681.86 0.07 3 44 2 17 13 10 31 93.44 7 false)
(5 13 0 1 1 5.32 919.39 0.06 1 40 1 8 9 11 27 51.08 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(2 0 0 1 0 0 0 0 1 1 1 3 1 0 1 0 1 false)
(13 33 1 3 1 10.21 4832.73 0.16 1 93 3 21 13 21 60 268.48 5 true)
(10 25 0 3 1 17.86 6086.79 0.11 3 67 2 13 20 14 42 338.15 5 true)
(30 84 0 7 2 24 29970.57 0.42 6 216 7 42 20 35 132 1665.03 12 false)
(24 42 0 6 0 18.79 11268.26 0.2 1 116 2 28 17 19 74 626.01 11 false)
(3 5 0 1 0 3.5 175.66 0.02 1 14 1 4 7 5 9 9.76 1 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(16 26 0 5 1 17 6589.95 0.13 3 79 4 23 17 13 53 366.11 9 false)
(31 34 0 7 3 19.43 9914.72 0.17 7 104 4 41 16 14 70 550.82 13 false)
(6 17 0 1 0 5.23 850.08 0.05 1 37 1 7 8 13 20 47.23 1 false)
(15 39 0 3 0 11.14 5396.06 0.16 1 96 3 18 12 21 57 299.78 5 true)
(18 59 0 1 10 8.32 6997.01 0.28 1 149 1 38 11 39 90 388.72 1 false)
(6 7 0 1 0 7 602.27 0.03 1 24 1 8 8 4 17 33.46 1 false)
(4 4 0 1 0 2 66 0.01 1 11 1 5 4 4 7 3.67 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(3 2 0 1 0 3.5 122.04 0.01 1 11 1 4 7 2 9 6.78 1 false)
(9 21 0 2 1 14.88 4118.96 0.09 1 57 2 12 17 12 36 228.83 3 true)
(0 3 0 1 0 3 85.59 0.01 1 9 1 1 6 3 6 4.75 1 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(23 31 0 5 0 14.39 6090.84 0.14 3 89 4 24 13 14 58 338.38 7 false)
(67 180 1 21 13 36.99 120439.45 1.09 9 487 19 88 30 73 307 6691.08 40 false)
(3 3 0 1 1 2.5 60 0.01 1 8 1 6 5 3 5 3.33 1 false)
(3 2 0 1 0 3 72 0.01 1 8 1 4 6 2 6 4 1 false)
(15 18 0 4 0 7.36 1686.73 0.08 1 53 3 16 9 11 35 93.71 5 true)
(0 2 0 1 0 3 72 0.01 1 8 1 1 6 2 6 4 1 false)
(14 34 1 2 0 12.28 5352.73 0.15 1 88 2 19 13 18 54 297.37 3 true)
(5 8 0 1 0 6.4 521.02 0.03 1 22 1 8 8 5 14 28.95 1 false)
(0 1 0 1 0 1.5 12 0 1 4 1 1 3 1 3 0.67 1 false)
(3 3 0 1 1 2.5 60 0.01 1 8 1 5 5 3 5 3.33 1 false)
(3 2 0 1 1 3 108 0.01 1 12 1 5 6 2 10 6 1 false)
(8 14 0 2 0 8.75 1240.55 0.05 1 34 2 10 10 8 20 68.92 3 false)
(7 19 0 2 5 13.72 3243.25 0.08 1 53 2 16 13 9 34 180.18 3 false)
(5 12 0 1 0 4.2 463.52 0.04 1 27 1 6 7 10 15 25.75 1 false)
(21 50 0 3 0 15 10297.93 0.23 1 129 3 25 15 25 79 572.11 5 false)
(6 11 0 1 0 6.19 834.61 0.04 1 33 1 7 9 8 22 46.37 1 false)
(58 128 0 7 0 18.11 34291.94 0.63 4 311 5 73 15 53 183 1905.11 11 false)
(27 51 0 5 3 14.57 13563.07 0.31 1 161 2 36 20 35 110 753.5 8 true)
(73 143 0 12 1 23.35 52445.24 0.75 1 373 10 85 16 49 230 2913.62 18 false)
(3 2 0 1 0 3 72 0.01 1 8 1 4 6 2 6 4 1 false)
(4 8 0 1 1 3.5 355.53 0.03 1 26 1 7 7 8 18 19.75 1 false)
(7 17 0 1 0 6.95 1382.62 0.07 1 46 1 8 9 11 29 76.81 1 false)
(76 175 0 17 9 40.7 115062.64 0.94 12 473 13 102 20 43 298 6392.37 33 false)
(16 32 0 3 3 16 6560 0.14 1 82 3 21 16 16 50 364.44 5 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(3 3 0 1 0 3 85.59 0.01 1 9 1 4 6 3 6 4.75 1 false)
(28 54 0 6 5 18.41 15056.5 0.27 1 157 6 39 15 22 103 836.47 11 false)
(4 8 0 1 0 4 258.12 0.02 1 18 1 5 6 6 10 14.34 1 false)
(0 1 0 1 0 1.5 12 0 1 4 1 1 3 1 3 0.67 1 false)
(4 3 0 1 0 3.5 151.15 0.01 1 13 1 5 7 3 10 8.4 1 false)
(2 0 0 1 0 0 0 0 1 1 1 4 1 0 1 0 1 false)
(13 18 0 3 0 11.7 2963.84 0.08 1 56 2 14 13 10 38 164.66 4 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(5 13 0 1 0 3.55 434.76 0.04 1 30 1 8 6 11 17 24.15 1 false)
(122 335 1 19 12 36.55 223888.39 2.04 4 867 16 153 24 110 532 12438.24 32 false)
(0 3 0 1 0 3 85.59 0.01 1 9 1 1 6 3 6 4.75 1 false)
(5 8 0 1 0 4.67 379.91 0.03 1 22 1 6 7 6 14 21.11 1 false)
(20 44 0 9 0 15.23 8150.47 0.18 1 120 8 21 9 13 76 452.8 17 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(0 2 0 1 0 3 72 0.01 1 8 1 1 6 2 6 4 1 false)
(50 93 0 8 3 19.93 30048.37 0.5 5 246 8 64 21 49 153 1669.35 14 false)
(33 79 0 6 4 19.75 25188.5 0.43 3 211 6 40 22 44 132 1399.36 9 false)
(3 4 0 1 0 3 109.62 0.01 1 11 1 5 6 4 7 6.09 1 false)
(0 1 0 1 0 1.5 12 0 1 4 1 1 3 1 3 0.67 1 false)
(5 9 0 1 0 5.14 502.31 0.03 1 25 1 6 8 7 16 27.91 1 false)
(8 19 0 2 0 7.92 1800.5 0.08 1 51 2 10 10 12 32 100.03 3 false)
(9 11 0 2 0 8.64 1189.32 0.05 1 33 2 13 11 7 22 66.07 3 false)
(6 16 0 1 0 5.6 824.03 0.05 1 36 1 8 7 10 20 45.78 1 false)
(5 15 0 1 2 5.45 787.8 0.05 1 34 1 10 8 11 19 43.77 1 false)
(111 265 0 22 11 34.57 169489.04 1.63 8 715 19 144 24 92 450 9416.06 41 true)
(2 0 0 1 1 0 0 0 1 1 1 4 1 0 1 0 1 false)
(214 556 3 30 2 54.54 582830.35 3.56 14 1413 23 246 31 158 857 32379.46 51 true)
(4 3 0 1 0 4.5 175.5 0.01 1 13 1 5 6 2 10 9.75 1 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(7 11 0 1 0 5.5 779.78 0.05 1 34 1 8 9 9 23 43.32 1 false)
(3 4 0 1 1 3 119.59 0.01 1 12 1 5 6 4 8 6.64 1 false)
(4 9 0 2 0 5.14 502.31 0.03 1 25 2 6 8 7 16 27.91 3 false)
(25 39 0 6 15 24.7 14702.26 0.2 1 117 4 45 19 15 78 816.79 11 false)
(15 14 0 3 0 6.46 1440.31 0.07 1 48 2 18 12 13 34 80.02 4 false)
(23 67 0 7 4 21.22 22872.08 0.36 3 192 7 35 19 30 125 1270.67 13 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(41 79 0 11 3 23.94 33320.87 0.46 1 243 10 50 20 33 164 1851.16 21 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(15 26 0 4 1 9.39 3349.04 0.12 1 72 2 19 13 18 46 186.06 6 false)
(114 166 9 22 12 43.23 141550.33 1.09 15 529 19 140 25 48 363 7863.91 40 true)
(104 233 2 14 18 25.13 103097.32 1.37 5 590 9 144 22 102 357 5727.63 25 false)
(28 68 0 12 0 22.67 24374.21 0.36 7 186 10 35 22 33 118 1354.12 23 false)
(12 23 0 4 5 11.5 3814.64 0.11 1 69 4 21 14 14 46 211.92 7 true)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(88 194 0 11 1 21.7 71508.8 1.1 7 504 9 109 17 76 310 3972.71 18 false)
(14 56 0 1 0 7.84 5292 0.23 1 135 1 16 7 25 79 294 1 false)
(16 28 0 4 0 14 4980.42 0.12 1 74 3 19 14 14 46 276.69 6 true)
(4 2 0 1 0 3.5 133.14 0.01 1 12 1 5 7 2 10 7.4 1 false)
(9 22 0 2 1 11.85 3548.61 0.1 1 63 2 12 14 13 41 197.14 3 false)
(17 21 0 3 0 12.25 3685.14 0.1 3 64 3 18 14 12 43 204.73 5 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(5 12 0 1 0 4.2 463.52 0.04 1 27 1 6 7 10 15 25.75 1 false)
(10 6 1 3 0 7.2 853.46 0.04 1 29 2 11 12 5 23 47.41 4 false)
(79 152 0 8 9 19.27 45791.28 0.79 1 367 5 102 18 71 215 2543.96 11 true)
(14 23 0 4 0 9.97 3114.36 0.1 3 65 2 15 13 15 42 173.02 7 false)
(4 3 0 1 1 6 239.18 0.01 1 12 1 6 8 2 9 13.29 1 false)
(44 134 0 5 1 29.48 63297.51 0.72 1 348 5 54 22 50 214 3516.53 9 false)
(3 3 0 1 0 3 85.59 0.01 1 9 1 4 6 3 6 4.75 1 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(15 35 0 5 0 12.5 6656.28 0.18 1 103 5 19 15 21 68 369.79 9 false)
(12 22 0 4 0 7.33 2383.85 0.11 1 70 4 14 10 15 48 132.44 7 false)
(8 7 0 1 0 9.63 864.89 0.03 1 23 1 9 11 4 16 48.05 1 false)
(3 2 0 1 0 6 134.75 0.01 1 8 1 4 6 1 6 7.49 1 false)
(11 22 0 2 0 7.86 2125.46 0.09 1 59 2 12 10 14 37 118.08 3 false)
(47 110 0 7 5 18.02 32631.05 0.6 3 289 7 63 19 58 179 1812.84 12 false)
(8 12 0 2 0 7.71 1110.86 0.05 1 36 2 10 9 7 24 61.71 3 false)
(10 6 1 3 0 7.2 853.46 0.04 1 29 2 11 12 5 23 47.41 4 false)
(19 29 0 3 0 12.08 4693.39 0.13 1 77 2 22 15 18 48 260.74 4 false)
(4 7 0 2 0 4.67 355.35 0.03 1 20 2 5 8 6 13 19.74 3 false)
(8 16 0 2 0 9.78 1943.91 0.07 1 46 2 9 11 9 30 107.99 3 false)
(4 3 0 1 0 3.5 151.15 0.01 1 13 1 5 7 3 10 8.4 1 false)
(12 15 0 3 0 9.75 2205.24 0.08 1 50 2 14 13 10 35 122.51 4 false)
(73 142 0 10 2 20.61 50170.62 0.81 7 385 10 84 18 62 243 2787.26 17 false)
(7 17 0 1 0 6.18 997.88 0.05 1 38 1 9 8 11 21 55.44 1 false)
(9 17 0 3 0 6.95 1593.02 0.08 1 53 3 10 9 11 36 88.5 5 false)
(4 8 0 2 0 7 726.48 0.03 1 30 2 5 7 4 22 40.36 3 false)
(0 2 0 1 0 3 72 0.01 1 8 1 1 6 2 6 4 1 false)
(3 1 0 1 0 2.5 38.77 0.01 1 6 1 4 5 1 5 2.15 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(44 90 0 7 11 32.72 45051.12 0.46 1 236 5 62 24 33 146 2502.84 11 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(9 21 0 2 0 14.88 4118.96 0.09 1 57 2 11 17 12 36 228.83 3 false)
(20 37 0 4 0 14.61 7876.2 0.18 1 106 3 23 15 19 69 437.57 6 false)
(14 54 0 1 0 8.22 5241.84 0.21 1 130 1 17 7 23 76 291.21 1 false)
(51 115 0 8 2 24.64 41048.67 0.56 1 282 6 61 18 42 167 2280.48 12 false)
(3 1 0 1 1 1.5 12 0 1 4 1 5 3 1 3 0.67 1 false)
(0 1 0 1 0 1.5 12 0 1 4 1 1 3 1 3 0.67 1 false)
(0 1 0 1 0 2.5 38.77 0.01 1 6 1 1 5 1 5 2.15 1 false)
(4 4 0 1 0 1.5 37.9 0.01 1 9 1 5 3 4 5 2.11 1 false)
(2 0 0 1 0 0 0 0 1 1 1 3 1 0 1 0 1 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(5 6 0 1 0 3 215.1 0.02 1 20 1 6 6 6 14 11.95 1 false)
(57 158 0 7 10 27.8 68305.52 0.82 1 397 7 86 19 54 239 3794.75 13 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(10 25 0 3 0 17.86 6086.79 0.11 3 67 2 12 20 14 42 338.15 5 false)
(9 18 0 2 0 13 2898.63 0.07 1 50 2 11 13 9 32 161.04 3 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(3 1 0 1 1 1.5 12 0 1 4 1 5 3 1 3 0.67 1 false)
(8 19 0 2 0 7.92 1800.5 0.08 1 51 2 9 10 12 32 100.03 3 false)
(9 22 0 2 1 11.85 3548.61 0.1 1 63 2 12 14 13 41 197.14 3 false)
(10 14 0 3 0 8.4 1648.21 0.07 1 44 2 12 12 10 30 91.57 5 false)
(3 3 0 1 1 2.5 60 0.01 1 8 1 5 5 3 5 3.33 1 false)
(3 2 0 1 0 2.5 49.13 0.01 1 7 1 4 5 2 5 2.73 1 false)
(9 22 0 2 0 6.19 1609.1 0.09 1 56 1 12 9 16 34 89.39 3 false)
(7 10 0 2 0 5.63 781.73 0.05 1 34 2 9 9 8 24 43.43 3 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(3 1 0 1 1 1.5 12 0 1 4 1 5 3 1 3 0.67 1 false)
(3 4 0 1 0 4.67 248.04 0.02 1 16 1 4 7 3 12 13.78 1 false)
(18 43 0 6 14 14.62 9144.94 0.21 5 116 6 39 17 25 73 508.05 11 false)
(0 0 0 1 0 0 0 0 1 1 1 1 1 0 1 0 1 false)
(13 14 0 4 0 7 1404.72 0.07 3 45 3 17 11 11 31 78.04 6 false)
(23 30 0 5 2 8.48 3988.71 0.16 1 91 5 31 13 23 61 221.59 8 true)
(23 27 0 6 2 10.97 4689.17 0.14 1 88 6 29 13 16 61 260.51 10 false)
(17 32 1 3 1 18 9065.86 0.17 3 99 3 19 18 16 67 503.66 5 true)
(22 32 0 3 0 12.63 5590.85 0.15 1 87 3 23 15 19 55 310.6 5 false)
(34 98 0 3 1 17.93 24569.36 0.46 1 236 3 47 15 41 138 1364.96 4 true)
(35 60 0 7 1 17.14 16352.99 0.32 1 165 6 39 20 35 105 908.5 11 false)
(0 2 0 1 0 2.5 49.13 0.01 1 7 1 1 5 2 5 2.73 1 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(3 4 0 1 0 3 129.56 0.01 1 13 1 4 6 4 9 7.2 1 false)
(242 480 1 36 38 40.75 395438.84 3.23 20 1287 34 310 27 159 807 21968.82 59 false)
(20 48 0 4 0 14.22 9878.21 0.23 1 128 3 22 16 27 80 548.79 6 false)
(3 3 0 1 0 2.5 60 0.01 1 8 1 5 5 3 5 3.33 1 false)
(43 73 2 8 6 12.98 16702 0.43 5 217 6 60 16 45 144 927.89 13 true)
(5 8 0 1 0 6.4 497.34 0.03 1 21 1 7 8 5 13 27.63 1 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(79 135 0 14 2 19.78 45226.86 0.76 1 367 13 91 17 58 232 2512.6 23 true)
(8 16 0 2 0 9.78 1943.91 0.07 1 46 2 9 11 9 30 107.99 3 false)
(3 2 0 1 0 5 90.47 0.01 1 7 1 4 5 1 5 5.03 1 false)
(10 6 1 3 0 7.2 853.46 0.04 1 29 2 11 12 5 23 47.41 4 false)
(27 55 0 6 1 13.24 10710.87 0.27 4 152 6 33 13 27 97 595.05 10 false)
(3 1 0 1 0 1.5 12 0 1 4 1 4 3 1 3 0.67 1 false)
(9 18 0 2 0 13 2782.69 0.07 1 48 2 11 13 9 30 154.59 3 false)
(9 13 0 2 0 9.75 1517 0.05 1 36 2 12 12 8 23 84.28 3 false)
(59 125 0 13 6 34.2 76313.12 0.74 7 351 12 79 29 53 226 4239.62 24 true)
(6 11 0 1 0 6.19 682.86 0.04 1 27 1 7 9 8 16 37.94 1 false)
(24 36 0 5 0 12.52 6882.97 0.18 1 104 4 26 16 23 68 382.39 8 false)
(11 36 0 1 1 8.25 3681.54 0.15 1 87 1 16 11 24 51 204.53 1 false)
(36 77 1 7 0 18.76 23842.81 0.42 1 217 6 44 19 39 140 1324.6 12 false)
(4 11 0 1 0 4.28 479.11 0.04 1 28 1 6 7 9 17 26.62 1 false)
(131 255 3 26 11 42.03 193686.35 1.54 15 666 18 166 30 91 411 10760.35 43 false)
)))))
