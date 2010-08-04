
(deftable  weather forecast temp humidty windy !play)

(! sunny    hot  high   FALSE sad) 
(! sunny    hot  high   TRUE  sad)
(! overcast hot  high   FALSE neutral)
(! rainy    mild high   FALSE yes)
(! rainy    cool normal FALSE neutral)
(! rainy    cool normal TRUE  sad)
(! overcast cool normal TRUE  yes)
(! sunny    mild high   FALSE sad)
(! sunny    cool normal FALSE yes)
(! rainy    mild normal FALSE yes)
(! sunny    mild normal TRUE  yes)
(! overcast mild high   TRUE  yes)
(! overcast hot  normal FALSE yes)
(! rainy    mild high   TRUE   sad)



