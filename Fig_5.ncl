begin 
    a = asciiread("6_data_1850-2022.txt", (/173,6/), "float") ;Imax、Imin、BE、HadCRUT5、NOAA、GISS
    b = asciiread("Obs_LEFRM.txt", (/173,5/), "float");1850-2022;BE、HadCRUT5、BE_avg、HadCRUT5_avg

    Imax_ori = a(:,0)
    Imin_ori = a(:,1)
    BE_ori   = a(:,2)
    Had_ori  = a(:,3)
    NOAA_ori = a(:,4)

    Imax_fin = b(:,0)
    Imin_fin = b(:,1)
    BE_fin   = b(:,2)
    Had_fin  = b(:,3)
    NOAA_fin = b(:,4) 

    data_30      = new((/10,173/), float)
    data_30(0,:) = Imax_ori
    data_30(1,:) = Imax_fin
    data_30(2,:) = Imin_ori
    data_30(3,:) = Imin_fin
    data_30(4,:) = BE_ori
    data_30(5,:) = BE_fin
    data_30(6,:) = Had_ori
    data_30(7,:) = Had_fin
    data_30(8,:) = NOAA_ori
    data_30(9,:) = NOAA_fin

    nwt = 13
    ihp = 0
    fca = 1./6
    fcb = -999
    nsigma = 1.
    wgt = filwgts_lanczos(nwt, ihp, fca, fcb, nsigma)

    Imax_ori_r = wgt_runave(Imax_ori, wgt, 0) 
    Imax_fin_r = wgt_runave(Imax_fin, wgt, 0)
    Imin_ori_r = wgt_runave(Imin_ori, wgt, 0) 
    Imin_fin_r = wgt_runave(Imin_fin, wgt, 0)
    BE_ori_r   = wgt_runave(BE_ori, wgt, 0) 
    BE_fin_r   = wgt_runave(BE_fin, wgt, 0)
    Had_ori_r  = wgt_runave(Had_ori, wgt, 0) 
    Had_fin_r  = wgt_runave(Had_fin, wgt, 0)
    NOAA_ori_r = wgt_runave(NOAA_ori, wgt, 0) 
    NOAA_fin_r = wgt_runave(NOAA_fin, wgt, 0)

    data      = new((/10,173/), float)
    data(0,:) = NOAA_ori_r
    data(1,:) = Had_ori_r
    data(2,:) = BE_ori_r
    data(3,:) = Imin_ori_r
    data(4,:) = Imax_ori_r
    data(5,:) = NOAA_fin_r
    data(6,:) = Had_fin_r
    data(7,:) = BE_fin_r
    data(8,:) = Imin_fin_r
    data(9,:) = Imax_fin_r

    time               = ispan(1850, 2022, 1)
    time@units         = "year since 1850"
    time!0             = "time"
    time&time          = time   

    type         = "eps"
    pltName      = "Fig.5"
    wks          = gsn_open_wks(type,pltName)
    plots        = new(7,graphic)

;==========================================
    bgres                 = True
    bgres@gsFillColor     = "gray91"
    bgres@tfPolyDrawOrder   = "Predraw"                  ; draw this first
    xpts = (/0.1,0.242,0.242,0.1,0.1/)
    ypts = (/0.65,0.65,0.95,0.95,0.65/)
    gsn_polygon_ndc(wks,xpts,ypts,bgres)

;==========滤波=================================
    res1                               = True
    res1@gsnDraw                       = True                   ; don't draw
    res1@gsnFrame                      = False                   ; don't advance frame

    res1@vpHeightF                     = 0.3
    res1@vpWidthF                      = 0.83
    res1@vpXF                          = 0.1
    res1@vpYF                          = 0.95

    res1@xyDashPatterns                = (/14,14,14,14,14,0,0,0,0,0/)
    res1@xyMarkLineMode                = "Lines"
    res1@xyLineThicknesses             = (/3.5,3.5,3.5,3.5,3.5,3.5,3.5,3.5,3.5,3.5/)

    res1@trYMinF                       = -0.8
    res1@trYMaxF                       = 1.2
    res1@trXMinF                       = 1850
    res1@trXMaxF                       = 2022
    res1@xyLineColors                  = (/"darkslateblue","forestgreen","orange","skyblue3","red3",\
                                          "darkslateblue","forestgreen","orange","skyblue3","red3"/)

    res1@tmYLMode                      = "Explicit"
    res1@tmYLValues                    = (/1.2,0.8,0.4,0,-0.4,-0.8/)
    res1@tmYLLabels                    = (/"1.2","0.8","0.4","0.0","-0.4","-0.8"/)


    res1@tiXAxisFontHeightF            = 0.015
    res1@tiYAxisFontHeightF            = 0.015
    res1@tmYLLabelFontHeightF          = 0.015
    res1@tmXBLabelFontHeightF          = 0.015

    res1@tmXBMajorOutwardLengthF       = False
    res1@tmXBMinorOn                   = False

    ; res1@tmYUseLeft                    = False
    ; res1@tmYLLabelsOn                  = True
    res1@tmYLMajorOutwardLengthF       = False
    res1@tmYLMinorOn                   = False
    res1@tmYROn                        = False
    res1@tmXTOn                        = False

    ; res1@tmXBLabelAngleF               = 45
    ; res1@tmXBLabelJust                 = "CenterRight"

    res1@gsnYRefLine                   = 0
    res1@gsnXRefLineColor              = "black"  
    res1@gsnYRefLineThicknesses        = 2.  
    res1@gsnYRefLineDashPattern        = 16

    plots(0)                           = gsn_csm_xy(wks, time, data, res1)

