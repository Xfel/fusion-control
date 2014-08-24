local formats = {
 fluid = {
  grouped = true,
  exponential = false,
  precision = 0,
  length = 11, --"2 000 000 B"
  unit = "B",
 },
 fluid_small = {
  grouped = true,
  exponential = false,
  precision = 0,
  length = 4, --"10 B"
  unit = "B",
 },
 fluid_type = {
  length = 10 --"Wolframium"
 },
 fluid_rate = {
  grouped = true,
  exponential = false,
  positiveSign = "+",
  precision = 1,
  length = 9, --"+7.8 mB/t"
  unit = "mB/t",
 },
 production_rate = {
  grouped = true,
  exponential = false,
  precision = 1,
  length = 8, --"2.0 mB/t"
  unit = "mB/t",
 },
 production_type = {
  length = 8 --"Platinum"
 },
 energy = {
  grouped = true,
  exponential = false,
  precision = 0,
  length = 11, --"160 000 kEU"
  unit = "kEU",
 },
 energy_rate = {
  grouped = true,
  exponential = false,
  precision = 0,
  length = 10, --"8 192 EU/t"
  unit = "EU/t",
 },
 item = {
  grouped = true,
  exponential = false,
  precision = 0,
  length = 9, --"1 000 000"
  unit = nil,
 },
 cycles = {
  grouped = true,
  exponential = false,
  precision = 0,
  length = 16, --"1 000 000 cycles"
  unit = "cycles",
 },
 percentage ={
  grouped = false,
  exponential = false,
  precision = 0,
  length = 5, --"100 %"
  unit = "%",
 },
 text = {
 },
}

return