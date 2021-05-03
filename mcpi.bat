setlocal
set exec=mcpi_sequential.exe
if exist %exec% del %exec%
ifort -nologo mcpi_sequential.f90
if exist %exec% %exec%
:coa
set exec=mcpi_coarray_final.exe
if exist %exec% del %exec%
ifort -nologo /Qcoarray mcpi_coarray_final.f90
if exist %exec% %exec%
