@echo off

set outdir=build
if not exist %outdir% mkdir %outdir%
makensis lazyadb.nsi 
