; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
; load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/contributed.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/shea_util.ncl"
begin
; ========定义经纬度============================
lat = fspan(-89.5,89.5,180)
lat@units = "degrees_N"
lat@long_name = "latitude"
print(lat)
lon = fspan(0.5,359.5,360)
lon@units = "degrees_E"
lon@long_name = "longitude"
; ==============读取陆地差值数据======================
f = addfile("inter_reSAT2.nc","r")
inter_reSAT2 = f->inter_masked_reSAT2
inter_reSAT2!0 = "time"
inter_reSAT2!1 = "lat"
inter_reSAT2!2 = "lon"
inter_reSAT2&lat = lat
inter_reSAT2&lon = lon
inter_reSAT2@_FillValue = 9.96920997E+36
printVarSummary(inter_reSAT2)

trun := new(dimsizes(inter_reSAT2),"float")
trun(:,:,:179) = inter_reSAT2(:,:,180:)
trun(:,:,180:) = inter_reSAT2(:,:,:179)
trun!0 = "time"
trun!1 = "lat"
trun!2 = "lon"
trun&lat = lat
trun&lon = lon
; ===============读取海洋差值数据========================
f = addfile("SST_inter.nc","r")
SST_inter = f->SST_inter
SST_inter@_FillValue = -999.
SST_inter&lat = lat
SST_inter&lon = lon
printVarSummary(SST_inter)
;==============mask海陆数据=====================================
f     := addfile("/wind1/home/lizch9/recon/2022_recon/LF/landsea.nc","r")
lsmask = f->LSMASK
interreSAT2 = mask(trun,(lsmask.eq.0 .or. lsmask.eq.2 .or. lsmask.eq.4),False)
copy_VarCoords(trun,interreSAT2)
SSTinter = mask(SST_inter,(lsmask.eq.0 .or. lsmask.eq.2 .or. lsmask.eq.4),True)
copy_VarCoords(SST_inter,SSTinter)
;==============融合海洋和陆地数据=====================================
tas = interreSAT2
tas = where(ismissing(tas),SSTinter,tas)
tas!0 = "time"
tas!1 = "lat"
tas!2 = "lon"
tas&lat = lat
tas&lon = lon
printVarSummary(tas)

year = ispan(1850,2022,1)
year@long_name = "year"

; ================按照7:3的比例计算海陆全球平均====================
wgt     := latRegWgt(lat, "float", 0)
masked_land = mask(tas,(lsmask.eq.0 .or. lsmask.eq.2 .or. lsmask.eq.4),False)
copy_VarCoords(tas,masked_land)
masked_sea = mask(tas,(lsmask.eq.0 .or. lsmask.eq.2 .or. lsmask.eq.4),True)
copy_VarCoords(tas,masked_sea)
tas_avg_l = wgt_areaave_Wrap(masked_land , wgt, 1.0, 1)
mean_lst=month_to_annual(tas_avg_l,1)
tas_avg_s = wgt_areaave_Wrap(masked_sea , wgt, 1.0, 1)
mean_sst=month_to_annual(tas_avg_s,1)

system("/bin/rm lst_and_sst.txt")
write_table("lst_and_sst.txt","w",[/mean_lst,mean_sst/],"%10.6f %10.6f")

end
