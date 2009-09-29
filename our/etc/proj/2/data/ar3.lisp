#|@relation ar3

@attribute total_loc numeric
@attribute blank_loc numeric
@attribute comment_loc numeric
@attribute code_and_comment_loc numeric
@attribute executable_loc numeric
@attribute unique_operands numeric
@attribute unique_operators numeric
@attribute total_operands numeric
@attribute total_operators numeric
@attribute halstead_vocabulary numeric
@attribute halstead_length numeric
@attribute halstead_volume numeric
@attribute halstead_level numeric
@attribute halstead_difficulty numeric
@attribute halstead_effort numeric
@attribute halstead_error numeric
@attribute halstead_time numeric
@attribute branch_count numeric
@attribute decision_count numeric
@attribute call_pairs numeric
@attribute condition_count numeric
@attribute multiple_condition_count numeric
@attribute cyclomatic_complexity numeric
@attribute cyclomatic_density numeric
@attribute decision_density numeric
@attribute design_complexity numeric
@attribute design_density numeric
@attribute normalized_cyclomatic_complexity numeric
@attribute formal_parameters numeric
@attribute defects {false true}
|#

(defun ar3 ()
  (data
   :name 'ar3
   :columns '(total_loc blank_loc comment_loc code_and_comment_loc executable_loc unique_operands unique_operators total_operands total_operators halstead_vocabulary halstead_length halstead_volume halstead_level halstead_difficulty halstead_effort halstead_error halstead_time branch_count decision_count call_pairs condition_count multiple_condition_count cyclomatic_complexity cyclomatic_density decision_density design_complexity design_density normalized_cyclomatic_complexity formal_parameters defects)
   :egs
   '(

     (307 116 44 5 147 138 23 245 366 161 611 3104 0.04898 20.4167 63373.3333 1.0347 3520.7407 94 47 43 39 10 37 0.2517 1.2051 43 1.1622 0.12052 0 true)
     (3 0 0 0 3 4 6 6 8 10 14 32 0.22222 4.5 144 0.010667 8 0 0 0 0 0 1 0.33333 0 0 0 0.33333 0 false)
     (268 72 22 0 174 125 23 337 484 148 821 4102 0.032254 31.004 127178.408 1.3673 7065.4671 190 95 0 94 32 64 0.36782 1.0106 0 0 0.23881 0 false)
     (11 2 0 0 9 10 4 15 17 14 32 84 0.33333 3 252 0.028 14 0 0 2 0 0 1 0.11111 0 2 2 0.090909 0 false)
     (9 2 0 0 7 7 4 11 13 11 24 57 0.31818 3.1429 179.1429 0.019 9.9524 0 0 1 0 0 1 0.14286 0 1 1 0.11111 0 false)
     (10 2 0 0 8 7 4 13 15 11 28 67 0.26923 3.7143 248.8571 0.022333 13.8254 0 0 2 0 0 1 0.125 0 2 2 0.1 0 false)
     (5 0 0 0 5 5 3 5 9 8 14 29 0.66667 1.5 43.5 0.0096667 2.4167 0 0 3 0 0 1 0.2 0 3 3 0.2 0 false)
     (28 5 1 0 22 18 12 49 53 30 102 346 0.061224 16.3333 5651.3333 0.11533 313.963 8 4 2 3 1 4 0.18182 1.3333 2 0.5 0.14286 1 false)
     (26 6 0 0 20 16 11 41 44 27 85 280 0.070953 14.0938 3946.25 0.093333 219.2361 4 2 2 1 0 3 0.15 2 2 0.66667 0.11538 0 false)
     (15 4 0 0 11 11 5 19 22 16 41 113 0.23158 4.3182 487.9545 0.037667 27.1086 0 0 7 0 0 1 0.090909 0 7 7 0.066667 1 false)
     (23 5 1 0 17 18 9 25 36 27 61 201 0.16 6.25 1256.25 0.067 69.7917 4 2 7 1 0 3 0.17647 2 7 2.3333 0.13043 2 false)
     (10 4 0 0 6 9 6 24 23 15 47 127 0.125 8 1016 0.042333 56.4444 0 0 3 0 0 1 0.16667 0 3 3 0.1 2 false)
     (23 5 1 0 17 15 10 43 58 25 101 325 0.069767 14.3333 4658.3333 0.10833 258.7963 16 8 4 8 4 5 0.29412 1 4 0.8 0.21739 1 false)
     (76 11 11 2 54 49 14 116 166 63 282 1168 0.060345 16.5714 19355.4286 0.38933 1075.3016 58 29 17 29 14 16 0.2963 1 17 1.0625 0.21053 0 false)
     (203 63 37 6 103 60 23 304 348 83 652 2881 0.017162 58.2667 167866.2667 0.96033 9325.9037 58 29 77 28 8 22 0.21359 1.0357 77 3.5 0.10837 0 false)
     (64 18 7 1 39 35 14 75 97 49 172 669 0.066667 15 10035 0.223 557.5 24 12 8 12 3 10 0.25641 1 8 0.8 0.15625 0 false)
     (94 21 17 3 56 35 18 103 145 53 248 984 0.037756 26.4857 26061.9429 0.328 1447.8857 32 16 29 16 4 12 0.21429 1 29 2.4167 0.12766 0 false)
     (31 10 5 0 16 19 5 64 66 24 130 413 0.11875 8.4211 3477.8947 0.13767 193.2164 0 0 24 0 0 1 0.0625 0 24 24 0.032258 0 false)
     (70 21 15 0 34 30 7 83 88 37 171 617 0.10327 9.6833 5974.6167 0.20567 331.9231 2 1 17 0 0 2 0.058824 0 17 8.5 0.028571 0 false)
     (20 9 8 0 3 12 4 19 22 16 41 113 0.31579 3.1667 357.8333 0.037667 19.8796 0 0 9 0 0 1 0.33333 0 9 9 0.05 0 false)
     (285 78 40 3 167 36 15 295 355 51 650 2555 0.016271 61.4583 157026.0417 0.85167 8723.669 40 20 109 20 3 15 0.08982 1 109 7.2667 0.052632 0 false)
     (61 21 7 1 33 24 10 73 83 34 156 550 0.065753 15.2083 8364.5833 0.18333 464.6991 6 3 10 3 0 4 0.12121 1 10 2.5 0.065574 0 false)
     (16 5 0 0 11 12 5 22 23 17 45 127 0.21818 4.5833 582.0833 0.042333 32.338 0 0 1 0 0 1 0.090909 0 1 1 0.0625 1 false)
     (17 6 0 0 11 12 5 22 23 17 45 127 0.21818 4.5833 582.0833 0.042333 32.338 0 0 1 0 0 1 0.090909 0 1 1 0.058824 1 false)
     (29 8 1 1 20 15 10 38 44 25 82 263 0.078947 12.6667 3331.3333 0.087667 185.0741 2 1 1 0 0 2 0.1 0 1 0.5 0.068966 2 false)
     (82 31 7 4 44 25 11 57 91 36 148 530 0.079745 12.54 6646.2 0.17667 369.2333 24 12 2 11 3 10 0.22727 1.0909 2 0.2 0.12195 0 false)
     (74 21 10 4 43 30 10 58 91 40 149 549 0.10345 9.6667 5307 0.183 294.8333 28 14 2 14 3 12 0.27907 1 2 0.16667 0.16216 0 false)
     (77 30 13 4 34 50 16 87 108 66 195 816 0.071839 13.92 11358.72 0.272 631.04 24 12 3 12 4 9 0.26471 1 3 0.33333 0.11688 0 false)
     (76 19 2 1 55 57 19 118 155 76 273 1182 0.050847 19.6667 23246 0.394 1291.4444 46 23 25 23 10 14 0.25455 1 25 1.7857 0.18421 0 false)
     (23 5 0 0 18 22 6 67 69 28 136 453 0.10945 9.1364 4138.7727 0.151 229.9318 4 2 24 2 1 2 0.11111 1 24 12 0.086957 0 false)
     (19 5 0 0 14 14 13 26 33 27 59 194 0.08284 12.0714 2341.8571 0.064667 130.1032 4 2 0 1 0 3 0.21429 2 0 0 0.15789 0 false)
     (128 42 21 3 65 67 13 83 134 80 217 950 0.12419 8.0522 7649.6269 0.31667 424.9793 26 13 24 12 1 12 0.18462 1.0833 24 2 0.09375 0 false)
     (115 42 4 1 69 44 19 117 155 63 272 1126 0.039586 25.2614 28444.2955 0.37533 1580.2386 24 12 10 12 2 10 0.14493 1 10 1 0.086957 0 false)
     (117 40 17 4 60 52 14 82 126 66 208 871 0.090592 11.0385 9614.5 0.29033 534.1389 26 13 16 12 1 12 0.2 1.0833 16 1.3333 0.10256 0 false)
     (91 21 18 0 52 74 5 102 104 79 206 900 0.2902 3.4459 3101.3514 0.3 172.2973 0 0 0 0 0 1 0.019231 0 0 0 0.010989 0 false)
     (57 0 36 0 21 30 4 35 37 34 72 253 0.42857 2.3333 590.3333 0.084333 32.7963 0 0 0 0 0 1 0.047619 0 0 0 0.017544 0 false)
     (18 5 6 0 7 15 7 28 39 22 67 207 0.15306 6.5333 1352.4 0.069 75.1333 16 8 0 8 0 9 1.2857 1 0 0 0.5 0 false)
     (91 26 14 0 51 68 14 142 167 82 309 1361 0.06841 14.6176 19894.6177 0.45367 1105.2565 32 16 20 16 0 17 0.33333 1 20 1.1765 0.18681 0 false)
     (31 3 1 0 27 29 5 62 64 34 126 444 0.1871 5.3448 2373.1034 0.148 131.8391 0 0 11 0 0 1 0.037037 0 11 11 0.032258 0 false)
     (18 4 0 0 14 20 6 32 34 26 66 215 0.20833 4.8 1032 0.071667 57.3333 0 0 6 0 0 1 0.071429 0 6 6 0.055556 0 true)
     (26 10 0 0 16 21 13 45 55 34 100 352 0.071795 13.9286 4902.8571 0.11733 272.381 8 4 0 3 0 5 0.3125 1.3333 0 0 0.19231 1 false)
     (11 4 0 0 7 11 8 23 29 19 52 153 0.11957 8.3636 1279.6364 0.051 71.0909 8 4 1 4 0 5 0.71429 1 1 0.2 0.45455 0 false)
     (31 10 0 0 21 18 8 36 46 26 82 267 0.125 8 2136 0.089 118.6667 8 4 2 4 1 4 0.19048 1 2 0.5 0.12903 0 false)
     (17 7 2 1 8 13 7 17 20 20 37 110 0.21849 4.5769 503.4615 0.036667 27.9701 2 1 1 0 0 2 0.25 0 1 0.5 0.11765 1 false)
     (115 32 29 2 54 65 13 183 229 78 412 1794 0.054645 18.3 32830.2 0.598 1823.9 100 50 1 50 23 28 0.51852 1 1 0.035714 0.24348 0 false)
     (62 19 12 0 31 45 13 130 161 58 291 1181 0.053254 18.7778 22176.5556 0.39367 1232.0309 68 34 1 34 15 20 0.64516 1 1 0.05 0.32258 0 false)
     (58 18 5 0 35 24 14 50 74 38 124 451 0.068571 14.5833 6577.0833 0.15033 365.3935 16 8 3 8 2 7 0.2 1 3 0.42857 0.12069 0 false)
     (6 2 0 0 4 8 6 9 10 14 19 50 0.2963 3.375 168.75 0.016667 9.375 0 0 1 0 0 1 0.25 0 1 1 0.16667 0 false)
     (5 1 0 0 4 7 5 8 9 12 17 42 0.35 2.8571 120 0.014 6.6667 0 0 0 0 0 1 0.25 0 0 0 0.2 0 false)
     (155 36 16 4 103 69 29 207 320 98 527 2416 0.022989 43.5 105096 0.80533 5838.6667 70 35 0 32 3 32 0.31068 1.0938 0 0 0.20645 0 false)
     (42 8 3 1 31 18 11 42 61 29 103 346 0.077922 12.8333 4440.3333 0.11533 246.6852 16 8 0 8 4 5 0.16129 1 0 0 0.11905 0 false)
     (445 109 64 11 272 99 19 477 693 118 1170 5581 0.021847 45.7727 255457.5909 1.8603 14192.0884 208 104 18 104 26 79 0.29044 1 18 0.22785 0.17753 0 true)
     (43 9 7 4 27 25 14 51 75 39 126 461 0.070028 14.28 6583.08 0.15367 365.7267 28 14 5 14 6 9 0.33333 1 5 0.55556 0.2093 0 true)
     (181 54 24 2 103 115 24 273 341 139 614 3029 0.035104 28.487 86286.9913 1.0097 4793.7217 86 43 4 43 10 34 0.3301 1 4 0.11765 0.18785 0 true)
     (131 29 12 4 90 66 26 164 244 92 408 1844 0.030957 32.303 59566.7879 0.61467 3309.266 74 37 9 35 6 31 0.34444 1.0571 9 0.29032 0.23664 0 false)
     (15 3 0 0 12 13 11 18 29 24 47 149 0.13131 7.6154 1134.6923 0.049667 63.0385 8 4 1 4 0 5 0.41667 1 1 0.2 0.33333 0 false)
     (112 29 10 4 73 40 17 112 170 57 282 1140 0.042017 23.8 27132 0.38 1507.3333 64 32 0 32 6 26 0.35616 1 0 0 0.23214 0 false)
     (670 81 195 31 394 142 27 575 817 169 1392 7140 0.018293 54.6655 390311.6197 2.38 21683.9789 244 122 13 122 33 85 0.21574 1 13 0.15294 0.12687 0 true)
     (173 59 22 6 92 77 31 277 352 108 629 2945 0.017934 55.7597 164212.4351 0.98167 9122.9131 108 54 0 53 14 40 0.43478 1.0189 0 0 0.23121 0 true)
     (114 32 12 3 70 46 23 134 180 69 314 1329 0.029851 33.5 44521.5 0.443 2473.4167 56 28 1 27 7 22 0.31429 1.037 1 0.045455 0.19298 0 false)
     (148 41 5 0 102 42 16 147 208 58 355 1441 0.035714 28 40348 0.48033 2241.5556 48 24 0 24 7 18 0.17647 1 0 0 0.12162 0 false)
     (10 0 0 0 10 11 7 30 38 18 68 196 0.10476 9.5455 1870.9091 0.065333 103.9394 24 12 1 12 6 7 0.7 1 1 0.14286 0.7 0 false)
     (333 94 53 9 186 56 18 352 469 74 821 3533 0.017677 56.5714 199866.8571 1.1777 11103.7143 114 57 23 56 15 40 0.21505 1.0179 23 0.575 0.12012 0 true)
     )))
