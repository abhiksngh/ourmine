;%
;% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;%
;% Case number deleted.
;%
;% As used by Kilpatrick, D. & Cameron-Jones, M. (1998). Numeric prediction
;% using instance-based learning with encoding length selection. In Progress
;% in Connectionist-Based Information Systems. Singapore: Springer-Verlag.
;%
;% !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;%
;% Name:  Pharynx (A clinical Trial in the Trt. of Carcinoma of the Oropharynx).
;% SIZE:  195 observations, 13 variables.
;%
;%
;%
;% DESCRIPTIVE ABSTRACT:
;%
;% The .dat file gives the data for a part of a large clinical trial
;% carried out by the Radiation Therapy Oncology Group in the United States.
;% The full study included patients with squamous carcinoma of 15 sites in
;% the mouth and throat, with 16 participating institutions, though only data
;% on three sites in the oropharynx reported by the six largest institutions
;% are considered here. Patients entering the study were randomly assigned to
;% one of two treatment groups, radiation therapy alone or radiation therapy
;% together with a chemotherapeutic agent.  One objective of the study was to
;% compare the two treatment policies with respect to patient survival.
;%
;%
;%
;% SOURCE:  The Statistical Analysis of Failure Time Data, by JD Kalbfleisch
;%          & RL Prentice, (1980),  Published by John Wiley & Sons
;%
;%
;%
;% VARIABLE DESCRIPTIONS:
;%
;% The data are in free format.  That is, at least one blank space separates
;% each variable in the .dat file.  The variables are as follows:
;%
;%
;% Case:         Case Number
;% Inst:         Participating Institution
;% sex:          1=male, 2=female
;% Treatment:    1=standard, 2=test
;% Grade:        1=well differentiated, 2=moderately differentiated,
;%               3=poorly differentiated,  9=missing
;% Age:          In years at time of diagnosis
;% Condition:    1=no disability, 2=restricted work, 3=requires assistance with
;%               self care, 4=bed confined,  9=missing
;% Site:         1=faucial arch, 2=tonsillar fossa, 3=posterior pillar,
;%               4=pharyngeal tongue, 5=posterior wall
;% T staging:    1=primary tumor measuring 2 cm or less in largest diameter,
;%               2=primary tumor measuring 2 cm to 4 cm in largest diameter with
;%               minimal infiltration in depth, 3=primary tumor measuring more
;%               than 4 cm, 4=massive invasive tumor
;% N staging:    0=no clinical evidence of node metastases, 1=single positive
;%               node 3 cm or less in diameter, not fixed, 2=single positive
;%               node more than 3 cm in diameter, not fixed, 3=multiple
;%               positive nodes or fixed positive nodes
;% Entry Date:   Date of study entry: Day of year and year
;% Status:       0=censored,  1=dead
;% Time:         Survival time in days from day of diagnosis
;%
;%
;%
;%
;%
;%
;% STORY BEHIND THE DATA:
;%
;% Approximately 30% of the survival times are censored owing primarily to
;% patients surviving to the time of analysis. Some patients were lost
;% to follow-up because the patient moved or transferred to an institution not
;% participating in the study, though these cases were relatively rare. From
;% a statistical point of view, an important feature of these data is the
;% considerable lack of homogeneity between individuals being studied.
;% Of course, as part of the study design, certain criteria for patient
;% eligibility had to be met which eliminated extremes in the extent of disease,
;% but still many factors are not controlled.
;%
;% This study included measurements of many covariates which would be expected
;% to relate to survival experience. Six such variables are given in the data
;% (sex, T staging, N staging, age, general condition, and grade).   The site
;% of the primary tumor and possible differences between participating
;% institutions require consideration as well.
;%
;% The T,N staging classification gives a measure of the extent of the tumor at
;% the primary site and at regional lymph nodes. T=1, refers to a small primary
;% tumor, 2 centimeters or less in largest diameter, whereas T=4 is a massive
;% tumor with extension to adjoining tissue. T=2 and T=3 refer to intermediate
;% cases. N=0 refers to there being no clinical evidence of a lymph node
;% metastasis and N=1, N=2, N=3 indicate, in increasing magnitude, the extent of
;% existing lymph node involvement. Patients with classifications T=1,N=0;
;% T=1,N=1;  T=2,N=0; or T=2,N=1, or with distant metastases were excluded
;% from study.
;%
;% The variable general condition gives a measure of the functional capacity of
;% the patient at the time of diagnosis (1 refers to no disability whereas
;% 4 denotes bed confinement; 2 and 3 measure intermediate levels). The variable
;% grade is a measure of the degree of differentiation of the tumor (the degree
;% to which the tumor cell resembles the host cell) from 1 (well differentiated)
;% to 3 (poorly differentiated)
;%
;% In addition to the primary question whether the combined treatment mode is
;% preferable to the conventional radiation therapy, it is of considerable
;% interest to determine the extent to which the several covariates relate to
;% subsequent survival.  It is also imperative in answering the primary question
;% to adjust the survivals for possible imbalance that may be present in the
;% study with regard to the other covariates. Such problems are similar to those
;% encountered in the classical theory of linear regression and the analysis of
;% covariance.  Again, the need to accommodate censoring is an important
;% distinguishing point. In many situations it is also important to develop
;% nonparametric and robust procedures since there is frequently little empirical
;% or theoretical work to support a particular family of failure time
;% distributions.
;%
(defun pharynx ()
  (data
    :name 'pharynx
    :columns '(Inst sex Treatment Grade $Age Condition Site T N $Entry Status $class)
    :egs
    '(
      (2 2 1 1 51 1 2 3 1 2468 1 631)
      (2 1 2 1 65 1 4 2 3 2968 1 270)
      (2 1 1 2 64 2 1 3 3 3368 1 327)
      (2 1 1 1 73 1 1 4 0 5768 1 243)
      (5 1 2 2 64 1 1 4 3 9568 1 916)
      (4 1 2 1 61 1 2 3 0 10668 0 1823)
      (4 1 1 2 65 1 2 4 3 10768 1 637)
      (4 1 2 3 84 1 4 1 3 12068 1 235)
      (6 1 1 2 54 2 1 3 3 13368 1 255)
      (3 1 1 2 72 2 4 2 2 15468 1 184)
      (3 1 1 2 42 1 4 2 2 15468 1 1064)
      (2 1 1 2 61 1 1 4 3 18268 1 414)
      (3 1 2 1 71 1 2 3 1 18468 1 216)
      (4 1 2 2 83 3 4 3 1 19068 1 324)
      (2 1 1 3 43 1 2 4 3 20768 1 480)
      (5 1 2 2 52 1 4 4 3 21768 1 245)
      (4 2 1 3 68 1 4 2 3 22768 0 1565)
      (6 1 2 2 69 1 1 3 0 23368 1 560)
      (3 2 2 3 65 3 1 3 0 25968 1 376)
      (5 1 1 2 58 1 2 4 3 28068 1 911)
      (2 1 2 2 63 1 2 4 3 28068 1 279)
      (4 1 1 2 59 3 2 4 3 28268 1 144)
      (3 1 1 1 75 1 2 3 1 28268 1 1092)
      (6 1 1 1 65 2 1 3 3 28968 1 94)
      (4 1 2 3 41 1 2 4 3 29468 1 177)
      (3 1 1 2 60 1 4 3 3 29868 0 1472)
      (3 1 2 2 72 1 4 1 3 30468 1 526)
      (5 1 2 2 51 1 1 4 3 30868 1 173)
      (2 2 1 2 72 2 2 3 1 30868 1 575)
      (6 1 1 2 49 1 4 3 2 31068 1 222)
      (3 1 2 2 82 3 1 3 0 31868 1 167)
      (2 2 1 2 64 1 1 2 3 32468 1 1565)
      (4 2 2 2 57 2 2 4 3 33568 1 256)
      (3 1 2 1 67 2 2 3 3 33368 1 134)
      (6 1 2 2 65 2 1 3 0 33868 1 404)
      (3 1 2 2 62 1 4 1 2 369 0 1495)
      (2 1 1 2 49 1 4 1 3 769 1 162)
      (5 1 1 2 60 1 4 3 3 969 1 262)
      (3 1 1 2 75 2 2 3 3 1769 1 307)
      (2 1 2 2 54 1 2 2 3 2469 1 782)
      (3 1 2 2 59 1 4 2 2 2469 1 661)
      (5 1 1 2 58 1 1 3 2 3569 1 546)
      (3 1 2 2 50 1 1 4 0 4469 0 1766)
      (2 1 1 1 60 1 1 3 0 4569 1 374)
      (3 2 1 1 43 1 2 2 2 4969 0 1489)
      (4 1 1 2 48 2 2 3 3 5169 0 1446)
      (4 1 2 2 49 3 1 4 3 5669 1 74)
      (3 1 1 1 44 1 1 3 1 2769 0 1609)
      (2 1 1 1 77 1 1 4 1 8369 1 301)
      (2 1 1 1 75 1 2 4 1 9369 1 328)
      (3 1 1 1 54 1 1 3 3 11869 1 459)
      (3 1 1 1 68 1 1 4 0 12569 1 446)
      (6 1 2 3 58 1 4 3 2 12769 0 1644)
      (2 1 2 3 66 1 2 4 3 12969 1 494)
      (3 1 2 1 47 1 1 3 2 13269 1 279)
      (5 1 1 2 60 1 4 3 2 13569 1 915)
      (2 1 1 2 66 1 4 4 2 14369 1 228)
      (3 1 1 3 51 1 1 3 3 15569 1 127)
      (2 2 1 1 49 1 1 3 0 15669 1 1574)
      (6 1 1 1 50 1 2 4 0 16669 1 561)
      (2 2 1 1 52 1 4 4 3 16769 1 370)
      (2 1 2 2 40 1 4 4 3 17869 1 805)
      (4 1 2 2 69 1 1 3 3 19969 1 192)
      (5 1 2 2 56 1 2 1 3 20469 1 273)
      (5 2 2 3 70 2 4 4 3 20469 0 1377)
      (3 2 2 3 47 1 4 3 2 23069 1 407)
      (3 1 1 3 46 1 2 3 1 24569 1 929)
      (3 1 2 1 53 1 4 2 3 26669 1 548)
      (3 1 2 1 67 1 4 3 1 27969 0 1317)
      (3 2 2 1 68 1 4 3 1 26869 0 1317)
      (2 1 1 2 90 1 4 3 3 28069 1 517)
      (3 2 1 3 44 1 4 3 2 28969 0 1307)
      (5 1 2 2 48 1 1 4 2 29069 1 230)
      (4 1 1 2 67 1 2 3 1 30469 1 763)
      (5 2 1 2 58 2 4 4 3 30469 1 172)
      (4 1 2 2 69 1 1 3 2 32869 0 1455)
      (4 1 2 2 75 1 4 3 0 32869 0 1234)
      (6 1 2 3 58 1 2 3 3 33069 1 544)
      (3 1 1 1 72 1 4 3 3 33269 1 800)
      (6 1 1 2 72 1 1 3 0 33569 0 1460)
      (6 1 1 3 70 1 4 2 3 33669 1 785)
      (6 1 1 2 71 1 2 4 0 34469 1 714)
      (1 1 2 2 55 1 1 3 1 35369 1 338)
      (3 2 2 1 73 1 1 3 0 36369 1 432)
      (1 1 2 2 50 1 4 3 3 870 0 1312)
      (6 1 2 2 63 2 1 3 0 4270 1 351)
      (2 2 1 1 58 1 2 1 3 4470 1 205)
      (1 2 1 2 56 1 4 3 0 4870 0 1219)
      (6 2 2 2 62 3 4 4 3 4970 1 11)
      (3 2 1 1 55 1 4 2 2 5470 1 666)
      (2 1 1 1 50 2 2 4 3 5770 1 147)
      (3 1 2 1 77 1 4 2 2 7870 0 1060)
      (1 2 1 2 67 1 2 3 2 8270 1 477)
      (3 1 1 3 53 1 2 3 2 9670 0 1058)
      (2 1 2 3 55 1 2 2 2 11070 0 1312)
      (6 1 2 1 71 2 2 3 3 11870 1 696)
      (2 1 1 1 65 1 1 4 3 12470 1 112)
      (1 2 2 2 50 1 2 4 3 13170 1 308)
      (5 1 2 2 61 2 4 4 3 14470 1 15)
      (5 1 2 1 72 2 1 4 0 14670 1 130)
      (4 1 1 1 51 1 2 3 0 15270 1 296)
      (4 1 1 2 59 1 4 3 3 15870 1 293)
      (2 1 2 2 56 1 1 4 0 16070 1 545)
      (3 1 1 2 61 1 1 3 1 16670 0 1086)
      (1 1 1 3 61 1 2 2 3 17470 0 1250)
      (3 1 2 2 68 2 1 3 3 18770 1 147)
      (5 2 1 2 71 2 1 3 3 18970 1 726)
      (2 2 2 2 57 1 2 2 2 19070 1 310)
      (2 1 1 2 72 1 4 3 1 20570 1 599)
      (3 1 1 2 55 1 2 3 0 21170 0 998)
      (4 2 2 3 61 1 2 2 2 21970 0 1089)
      (5 1 1 1 47 1 4 4 1 23170 1 382)
      (4 2 1 3 66 1 2 3 2 24370 0 932)
      (1 1 2 2 52 2 4 4 3 25170 1 264)
      (1 1 2 1 61 2 4 4 3 25470 1 11)
      (5 1 1 1 66 2 2 4 3 25870 0 911)
      (2 1 1 3 64 2 4 4 3 28570 1 89)
      (5 1 1 2 73 1 1 4 0 28770 1 525)
      (2 1 2 2 67 1 1 3 3 31670 0 532)
      (3 1 1 2 68 1 1 2 3 32770 1 637)
      (6 1 1 3 58 2 2 3 3 33370 1 112)
      (6 2 1 1 68 1 4 3 3 33670 0 1095)
      (1 1 1 3 85 2 4 2 2 34170 1 170)
      (4 1 1 2 74 1 1 3 0 34270 0 943)
      (5 1 1 2 53 1 1 4 0 34370 1 191)
      (6 1 2 2 60 1 2 1 2 34470 0 928)
      (3 1 1 3 58 1 2 3 2 35570 0 918)
      (3 1 1 2 66 1 1 1 2 36270 0 825)
      (1 1 1 2 58 2 2 2 3 1271 1 99)
      (2 1 1 2 39 1 4 3 3 1571 1 99)
      (2 1 1 1 54 1 1 4 1 1871 0 933)
      (6 1 2 3 49 1 2 2 3 2271 1 461)
      (6 1 2 2 52 1 1 3 1 2671 1 347)
      (1 1 1 2 35 2 4 3 0 3371 1 372)
      (5 1 2 3 44 1 2 4 3 4371 0 731)
      (5 1 1 ? 81 1 4 3 3 4971 1 363)
      (1 1 2 2 74 2 1 3 0 6771 1 238)
      (4 1 2 2 65 1 4 4 3 7571 0 593)
      (2 2 1 2 66 2 4 4 3 7771 1 219)
      (3 1 1 2 74 2 4 3 2 8871 1 465)
      (1 2 2 3 90 0 2 3 0 10571 1 446)
      (2 1 2 2 60 1 1 4 1 11371 1 553)
      (5 1 2 2 63 1 1 4 1 15371 1 532)
      (2 2 2 2 61 1 4 4 1 15471 1 154)
      (2 1 2 1 67 1 1 4 3 15971 1 369)
      (4 1 1 2 88 1 2 3 0 16171 1 541)
      (5 2 2 3 69 2 4 4 0 18371 1 107)
      (2 1 2 2 46 1 1 4 1 18871 0 854)
      (1 1 1 2 69 1 1 2 2 20171 0 822)
      (6 2 1 2 48 1 2 3 0 20271 1 775)
      (2 1 1 1 77 1 1 4 0 20271 1 336)
      (6 1 2 3 69 1 2 1 3 20271 1 513)
      (6 1 2 3 75 1 4 3 3 20971 0 914)
      (5 1 1 2 71 1 4 4 3 21671 1 757)
      (5 2 1 2 58 1 1 4 3 21871 0 794)
      (3 1 2 2 66 2 2 3 2 22171 1 105)
      (5 2 1 1 44 1 2 4 1 23771 0 733)
      (1 2 2 2 59 1 1 3 1 25371 0 600)
      (2 1 1 2 78 ? 4 4 3 26371 1 266)
      (2 2 2 1 58 2 1 4 3 27371 1 317)
      (2 1 2 3 65 1 4 3 3 28071 1 407)
      (6 2 2 2 53 2 4 3 2 28471 1 346)
      (3 1 2 2 49 1 4 2 2 29471 1 518)
      (1 1 2 2 65 1 2 3 2 29971 1 395)
      (5 1 1 1 59 1 1 4 1 31471 1 81)
      (6 2 2 2 79 1 4 2 2 31971 1 608)
      (6 1 1 1 57 1 2 4 3 32171 0 760)
      (6 1 1 1 54 1 2 4 0 32371 1 343)
      (3 1 2 2 47 1 1 3 0 32671 1 324)
      (1 1 1 2 68 1 1 4 1 33071 1 254)
      (2 1 1 3 63 1 4 2 2 34071 0 751)
      (2 1 1 3 72 1 2 3 3 34271 1 334)
      (6 2 2 1 51 2 2 3 1 34771 1 275)
      (5 2 2 1 43 1 2 3 3 1272 0 546)
      (6 2 2 2 43 2 4 3 3 3572 1 112)
      (1 1 2 2 65 4 4 2 3 4672 0 182)
      (1 1 2 2 54 1 1 4 3 5472 1 209)
      (6 1 2 3 50 1 2 4 3 5572 1 208)
      (2 1 2 2 39 1 1 4 3 5672 1 174)
      (2 1 1 1 46 1 1 4 0 5972 0 651)
      (2 1 2 3 49 1 2 3 3 8072 0 672)
      (1 2 2 2 52 2 1 3 2 8272 1 291)
      (1 2 2 2 69 2 4 4 1 13671 0 723)
      (4 2 1 2 55 1 2 3 0 14372 1 498)
      (4 1 2 2 48 2 2 3 0 14372 0 276)
      (1 1 1 2 20 1 4 2 3 15672 0 90)
      (4 2 1 2 47 1 4 3 3 15772 1 213)
      (5 2 2 2 67 2 4 3 0 20572 1 38)
      (4 2 1 2 66 2 2 3 2 20772 1 128)
      (2 1 1 1 60 1 2 3 0 20972 0 445)
      (2 1 1 1 54 1 2 4 3 22772 1 159)
      (5 1 2 2 54 1 1 3 3 24372 1 219)
      (4 1 2 2 59 2 1 4 0 24872 1 173)
      (5 1 2 3 47 1 1 3 3 27672 0 413)
      (3 1 2 2 57 2 1 3 3 12371 1 274)
      )))
