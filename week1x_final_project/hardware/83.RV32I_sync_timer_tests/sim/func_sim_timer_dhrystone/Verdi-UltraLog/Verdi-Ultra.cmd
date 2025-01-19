verdiSetActWin -dock widgetDock_<Message>
simSetSimulator "-vcssv" -exec "./simv" -args
debImport "-sv" "-dbdir" "./simv.daidir" "-f" "run.f"
debLoadSimResult \
           /home/std249/2025cpu/week1x_final_project/hardware/83.RV32I_sync_timer_tests/sim/func_sim_timer_dhrystone/wave.fsdb
wvCreateWindow
verdiWindowResize -win $_Verdi_1 "490" "174" "900" "700"
verdiWindowResize -win $_Verdi_1 "490" "174" "900" "700"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
debExit
