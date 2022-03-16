

 
 
 




window new WaveWindow  -name  "Waves for BMG Example Design"
waveform  using  "Waves for BMG Example Design"

      waveform add -signals /map_rom_tb/status
      waveform add -signals /map_rom_tb/map_rom_synth_inst/bmg_port/CLKA
      waveform add -signals /map_rom_tb/map_rom_synth_inst/bmg_port/ADDRA
      waveform add -signals /map_rom_tb/map_rom_synth_inst/bmg_port/DOUTA

console submit -using simulator -wait no "run"
