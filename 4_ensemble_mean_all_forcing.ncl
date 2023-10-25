begin
;================all========================
    diri = "/cygdrive/g/model_data/tas_50/all/"
    fils = systemfunc ("ls "+ diri + "*1850-2022.nc")
    print(fils)
    print(dimsizes(fils))

    lat = fspan(-89.5,89.5,180)
    lat@units = "degrees_N"
    lat@long_name = "latitude"
    ; print(lat)
    lon = fspan(0.5,359.5,360)
    lon@units = "degrees_E"
    lon@long_name = "longitude"

    ave = new((/173,dimsizes(fils)/), float)

    do m = 0,dimsizes(fils)-1
        print("")
        print(m+1 + " Now reading..." + fils(m))   ;过程监控
        f   := addfile(fils(m), "r")

        inter := f->t
        inter!0 = "time"
        inter!1 = "lat"
        inter!2 = "lon"
        inter&lat = lat
        inter&lon = lon
        inter@_FillValue = 9.96920997E+36
        inter = where(inter .lt. -100, 9.96920997E+36, inter)
        printVarSummary(inter)
        printMinMax(inter, 0)

        tas := new(dimsizes(inter),"float")
        tas(:,:,:179) = inter(:,:,180:)
        tas(:,:,180:) = inter(:,:,:179)
        tas!0 = "time"
        tas!1 = "lat"
        tas!2 = "lon"
        tas&lat = lat
        tas&lon = lon
        printVarSummary(tas)

        f     := addfile("/cygdrive/g/model_data/tas_50/landsea.nc","r")
        lsmask = f->LSMASK
        wgt     := latRegWgt(lat, "float", 0)
        masked_land = mask(tas,(lsmask.eq.0 .or. lsmask.eq.2 .or. lsmask.eq.4),False)
        copy_VarCoords(tas,masked_land)
        masked_sea = mask(tas,(lsmask.eq.0 .or. lsmask.eq.2 .or. lsmask.eq.4),True)
        copy_VarCoords(tas,masked_sea)
        tas_avg_l = wgt_areaave_Wrap(masked_land , wgt, 1.0, 1)
        tas_avg_s = wgt_areaave_Wrap(masked_sea , wgt, 1.0, 1)

        y := tas_avg_l*0.29 + tas_avg_s*0.71
        ave(:,m) = y
    end do

    AVG        = dim_avg_n(ave, 1)
    
    write_table("all_forcing.txt", "w", [/AVG/], "%10.6f")

end