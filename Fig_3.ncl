begin
    a = asciiread("6_data_1850-2022.txt", (/173,6/), "float") ;Imax、Imin、BE、HadCRUT5、NOAA、GISS
    AVG = dim_avg((a(30:,:)))

    AVE         = new((/2,143/),float)
    AVE(0,:)    =AVG
    AVE(1,:137) =a(30:167,1)

    time               = ispan(1850, 2022, 1)
    time@units         = "year since 1850"
    time!0             = "time"
    time&time          = time    

    IV = AVE(0,:137) - AVE(1,:137)

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    a = asciiread("factors.txt", (/168,10/), "float") ;1850-2017
    b = asciiread("stand_coefficient_std_avg_6data.txt", (/10,3/), "float")

    x = ispan(1,10,1)

    time1               = ispan(1850, 2017, 1)
    time1@units         = "year since 1850"
    time1!0             = "time1"
    time1&time1         = time1 

    data_f     = new((/10,168/),float)
    data_f(0,:) = a(:,0)*b(0,0)
    data_f(1,:) = a(:,1)*b(1,0)
    data_f(2,:) = a(:,2)*b(2,0)
    data_f(3,:) = a(:,3)*b(3,0)
    data_f(4,:) = a(:,4)*b(4,0)
    data_f(5,:) = a(:,5)*b(5,0)
    data_f(6,:) = a(:,6)*b(6,0)
    data_f(7,:) = a(:,7)*b(7,0)
    data_f(8,:) = a(:,8)*b(8,0)
    data_f(9,:) = a(:,9)*b(9,0)

    x0 = new((/336/), float )
    y0 = new((/336/), float )    
    x1 = new((/336/), float )
    y1 = new((/336/), float )  
    x2 = new((/336/), float )
    y2 = new((/336/), float )   
    x3 = new((/336/), float )
    y3 = new((/336/), float )
    x4 = new((/336/), float )
    y4 = new((/336/), float )    
    x5 = new((/336/), float )
    y5 = new((/336/), float )  
    x6 = new((/336/), float )
    y6 = new((/336/), float )   
    x7 = new((/336/), float )
    y7 = new((/336/), float )  
    x8 = new((/336/), float )
    y8 = new((/336/), float )  
    x9 = new((/336/), float )
    y9 = new((/336/), float )  

    do k=0,167
        y0(k)          = a(k,0)*b(0,1)
        y1(k)          = a(k,1)*b(1,1)
        y2(k)          = a(k,2)*b(2,1)
        y3(k)          = a(k,3)*b(3,1)
        y4(k)          = a(k,4)*b(4,1)
        y5(k)          = a(k,5)*b(5,1)
        y6(k)          = a(k,6)*b(6,1)
        y7(k)          = a(k,7)*b(7,1)
        y8(k)          = a(k,8)*b(8,1)
        y9(k)          = a(k,9)*b(9,1)
        x0(k)          = time(k)
        x1(k)          = time(k)
        x2(k)          = time(k)
        x3(k)          = time(k)
        x4(k)          = time(k)
        x5(k)          = time(k)
        x6(k)          = time(k)
        x7(k)          = time(k)
        x8(k)          = time(k)
        x9(k)          = time(k)
        x0(2*168-1-k)  = time(k)
        x1(2*168-1-k)  = time(k)
        x2(2*168-1-k)  = time(k)
        x3(2*168-1-k)  = time(k)
        x4(2*168-1-k)  = time(k)
        x5(2*168-1-k)  = time(k)
        x6(2*168-1-k)  = time(k)
        x7(2*168-1-k)  = time(k)
        x8(2*168-1-k)  = time(k)
        x9(2*168-1-k)  = time(k)        
        y0(2*168-1-k)  = a(k,0)*b(0,2)
        y1(2*168-1-k)  = a(k,1)*b(1,2)
        y2(2*168-1-k)  = a(k,2)*b(2,2)
        y3(2*168-1-k)  = a(k,3)*b(3,2)
        y4(2*168-1-k)  = a(k,4)*b(4,2)
        y5(2*168-1-k)  = a(k,5)*b(5,2)
        y6(2*168-1-k)  = a(k,6)*b(6,2)
        y7(2*168-1-k)  = a(k,7)*b(7,2)
        y8(2*168-1-k)  = a(k,8)*b(8,2)
        y9(2*168-1-k)  = a(k,9)*b(9,2)
    end do

    type         = "eps"
    pltName      = "Fig.3"
    wks          = gsn_open_wks(type,pltName)

    res                               = True
    res@gsnDraw                       = False                   ; don't draw
    res@gsnFrame                      = False                   ; don't advance frame

    res@vpHeightF                     = 0.4
    res@vpWidthF                      = 0.6
    res@xyMarkLineModes               = "Lines"
    ; res@tiYAxisString                 = "Temperature anomaly/~S~o~N~C"

    res@trXMinF                       = 1880
    res@trXMaxF                       = 2022
    res@tiMainFontHeightF             = 0.035

    res@gsnYRefLine                   = 0
    res@gsnXRefLineColor              = "black"  
    res@gsnYRefLineThicknesses        = 2.  
    res@gsnYRefLineDashPattern        = 16

    res@tiXAxisFontHeightF            = 0.02
    res@tiYAxisFontHeightF            = 0.02
    res@tmXBLabelFontHeightF          = 0.02
    res@tmYLLabelFontHeightF          = 0.02

    res@lgPerimOn                     = False
    res@tmXBMajorOutwardLengthF       = False
    res@tmYLMajorOutwardLengthF       = False
    res@tmXBMinorOn                   = False
    res@tmYLMinorOn                   = False
    res@tmYROn                        = False
    res@tmXTOn                        = False

    res@tmXBMode                      = "Explicit"
    ; res@tmXBValues                    =(/1880,1900,1920,1940,1960,1980,2000/)
    ; res@tmXBLabels                    =(/1880,1900,1920,1940,1960,1980,2000/)

    plots                             = new(3,graphic)

    res@xyDashPatterns                = (/0,0/)
    res@xyLineThicknesses             = (/3.,3./)
    res@xyLineColors                  = (/"red3","dodgerblue3"/)

    res@trYMinF                       = -1.
    res@trYMaxF                       = 1.2
    res@tmYLValues                    = (/1.2,0.8,0.4,0,-0.4,-0.8/)
    res@tmYLLabels                    = (/"1.2","0.8","0.4","0.0","-0.4","-0.8"/)

    plots(0)                          = gsn_csm_xy(wks, time(30:), AVE, res)

    res@trYMinF                       = -0.5
    res@trYMaxF                       = 0.6
    res@tmYLMode                      = "Explicit"
    res@tmYLValues                    = (/0.6,0.4,0.2,0,-0.2,-0.4/)
    res@tmYLLabels                    = (/"0.6","0.4","0.2","0.0","-0.2","-0.4"/)

    res@xyDashPatterns                = (/0,0/)
    res@xyLineColors                  = (/"dodgerblue3","dodgerblue3"/)

    plots(1)                          = gsn_csm_xy(wks, time(30:167), IV, res)