;==========前30年=================================
    res2                               = True
    res2@gsnDraw                       = True                   ; don't draw
    res2@gsnFrame                      = False                   ; don't advance frame

    res2@vpHeightF                     = 0.1
    res2@vpWidthF                      = 0.15
    res2@vpXF                          = 0.1
    res2@vpYF                          = 0.59

    res2@xyDashPatterns                = (/16,0/)
    res2@xyMarkLineMode                = "Lines"
    res2@xyLineThicknesses             = (/3,3/)

    res2@trYMinF                       = -0.8
    res2@trYMaxF                       = 0.2
    res2@trXMinF                       = 1850
    res2@trXMaxF                       = 1880

    res2@tmXBMode                      = "Explicit"
    res2@tmXBValues                    = (/1850,1860,1870,1880/)
    res2@tmXBLabels                    = (/"","1860","1870",""/)

    res2@tmYLMode                      = "Explicit"
    res2@tmYLValues                    = (/0.2,0.0,-0.2,-0.4,-0.6,-0.8/)
    res2@tmYLLabels                    = (/"0.2","0.0","-0.2","-0.4","-0.6","-0.8"/)

    res2@tiXAxisFontHeightF            = 0.012
    res2@tiYAxisFontHeightF            = 0.012
    res2@tmYLLabelFontHeightF          = 0.012
    res2@tmXBLabelFontHeightF          = 0.012

    res2@tmXBMajorOutwardLengthF       = False
    res2@tmXBMinorOn                   = False
    res2@tmYLMajorLengthF              = 0.01
    res2@tmXBMajorLengthF              = 0.01

    ; res2@tmXBLabelAngleF               = 45
    ; res2@tmXBLabelJust                 = "CenterRight"

    res2@tmYLMajorOutwardLengthF       = False
    
    res2@tmYROn                        = False
    res2@tmXTOn                        = False

    res2@xyLineColors                  = (/"red3","red3"/)
    plots(1)                           = gsn_csm_xy(wks, time(0:30), data_30(0:1,0:30), res2)
    
    res2@tmYLLabelsOn                  = False
    res2@vpXF                          = 0.27
    res2@xyLineColors                  = (/"skyblue3","skyblue3"/)
    plots(2)                           = gsn_csm_xy(wks, time(0:30), data_30(2:3,0:30), res2)
   
    res2@vpXF                          = 0.44
    res2@xyLineColors                  = (/"orange","orange"/)
    plots(3)                           = gsn_csm_xy(wks, time(0:30), data_30(4:5,0:30), res2)

    res2@vpXF                          = 0.61
    res2@xyLineColors                  = (/"forestgreen","forestgreen"/)    
    plots(4)                           = gsn_csm_xy(wks, time(0:30), data_30(6:7,0:30), res2)
   
    res2@vpXF                          = 0.78
    res2@xyLineColors                  = (/"darkslateblue","darkslateblue"/)
    plots(5)                           = gsn_csm_xy(wks, time(0:30), data_30(8:9,0:30), res2)

;======加图例==================================================
    txtres                  = True
    txtres@txFontHeightF    = 0.013        ; font height
    txtres@txJust           = "CenterLeft" ; align text to left

    txres                   = True
    txres@txFontHeightF     = 0.016        ; font height
    txres@txJust            = "CenterLeft" ; align text to left    

    pgres                    = True
    pgres@gsLineThicknessF   = 2.5
    pgres@gsLineColor        = "red3"
    pgres@gsLineDashPattern  = 0   ; dash pattern

    gsn_polyline_ndc(wks,(/0.28,0.32/),(/0.925,0.925/),pgres)
    gsn_text_ndc(wks,"CMST2.0-Imax",0.34,0.925,txtres)

    pgres@gsLineColor     = "skyblue3"
    gsn_polyline_ndc(wks,(/0.28,0.32/),(/0.895,0.895/),pgres)
    gsn_text_ndc(wks,"CMST2.0-Imin",0.34,0.895,txtres)

    pgres@gsLineColor     = "orange"
    gsn_polyline_ndc(wks,(/0.28,0.32/),(/0.865,0.865/),pgres)
    gsn_text_ndc(wks,"BE",0.34,0.865,txtres)

    pgres@gsLineColor     = "forestgreen"
    gsn_polyline_ndc(wks,(/0.28,0.32/),(/0.835,0.835/),pgres)
    gsn_text_ndc(wks,"HadCRUT5",0.34,0.835,txtres)

    pgres@gsLineColor     = "darkslateblue"
    gsn_polyline_ndc(wks,(/0.28,0.32/),(/0.805,0.805/),pgres)
    gsn_text_ndc(wks,"NOAAGlobalTemp-Interim",0.34,0.805,txtres) 

    gsn_text_ndc(wks,"(a)",0.12,0.93,txres) 
    gsn_text_ndc(wks,"(b)",0.113,0.573,txres) 
    gsn_text_ndc(wks,"(c)",0.283,0.573,txres) 
    gsn_text_ndc(wks,"(d)",0.453,0.573,txres) 
    gsn_text_ndc(wks,"(e)",0.623,0.573,txres) 
    gsn_text_ndc(wks,"(f)",0.793,0.573,txres) 

    ; drawNDCGrid(wks)
    ; frame(wks)

    delete (wks)           
    system("convert -geometry 3000x3000 -density 600x600 -trim " + pltName + ".eps " + pltName + ".png")   
    system("rm " + pltName + ".eps -f")

end