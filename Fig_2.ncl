begin
    a = asciiread("6_data_1850-2022.txt", (/173,6/), "float") ;Imax、Imin、BE、HadCRUT5、NOAA、GISS

    AVE = dim_avg((a(30:,:)))

    diff = new((/143/),float)
    do i = 0,141
        diff(i+1) = AVE(i+1) - AVE(i)
    end do

    time               = ispan(1880, 2022, 1)
    time@units         = "year since 1850"
    time!0             = "time"
    time&time          = time    

    type         = "eps"
    pltName      = "Fig.2"
    wks          = gsn_open_wks(type,pltName)

    res                               = True
    res@gsnDraw                       = False                   ; don't draw
    res@gsnFrame                      = False                   ; don't advance frame

    res@vpHeightF                     = 0.4
    res@vpWidthF                      = 0.6
    res@xyDashPattern                 = 0
    res@xyMarkLineMode                = "Lines"
    res@tmXBLabelFontHeightF          = 0.02
    res@tmYLLabelFontHeightF          = 0.02
    res@xyLineThicknessF              = 3.
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

    res@lgPerimOn                     = False
    res@tmXBMajorOutwardLengthF       = False
    res@tmYLMajorOutwardLengthF       = False
    res@tmXBMinorOn                   = False
    res@tmYLMinorOn                   = False
    res@tmYROn                        = False
    res@tmXTOn                        = False

    plots                             = new(2,graphic)
    
    res@trYMinF                       = -1.
    res@trYMaxF                       = 1.2
    res@tmYLMode                      = "Explicit"
    res@tmYLValues                    = (/1.2,0.8,0.4,0,-0.4,-0.8/)
    res@tmYLLabels                    = (/"1.2","0.8","0.4","0.0","-0.4","-0.8"/)
    res@xyLineColor                   = "black"
    plots(0)                          = gsn_csm_xy(wks, time, AVE, res)
    
    res@trYMinF                       = -0.5
    res@trYMaxF                       = 0.6
    res@tmYLMode                      = "Explicit"
    res@tmYLValues                    = (/0.6,0.4,0.2,0,-0.2,-0.4/)
    res@tmYLLabels                    = (/"0.6","0.4","0.2","0.0","-0.2","-0.4"/)
    res@xyLineColor                   = "darkgreen"
    plots(1)                          = gsn_csm_xy(wks, time, diff, res)

    txtres                = True
    txtres@txFontHeightF  = 0.015        ; font height
    txtres@txJust         = "CenterLeft" ; align text to left

    pgres                 = True
    pgres@gsLineThicknessF = 3.
    pgres@gsLineColor     = "black"

    gsn_polyline_ndc(wks,(/0.16,0.2/),(/0.61,0.61/),pgres)
    gsn_text_ndc(wks,"AVE",0.22,0.61,txtres)

    pgres@gsLineColor     = "darkgreen"
    gsn_polyline_ndc(wks,(/0.66,0.7/),(/0.61,0.61/),pgres)
    gsn_text_ndc(wks,"First Difference",0.72,0.61,txtres)

    ; drawNDCGrid(wks)

    resPanel                                             = True
    resPanel@gsnPanelFigureStrings                       = (/"(a)","(b)"/)
    resPanel@gsnPanelFigureStringsFontHeightF            = 0.02
    resPanel@amJust                                      = "TopLeft"    ;位置，默认是在右下方
    resPanel@gsnPanelFigureStringsPerimOn                = False          ;去掉方框的边框
    resPanel@gsnPanelFigureStringsBackgroundFillColor    = -1                ;方框背景设置为透明

    gsn_panel(wks,plots,(/1,2/),resPanel)
    ; frame(wks)

    delete (wks)           
    system("convert -geometry 3000x3000 -density 600x600 -trim " + pltName + ".eps " + pltName + ".png")   
    system("rm " + pltName + ".eps -f")

end