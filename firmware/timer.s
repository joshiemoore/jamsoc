  .text
  .global rdtime_us
  .global rdtime_ush

rdtime_us:
  rdtime a0
  ret

rdtime_ush:
  rdtimeh a0
  ret
