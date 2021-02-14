
'reinit'

* Open the GrADS data descriptor file
'open lis_output.ctl'

* Set GrADS output to file write
'set gxout fwrite'

* Set file write options and filename
*"-be" = big_endian
*"-st" = stream (aka, direct-access)
'set fwrite -be -st forcing_mask.1gd4r'

* Set all points with valid forcing to "1.0"
'define mask=const(tair_f_tavg,1.0)'

* Set all points without valid forcing to "0.0"
'define mask=const(mask,0.0,-u)'

* Write the mask to the output file
'd mask'

* Close the file
'disable fwrite'

