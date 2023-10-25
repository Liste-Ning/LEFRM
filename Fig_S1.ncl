begin
    a = asciiread("factors.txt", (/168,10/), "float") ;1850-2017
    b = transpose(a)
    ; printMinMax(b, 0)

    time               = ispan(1850, 2017, 1)
    time@units         = "year since 1850"
    time!0             = "time"
    time&time          = time   

   pltName                           = "Fig.S3"
    wks                               = gsn_open_wks("eps",pltName)    

    res                               = True
    res@gsnDraw                       = False                  ; don't draw
    res@gsnFrame                      = False                   ; don't advance frame

    res@vpHeightF                     = 0.4
    res@vpWidthF                      = 0.7
    res@xyDashPattern                 = 0
    res@xyMarkLineMode                = "Lines"
    res@tmXBLabelFontHeightF          = 0.02 
    res@tmYLLabelFontHeightF          = 0.02
    res@xyLineThicknesses             = (/3,3,3,3,3,3,3,3,3,3,3/)

    res@trYMinF                       = -4.
    res@trYMaxF                       = 3.
    res@trXMinF                       = 1850
    res@trXMaxF                       = 2017
    res@tiMainFontHeightF             = 0.035

    res@tiXAxisFontHeightF            = 0.02
    res@tiYAxisFontHeightF            = 0.02

    res@lgPerimOn                     = False
    res@tmXBMajorOutwardLengthF       = False
    res@tmYLMajorOutwardLengthF       = False
    res@tmXBMinorOn                   = False
    res@tmYLMinorOn                   = False
    res@tmYROn                        = False
    res@tmXTOn                        = False

    res@lgBoxMinorExtentF             = 0.13        ; Shorten the legend lines
    res@lgPerimOn                     = False       ; turn off box around
    res@lgLabelFontHeightF            = 0.015        ; label f

    ; res@tiYAxisString                 = "Temperature anomaly/~S~o~N~C"

    res@xyLineColors                 = (/"lightblue3","red2","orange","deepskyblue3",\
                                        "forestgreen","coral4","mediumpurple","hotpink","mediumorchid4","grey27"/)
    plot                           = gsn_csm_xy(wks, time, b, res)

;======加图例==================================================
    txres                      = True                      ; text mods desired
    txres@txFontHeightF        = 0.016                      ; text font height
    txres@txJust               = "CenterLeft"

    lineres                    = True        ; polyline mods desired
    lineres@gsLineColor        = "lightblue3"   ; line color
    lineres@gsLineThicknessF   = 3.         ; line thicker
    lineres@gsLineDashPattern  = 0   ; dash pattern

    gsn_polyline(wks,plot,(/1860,1872/),(/2.6,2.6/),lineres)  
    gsn_text(wks,plot,"Natural",1875,2.6,txres)

    lineres@gsLineColor        = "red2"   ; line color
    gsn_polyline(wks,plot,(/1860,1872/),(/2.2,2.2/),lineres)  
    gsn_text(wks,plot,"CO2",1875,2.2,txres)

    lineres@gsLineColor        = "orange"   ; line color
    gsn_polyline(wks,plot,(/1860,1872/),(/1.8,1.8/),lineres)  
    gsn_text(wks,plot,"OtherGHG",1875,1.8,txres)

    lineres@gsLineColor        = "deepskyblue3"   ; line color
    gsn_polyline(wks,plot,(/1860,1872/),(/1.4,1.4/),lineres)  
    gsn_text(wks,plot,"Aerosol",1875,1.4,txres)

    lineres@gsLineColor        = "forestgreen"   ; line color
    gsn_polyline(wks,plot,(/1860,1872/),(/1.,1./),lineres)  
    gsn_text(wks,plot,"SOzone",1875,1.,txres)

    lineres@gsLineColor        = "coral4"   ; line color
    gsn_polyline(wks,plot,(/1910,1922/),(/2.6,2.6/),lineres)  
    gsn_text(wks,plot,"TOzone",1925,2.6,txres)

    lineres@gsLineColor        = "mediumpurple"   ; line color
    gsn_polyline(wks,plot,(/1910,1922/),(/2.2,2.2/),lineres)  
    gsn_text(wks,plot,"WaterVapour",1925,2.2,txres)

    lineres@gsLineColor        = "hotpink"   ; line color
    gsn_polyline(wks,plot,(/1910,1922/),(/1.8,1.8/),lineres)  
    gsn_text(wks,plot,"Landuse",1925,1.8,txres)

    lineres@gsLineColor        = "mediumorchid4"   ; line color
    gsn_polyline(wks,plot,(/1910,1922/),(/1.4,1.4/),lineres)  
    gsn_text(wks,plot,"SnowBC",1925,1.4,txres)

    lineres@gsLineColor        = "grey27"   ; line color
    gsn_polyline(wks,plot,(/1910,1922/),(/1.,1./),lineres)  
    gsn_text(wks,plot,"Contrails",1925,1.,txres)

    draw(plot)                                            ; draw
    ; frame(wks) 

    delete (wks)           
    system("convert -geometry 3000x3000 -density 600x600 -trim " + pltName + ".eps " + pltName + ".png")   
    system("rm " + pltName + ".eps -f")

end