;================================================================
    res@vpHeightF                     = 0.45
    res@vpWidthF                      = 1.285
    res@xyDashPatterns               := 0
   
    res@xyLineThicknesses            := (/3,3,3,3,3,3,3,3,3,3,3/)

    res@trYMinF                       = -1.2
    res@trYMaxF                       = 2.
    res@trXMinF                       = 1880
    res@trXMaxF                       = 2017

    res@tmYLValues                   := (/2.,1.5,1.,0.5,0,-0.5,-1.0/)
    res@tmYLLabels                   := (/"2.0","1.5","1.0","0.5","0.0","-0.5","-1.0"/)

    res@tmYLMajorLengthF              = 0.015
    res@tmXBMajorLengthF              = 0.015

    ; res@lgBoxMinorExtentF             = 0.13        ; Shorten the legend lines
    ; res@lgPerimOn                     = False       ; turn off box around
    ; res@lgLabelFontHeightF            = 0.015        ; label f

    res@xyLineColors                 := (/"lightblue3","red2","orange","deepskyblue3","forestgreen",\
                                        "coral4","mediumpurple","hotpink","mediumorchid4","grey27"/)
    plots(2)                          = gsn_csm_xy(wks, time1, data_f, res)

;=====画不确定性范围============================================
    gsres                   = True                        ; poly res
    gsres@tfPolyDrawOrder   = "Predraw"                  ; draw this first
    gsres@gsFillOpacityF    = 0.1
   
    gsres@gsFillColor       = "lightblue3"                 ; color chosen
    dummy0 = gsn_add_polygon (wks,plots(2),x0,y0,gsres)

    gsres@gsFillColor       = "red2"                 ; color chosen
    dummy1 = gsn_add_polygon (wks,plots(2),x1,y1,gsres)
    
    gsres@gsFillColor       = "orange"                 ; color chosen  
    dummy2 = gsn_add_polygon (wks,plots(2),x2,y2,gsres)

    gsres@gsFillColor       = "deepskyblue3"                 ; color chosen  
    dummy3 = gsn_add_polygon (wks,plots(2),x3,y3,gsres)

    gsres@gsFillColor       = "forestgreen"                 ; color chosen
    dummy4 = gsn_add_polygon (wks,plots(2),x4,y4,gsres)

    gsres@gsFillColor       = "coral4"                 ; color chosen
    dummy5 = gsn_add_polygon (wks,plots(2),x5,y5,gsres)
    
    gsres@gsFillColor       = "mediumpurple"                 ; color chosen  
    dummy6 = gsn_add_polygon (wks,plots(2),x6,y6,gsres)

    gsres@gsFillColor       = "hotpink"                 ; color chosen  
    dummy7 = gsn_add_polygon (wks,plots(2),x7,y7,gsres)

    gsres@gsFillColor       = "mediumorchid4"                 ; color chosen  
    dummy8 = gsn_add_polygon (wks,plots(2),x8,y8,gsres)

    gsres@gsFillColor       = "grey27"                 ; color chosen  
    dummy9 = gsn_add_polygon (wks,plots(2),x9,y9,gsres)

