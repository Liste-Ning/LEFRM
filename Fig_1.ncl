begin
    a = asciiread("6_data_1850-2022.txt", (/173,6/), "float") ;Imax、Imin、BE、HadCRUT5、NOAA、GISS

    data      = new((/6,173/), float)
    data(0,:) = a(:,2)
    data(1,:) = a(:,3)
    data(2,:) = a(:,5)
    data(3,:) = a(:,1)
    data(4,:) = a(:,0)
    data(5,:) = a(:,4)

    time               = ispan(1850, 2022, 1)
    time@units         = "year since 1850"
    time!0             = "time"
    time&time          = time   

    type         = "pdf"
    pltName      = "Fig.1"
    wks          = gsn_open_wks(type,pltName)

    res                               = True
    res@gsnDraw                       = True                   ; don't draw
    res@gsnFrame                      = True                   ; don't advance frame

    res@vpHeightF                     = 0.5
    res@vpWidthF                      = 0.8
    res@vpXF                          = 0.15
    res@xyDashPatterns                = (/0,0,2,2,0,2/)
    res@xyMarkLineMode                = "Lines"
    res@xyLineThicknesses             = (/4,4,4,4,4,4/)

    res@trYMinF                       = -0.8
    res@trYMaxF                       = 1.2
    res@trXMinF                       = 1850
    res@trXMaxF                       = 2022
    res@xyLineColors                  = (/"gray40","midnightblue","deepskyblue1","red3","red3","forestgreen"/)

    res@tmYLMode                      = "Explicit"
    res@tmYLValues                    = (/1.2,0.8,0.4,0,-0.4,-0.8/)
    res@tmYLLabels                    = (/"1.2","0.8","0.4","0.0","-0.4","-0.8"/)

    res@tiXAxisFontHeightF            = 0.025
    res@tiYAxisFontHeightF            = 0.025
    res@tmYLLabelFontHeightF          = 0.025
    res@tmXBLabelFontHeightF          = 0.025
    res@tiMainFontHeightF             = 0.035
    
    res@tmYLMajorThicknessF           = 3.
    res@tmBorderThicknessF            = 3.
    res@tmXBMajorThicknessF           = 3.

    res@tmXBMajorOutwardLengthF       = False
    res@tmXBMinorOn                   = False
    res@tmYLMajorOutwardLengthF       = False
    res@tmYROn                        = False
    res@tmXTOn                        = False
    
    res@gsnYRefLine                   = 0
    res@gsnXRefLineColor              = "black"  
    res@gsnYRefLineThicknesses        = 3.  
    res@gsnYRefLineDashPattern        = 16


;======加图例==================================================
    txtres                = True
    txtres@txFontHeightF  = 0.019        ; font height
    txtres@txJust         = "CenterLeft" ; align text to left

    pgres                 = True
    pgres@gsLineThicknessF = 3.5
    pgres@gsLineColor     = "red3"
    pgres@gsLineDashPattern  = 0   ; dash pattern

    gsn_polyline_ndc(wks,(/0.24,0.31/),(/0.765,0.765/),pgres)
    gsn_text_ndc(wks,"CMST2.0-Imax",0.35,0.765,txtres)

    pgres@gsLineColor        = "red3"
    pgres@gsLineDashPattern  = 2   ; dash pattern
    gsn_polyline_ndc(wks,(/0.24,0.31/),(/0.725,0.725/),pgres)
    gsn_text_ndc(wks,"CMST2.0-Imin",0.35,0.725,txtres)

    pgres@gsLineColor     = "gray40"
    pgres@gsLineDashPattern  = 0   ; dash pattern
    gsn_polyline_ndc(wks,(/0.24,0.31/),(/0.685,0.685/),pgres)
    gsn_text_ndc(wks,"BE",0.35,0.685,txtres)  

    pgres@gsLineColor     = "midnightblue"
    pgres@gsLineDashPattern  = 0   ; dash pattern
    gsn_polyline_ndc(wks,(/0.24,0.31/),(/0.645,0.645/),pgres)
    gsn_text_ndc(wks,"HadCRUT5",0.35,0.645,txtres)

    pgres@gsLineColor     = "deepskyblue1"
    pgres@gsLineDashPattern  = 2   ; dash pattern
    gsn_polyline_ndc(wks,(/0.24,0.31/),(/0.605,0.605/),pgres)
    gsn_text_ndc(wks,"GISTEMP",0.35,0.605,txtres)

    pgres@gsLineColor     = "forestgreen"
    pgres@gsLineDashPattern  = 2   ; dash pattern
    gsn_polyline_ndc(wks,(/0.24,0.31/),(/0.565,0.565/),pgres)
    gsn_text_ndc(wks,"NOAAGlobalTemp-Interim",0.35,0.565,txtres) 

    plot                              = gsn_csm_xy(wks, time, data, res)

    ; delete (wks)           
    ; system("convert -geometry 3000x3000 -density 600x600 -trim " + pltName + ".eps " + pltName + ".png")   
    ; system("rm " + pltName + ".eps -f")

end