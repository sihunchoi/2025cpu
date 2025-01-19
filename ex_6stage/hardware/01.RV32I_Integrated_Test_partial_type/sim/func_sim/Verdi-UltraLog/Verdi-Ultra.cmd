verdiSetActWin -dock widgetDock_<Message>
debImport "-sv" "-f" "run.f"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
verdiWindowResize -win $_Verdi_1 -10 "19" "1298" "700"
verdiWindowResize -win $_Verdi_1 -10 "19" "1298" "700"
schCreateWindow -delim "." -win $_nSchema1 -scope "flopenr"
wvCreateWindow
verdiSetActWin -win $_nWave3
verdiSetActWin -dock widgetDock_<Decl._Tree>
srcTBBTreeSelect -win $_nTrace1 -path "ASYNC_RAM_DP_WBE"
verdiDockWidgetSetCurTab -dock widgetDock_<Inst._Tree>
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "cpu_tb" -win $_nTrace1
schCreateWindow -delim "." -win $_nSchema1 -scope "flopenr"
wvCreateWindow
wvSetPosition -win $_nWave5 {("G1" 0)}
wvOpenFile -win $_nWave5 \
           {/home/std249/2024lab_cpu/week1x_final_project/hardware/01.RV32I_Integrated_Test_partial_type/sim/func_sim/wave.fsdb}
verdiSetActWin -win $_nSchema_4
schFit -win $_nSchema4
verdiDockWidgetSetCurTab -dock windowDock_nSchema_2
verdiSetActWin -win $_nSchema_2
verdiDockWidgetSetCurTab -dock windowDock_nSchema_4
verdiSetActWin -win $_nSchema_4
verdiDockWidgetSetCurTab -dock widgetDock_MTB_SOURCE_TAB_1
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcHBSelect "flopenr" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBSelect "cpu_tb" -win $_nTrace1
srcHBSelect "cpu_tb" -win $_nTrace1
srcSetScope "cpu_tb" -delim "." -win $_nTrace1
srcHBSelect "cpu_tb" -win $_nTrace1
srcHBSelect "cpu_tb" -win $_nTrace1
srcSetScope "cpu_tb" -delim "." -win $_nTrace1
srcHBSelect "cpu_tb" -win $_nTrace1
schCreateWindow -delim "." -win $_nSchema1 -scope "cpu_tb"
verdiSetActWin -win $_nSchema_6
schSelect -win $_nSchema6 -signal "DATA_ADDR0\[14:0\]"
schDeselectAll -win $_nSchema6
schSelect -win $_nSchema6 -inst "CPU"
schZoomIn -win $_nSchema6 -pos 29787 1794
schZoomIn -win $_nSchema6 -pos 29786 1794
schZoomIn -win $_nSchema6 -pos 29787 1794
schSelect -win $_nSchema6 -inst "CPU"
schPushViewIn -win $_nSchema6
schSelect -win $_nSchema6 -instport "icpu" "Instr\[31:0\]"
schSelect -win $_nSchema6 -signal "ReadData\[31:0\]"
schSelect -win $_nSchema6 -signal "Instr\[31:0\]"
schFit -win $_nSchema6
schPopViewUp -win $_nSchema6
schSelect -win $_nSchema6 -signal "clk"
schSelect -win $_nSchema6 -inst "CPU"
schSelect -win $_nSchema6 -inst "CPU"
wvGetSignalOpen -win $_nWave5
wvGetSignalSetScope -win $_nWave5 "/cpu_tb"
verdiSetActWin -win $_nWave5
wvGetSignalSetScope -win $_nWave5 "/cpu_tb/CPU"
wvGetSignalSetScope -win $_nWave5 "/cpu_tb/CPU/imem"
wvGetSignalSetScope -win $_nWave5 "/cpu_tb/CPU/icpu"
wvSetPosition -win $_nWave5 {("G1" 2)}
wvSetPosition -win $_nWave5 {("G1" 2)}
wvAddSignal -win $_nWave5 -clear
wvAddSignal -win $_nWave5 -group {"G1" \
{/cpu_tb/CPU/icpu/PCSrc\[1:0\]} \
{/cpu_tb/CPU/icpu/PC\[31:0\]} \
}
wvAddSignal -win $_nWave5 -group {"G2" \
}
wvSelectSignal -win $_nWave5 {( "G1" 1 2 )} 
wvSetPosition -win $_nWave5 {("G1" 2)}
wvSetPosition -win $_nWave5 {("G1" 2)}
wvSetPosition -win $_nWave5 {("G1" 2)}
wvAddSignal -win $_nWave5 -clear
wvAddSignal -win $_nWave5 -group {"G1" \
{/cpu_tb/CPU/icpu/PCSrc\[1:0\]} \
{/cpu_tb/CPU/icpu/PC\[31:0\]} \
}
wvAddSignal -win $_nWave5 -group {"G2" \
}
wvSelectSignal -win $_nWave5 {( "G1" 1 2 )} 
wvSetPosition -win $_nWave5 {("G1" 2)}
wvGetSignalClose -win $_nWave5
wvSetCursor -win $_nWave5 102.632535 -snap {("G2" 0)}
wvZoomAll -win $_nWave5
wvSetCursor -win $_nWave5 3029.810750 -snap {("G2" 0)}
wvDisplayGridCount -win $_nWave3 -off
wvGetSignalClose -win $_nWave3
wvDisplayGridCount -win $_nWave5 -off
wvGetSignalClose -win $_nWave5
wvReloadFile -win $_nWave5
debExit