; ;======加图例==================================================
    txres                      = True                      ; text mods desired
    txres@txFontHeightF        = 0.015                     ; text font height
    txres@txJust               = "CenterLeft"

    pgres                      = True
    pgres@gsLineThicknessF     = 3.
    pgres@gsLineDashPattern    = 0   ; dash pattern

    ; pgres@gsLineColor     = "black"
    ; pgres@gsLineDashPattern = (/2/)
    ; gsn_polyline_ndc(wks,(/0.11,0.15/),(/0.87,0.87/),pgres)
    ; gsn_text_ndc(wks,"CMST2.0-Imax",0.17,0.87,txres)

    pgres@gsLineColor     = "red3"
    pgres@gsLineDashPattern = (/0/)
    gsn_polyline_ndc(wks,(/0.11,0.15/),(/0.86,0.86/),pgres)
    gsn_text_ndc(wks,"AVE",0.17,0.86,txres)
    
    pgres@gsLineColor     = "dodgerblue3"
    gsn_polyline_ndc(wks,(/0.11,0.15/),(/0.82,0.82/),pgres)
    gsn_text_ndc(wks,"External Forcing [90.5%]",0.17,0.82,txres)

    gsn_polyline_ndc(wks,(/0.62,0.66/),(/0.85,0.85/),pgres)
    gsn_text_ndc(wks,"Internal Variability",0.68,0.85,txres)    
    
    ;+++++++++++++++++++++++++++++++++++++++++++++++
    pgres@gsLineColor     = "lightblue3"
    gsn_polyline_ndc(wks,(/0.15,0.19/),(/0.53,0.53/),pgres)
    gsn_text_ndc(wks,"Natural",0.21,0.53,txres)

    pgres@gsLineColor     = "red2"
    gsn_polyline_ndc(wks,(/0.15,0.19/),(/0.495,0.495/),pgres)
    gsn_text_ndc(wks,"CO2",0.21,0.495,txres)

    pgres@gsLineColor     = "orange"
    gsn_polyline_ndc(wks,(/0.15,0.19/),(/0.46,0.46/),pgres)
    gsn_text_ndc(wks,"OtherGHG",0.21,0.46,txres)

    pgres@gsLineColor     = "deepskyblue3"
    gsn_polyline_ndc(wks,(/0.15,0.19/),(/0.425,0.425/),pgres)
    gsn_text_ndc(wks,"Aerosol",0.21,0.425,txres)

    pgres@gsLineColor     = "forestgreen"
    gsn_polyline_ndc(wks,(/0.35,0.39/),(/0.53,0.53/),pgres)
    gsn_text_ndc(wks,"SOzone",0.41,0.53,txres)

    pgres@gsLineColor      = "coral4"
    gsn_polyline_ndc(wks,(/0.35,0.39/),(/0.495,0.495/),pgres)
    gsn_text_ndc(wks,"TOzone",0.41,0.495,txres)

    pgres@gsLineColor     = "mediumpurple"
    gsn_polyline_ndc(wks,(/0.35,0.39/),(/0.46,0.46/),pgres)
    gsn_text_ndc(wks,"WaterVapour",0.41,0.46,txres)

    pgres@gsLineColor     = "hotpink"
    gsn_polyline_ndc(wks,(/0.35,0.39/),(/0.425,0.425/),pgres)
    gsn_text_ndc(wks,"Landuse",0.41,0.425,txres)

    pgres@gsLineColor     = "mediumorchid4"
    gsn_polyline_ndc(wks,(/0.58,0.62/),(/0.53,0.53/),pgres)
    gsn_text_ndc(wks,"SnowBC",0.64,0.53,txres)

    pgres@gsLineColor     = "grey27"
    gsn_polyline_ndc(wks,(/0.58,0.62/),(/0.495,0.495/),pgres)
    gsn_text_ndc(wks,"Contrails",0.64,0.495,txres)

    ; drawNDCGrid(wks)
    resPanel                                             = True
    resPanel@gsnPanelFigureStrings                       = (/"(a)","(b)","(c)"/)
    resPanel@gsnPanelFigureStringsFontHeightF            = 0.02
    resPanel@amJust                                      = "TopLeft"    ;位置，默认是在右下方
    resPanel@gsnPanelFigureStringsPerimOn                = False          ;去掉方框的边框
    resPanel@gsnPanelFigureStringsBackgroundFillColor    = -1                ;方框背景设置为透明

    resPanel@gsnPanelRowSpec                             = True 
    resPanel@gsnPanelDebug                               = True
    ; resPanel@gsnPanelCenter                              = False

    resPanel@gsnPanelXF                                  = (/0.06,0.56,0.06/)   
    resPanel@gsnPanelYF                                  = (/0.9,0.9,0.55/) 

    gsn_panel(wks,plots,(/2,1/),resPanel)
    ; frame(wks) 

    delete (wks)           
    system("convert -geometry 3000x3000 -density 600x600 -trim " + pltName + ".eps " + pltName + ".png")   
    system("rm " + pltName + ".eps -f")
end
